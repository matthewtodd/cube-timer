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
    static private let COUNTDOWN_TIME: Double = 15.0
    static private let PROMPT: String = String(format: "%.0f", COUNTDOWN_TIME)
    static private let TIMER_INTERVAL: Double = 0.019
    static private let FORMAT: Duration.TimeFormatStyle = .time(pattern: .minuteSecond(padMinuteToLength: 2, fractionalSecondsLength: 3))

    enum State {
        case ready
        case countingDown
        case running
        case stopped
    }

    @Published var content: String = PROMPT

    private var state: State = .ready
    private var timer: Timer?

    func advance() {
        switch state {
        case .ready:
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
        var time: Double = CubeTimer.COUNTDOWN_TIME

        state = .countingDown
        UIApplication.shared.isIdleTimerDisabled = true

        timer = Timer.scheduledTimer(withTimeInterval: CubeTimer.TIMER_INTERVAL, repeats: true) { _ in
            time = (CubeTimer.COUNTDOWN_TIME + startTime.timeIntervalSinceNow).rounded(.awayFromZero)

            if time > 0.0 {
                self.content = String(format: "%.0f", time)
            } else {
                self.timer?.invalidate()
                self.start()
            }
        }
    }

    private func start() {
        let startTime = Date()
        var time: Double = 0.0

        state = .running
        UIApplication.shared.isIdleTimerDisabled = true

        timer = Timer.scheduledTimer(withTimeInterval: CubeTimer.TIMER_INTERVAL, repeats: true) { _ in
            time = -startTime.timeIntervalSinceNow
            self.content = CubeTimer.FORMAT.format(.seconds(time))
        }
    }
    
    private func stop() {
        state = .stopped
        UIApplication.shared.isIdleTimerDisabled = false
        timer?.invalidate()
    }
    
    private func reset() {
        state = .ready
        content = CubeTimer.PROMPT
    }
}
