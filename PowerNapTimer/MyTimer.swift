//
//  MyTimer.swift
//  PowerNapTimer
//
//  Created by Heli Bavishi on 11/10/20.
//

import Foundation

//Protocol Delegate step 1
protocol MyTimerDelegate: AnyObject {
    func timerSecondTicked()
    func timerHasStopped()
    func timerHasCompleted()
}

class MyTimer {
    
    var timer: Timer?
    var timeLeft: TimeInterval?
    var isOn: Bool {
        if timeLeft == nil {
            return false
        } else {
            return true
        }
    }
    //Step 2 create the delegate varible
    weak var delegate: MyTimerDelegate?
    
    func startTimer(time: TimeInterval) {
        print("Start timer function executed with \(time) seconds.")
        if isOn {
            print("This must be a mistake, there is already a timer running...")
        } else {
            timeLeft = time
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTicked()
            })
        }
    }
    
    func stopTimer() {
        self.timeLeft = nil
        timer?.invalidate()
        print("The user has stopped the timer..")
        delegate?.timerHasStopped()
    }
    
    func timeLeftAsString() -> String {
        let timeRemaining = Int(self.timeLeft ?? 1200) //20 minutes to seconds
        let minRemaining = timeRemaining / 60
        let secRemaining = timeRemaining - (minRemaining * 60)
        
        //timeRemaing = 1199 sec -> 19mins 59sec
        //minRemain == 1199 / 60 = 19
        //19 * 60 = 1140
        //secRemain = 1199 - 1140 = 59
        
       // return String("\(minRemaining) : \(secRemaining)")
        return String(format: "%02d : %02d", arguments: [minRemaining, secRemaining])
    }
    
    func secondTicked() {
        guard let timeLeft = timeLeft else {
            print("Time left is currently set to nil.")
            return
        }
        
        if timeLeft > 0 {
            self.timeLeft = timeLeft - 1
            print(timeLeftAsString())
            delegate?.timerSecondTicked()
        } else {
            self.timeLeft = nil
            timer?.invalidate()
            print("Timer has been stopped")
            delegate?.timerHasCompleted()
        }
    }
    
} // END of class
