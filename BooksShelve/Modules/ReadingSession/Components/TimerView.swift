//
//  TimerView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI

struct TimerView: View {
    @State var sessionSelected: ReadingSession
    
    @State private var isRunning = true
    @State private var display: String = "..."
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 5) {
            Text("SessionDurationInMinutesAndSeconds")
                .font(.caption)
                .foregroundStyle(.gray)
            Text(display.localized)
                .font(.system(size: 40, weight: isRunning ? .bold : .light, design: .monospaced))
                .foregroundColor(isRunning ? .mint : .accentColor)
                .onReceive(timer) { _ in
                    if isRunning {
                        updateDisplay()
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                /*.onTapGesture {
                    if isRunning {
                        stop()
                    } else {
                        display = "00:00"
                        startTime = Date()
                        start()
                    }
                    isRunning.toggle()
                }
                .onAppear {
                    stop()
                }*/
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            if !sessionSelected.isInProgress {
                updateDisplay()
            }
        }
    }
    
    //MARK: Functions
    private func updateDisplay() {
        let date = sessionSelected.endDate ?? Date()
        let duration = date.timeIntervalSince(sessionSelected.startDate)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        display = formatter.string(from: duration) ?? ""
    }
    
    private func stop() {
        timer.upstream.connect().cancel()
    }
    
    private func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

//
//#Preview {
//    TimerView(startTime: Date())
//}
