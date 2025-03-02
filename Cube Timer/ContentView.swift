//
//  ContentView.swift
//  Cube Timer
//
//  Created by Matthew Todd on 2/16/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var timer = CubeTimer()
    
    var body: some View {
        Text(timer.content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .font(.system(size: 72, design: .monospaced))
            .onTapGesture { timer.advance() }
    }
    
}

#Preview {
    ContentView()
}
