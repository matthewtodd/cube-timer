//
//  ContentView.swift
//  Cube Timer
//
//  Created by Matthew Todd on 2/16/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    enum TimerState {
        case zero
        case running
        case stopped
        
        func tick(_ content: ContentView) {
            if self == .running {
                content.tick()
            }
        }
        
        func advance(_  content: ContentView) {
            switch self {
            case .zero:
                content.start()
            case .running:
                content.stop()
            case .stopped:
                content.reset()
            }
        }
    }
    
    @State private var state: TimerState = .zero
    @State private var startTime = Date()
    @State private var duration: Duration = .zero
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    private let format: Duration.TimeFormatStyle = .time(pattern: .minuteSecond(padMinuteToLength: 2, fractionalSecondsLength: 3))
    
    func start() {
        state = .running
        startTime = Date()
    }
    
    func tick() {
        duration = .seconds(-startTime.timeIntervalSinceNow)
    }
    
    func stop() {
        state = .stopped
    }
    
    func reset() {
        state = .zero
        duration = .zero
    }
    
    var body: some View {
        Text(format.format(duration))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .font(.system(size: 72, design: .monospaced))
            .onReceive(timer) { _ in state.tick(self) }
            .onTapGesture { state.advance(self) }
    }
    
}

#Preview {
    ContentView()
}
