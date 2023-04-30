//
//  ContentView.swift
//  WordScramble
//
//  Created by 杨馥瑞 on 2023/4/28.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWorkds = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        Section {
                            TextField("Enter your word", text: $newWord)
                                .autocapitalization(.none)
                        }
                        
                        Section {
                            ForEach(usedWorkds, id: \.self) { word in
                                HStack {
                                    Image(systemName: "\(word.count).circle.fill")
                                    Text(word)
                                }
                            }
                        }
                    }
                }
                
                Text("Score: \(score)")
                    .font(.largeTitle)
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .toolbar(content: {
                Button("restart", action: restartGame)
            })
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard !isTooShort(word: answer) else {
            wordError(title: "Word too short", message: "It's short")
            return
        }
        
        withAnimation {
            usedWorkds.insert(answer, at: 0)
            score += 1
        }
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restartGame() {
        usedWorkds.removeAll()
        newWord = ""
        startGame()
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWorkds.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
        
    // 判断是否有拼写错误
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isTooShort(word: String) -> Bool {
        word.count < 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
