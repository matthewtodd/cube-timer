//
//  CubeTimer.swift
//  Cube Timer
//
//  Created by Matthew Todd on 2/17/25.
//

import Combine
import SwiftUICore


class CubeTimer: ObservableObject {
    enum State {
        case zero
        case running
        case stopped
    }
    
    @Published var time: Duration = .zero
    
    private var state: State = .zero
    private var timer: Timer?
    
    func advance() {
        switch state {
        case .zero:
            start()
        case .running:
            stop()
        case .stopped:
            reset()
        }
    }
    
    private func start() {
        let startTime = Date()
        state = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.time = .seconds(-startTime.timeIntervalSinceNow)
        }
    }
    
    private func stop() {
        state = .stopped
        timer?.invalidate()
    }
    
    private func reset() {
        state = .zero
        time = .zero
    }
}
