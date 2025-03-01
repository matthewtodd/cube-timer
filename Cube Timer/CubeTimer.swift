//
//  CubeTimer.swift
//  Cube Timer
//
//  Created by Matthew Todd on 2/17/25.
//

import Combine
import SwiftUICore
import UIKit


class CubeTimer: ObservableObject {
    enum State {
        case zero
        case countingDown
        case running
        case stopped
    }
    
    @Published var time: Duration = .zero
    
    private var state: State = .zero
    private var timer: Timer?
    
    func advance() {
        switch state {
        case .zero:
            countDown()
        case .countingDown:
            return // no-op
        case .running:
            stop()
        case .stopped:
            reset()
        }
    }
    
    private func countDown() {
        let startTime = Date()
        state = .countingDown
        UIApplication.shared.isIdleTimerDisabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.019, repeats: true) { _ in
            self.time = max(.seconds(15 + startTime.timeIntervalSinceNow), .zero)
            if self.time == .zero {
                self.timer?.invalidate()
                self.start()
            }
        }
    }

    private func start() {
        let startTime = Date()
        state = .running
        UIApplication.shared.isIdleTimerDisabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.019, repeats: true) { _ in
            self.time = .seconds(-startTime.timeIntervalSinceNow)
        }
    }
    
    private func stop() {
        state = .stopped
        UIApplication.shared.isIdleTimerDisabled = false
        timer?.invalidate()
    }
    
    private func reset() {
        state = .zero
        time = .zero
    }
}
