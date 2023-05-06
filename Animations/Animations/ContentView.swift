//
//  ContentView.swift
//  Animations
//
//  Created by Terry on 2023/5/5.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonOpacity = 1.0
    
    var body: some View {
        Text("代码在其他文件~")
            .padding(50)
            .foregroundColor(.red)
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
