//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Terry on 2023/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var computerInstruction = Bool.random()
    
    @State private var showScore = false
    @State private var endGame = false
    
    @State private var result: Bool? = nil
    
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var round = 0
    
    private let moves = ["✊", "✋", "✌️"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .mint]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    Spacer()
                    
                    Text("I WILL PICK")
                        .font(.title)
                    
                    Text("\(moves[computerChoice])")
                        .font(.system(size: 100))
                    
                    Text("\(computerInstruction ? "BEAT ME!" : "Let me WIN?")")
                        .font(.callout)
                    
                    Spacer()
                }
                .alert(scoreTitle, isPresented: $showScore) {
                    Button("Continue") {
                        newRound()
                    }
                } message: {
                    Text(scoreMessage)
                }
                
                HStack {
                    ForEach(moves, id: \.self) { move in
                        Button {
                            judge(move)
                        } label: {
                            Text(move)
                                .font(.system(size: 80))
                        }

                    }
                    .frame(maxWidth: .infinity)
                }
                .alert("GAME OVER", isPresented: $endGame) {
                    Button("RESTART") {
                        resetGame()
                    }
                } message: {
                    Text("Your Final score is \(score)")
                }
                
                Spacer()
                
                Text("SCORE: \(score)")
                    .font(.headline)
            }
        }
    }
    
    func newRound() {
        computerChoice = Int.random(in: 0...2)
        computerInstruction = Bool.random()
        result = nil
    }
    
    func resetGame() {
        newRound()
        round = 0
        score = 0
    }
    
    func judge(_ answer: String) {
        let computer = moves[computerChoice]
        
        if computerInstruction {
            switch computer {
            case "✊": result = answer == "✋"
            case "✋": result = answer == "✌️"
            case "✌️": result = answer == "✊"
            default: result = false
            }
        } else {
            switch computer {
            case "✊": result = answer == "✌️"
            case "✋": result = answer == "✊"
            case "✌️": result = answer == "✋"
            default: result = false
            }
        }
        
        if computer == answer { result = nil }
        
        if let result = result {
            // Win
            if result {
                scoreTitle = "NICE"
                scoreMessage = "You Win!"
                score += 1
            } else { // Lose
                scoreTitle = "BUMMER"
                scoreMessage = "You Lose!"
                score -= 1
            }
        } else { // Draw
            scoreTitle = "RLY?"
            scoreMessage = "Do you even know how to play this game?"
        }
        
        if round == 3 {
            endGame = true
        } else {
            showScore = true
            round += 1
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
