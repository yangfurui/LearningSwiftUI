//
//  SnakeView.swift
//  Animations
//
//  Created by Terry on 2023/5/6.
//

import SwiftUI

struct SnakeView: View {
    let letters = Array("Hello, SwiftUI")
        @State private var enabled = false
        @State private var dragAmount = CGSize.zero
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<letters.count) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(enabled ? .blue : .red)
                        .offset(dragAmount)
                        .animation(
                            .default.delay(Double(num) / 20),
                            value: dragAmount
                        )
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded({ _ in
                        dragAmount = .zero
                        enabled.toggle()
                    })
            )
        }
}

struct SnakeView_Previews: PreviewProvider {
    static var previews: some View {
        SnakeView()
    }
}
