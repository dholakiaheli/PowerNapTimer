//
//  ViewController.swift
//  PowerNapTimer
//
//  Created by Heli Bavishi on 11/10/20.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{

    //MARK: - Outlets
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: - Properties
    var myTimer = MyTimer()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // step 4 - set the delegate vaule to be self
        myTimer.delegate = self
//        myTimer.startTimer(time: 4)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (authorizatinGranded, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            }
            if authorizatinGranded {
                print("User has given us permission to send notification")
            } else {
                print("User has not given us permission to send notification")
            }
        }
    }
    //MARK: - Action
    @IBAction func startStopButtonTapped(_ sender: Any) {
        if myTimer.isOn {
            myTimer.stopTimer()
        }else {
            myTimer.startTimer(time: 8)
            scheduleNotification(timeInterval: 8)
        }
    }
    
    //MARK: - Helper Functions
    
    func updateLabelAndButton() {
        timeLabel.text = myTimer.timeLeftAsString()
        var title = "Start Nap"
        if myTimer.isOn {
            title = "Stop Nap"
        }
        startStopButton.setTitle(title, for: .normal)
    }
    
    func createAlertController() {
        let alertController = UIAlertController(title: "Time to wake up!", message: "Or may be not...", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "I'm up!", style: .destructive)

        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_)
            in
            let textField = alertController.textFields?.first
            guard let timeAsString = textField?.text,
                  let timeAsDouble = Double(timeAsString) else { return }
            
            self.myTimer.startTimer(time: timeAsDouble * 60)
            self.scheduleNotification(timeInterval: timeAsDouble * 60)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(snoozeAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "How many minutes would you like to snooze?"
            textField.keyboardType = .numberPad
        }
        present(alertController, animated: true)
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP!"
        content.subtitle = "It is time to get going!"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "alarmNotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            } else {
                print("User asked to get a local notification \(timeInterval) seconds from now.")
            }
        }
        
        
    }
    
}
//MARK: - Extensions
//Step 3 - extend to conform to the protocol
extension ViewController: MyTimerDelegate {
    func timerSecondTicked() {
        print("TimerSecondTicked")
        updateLabelAndButton()
    }
    
    func timerHasStopped() {
        print("TimerSecondStopped")
        updateLabelAndButton()
    }
    
    func timerHasCompleted() {
        print("TimerSecondCompleted")
        updateLabelAndButton()
        createAlertController()
    }
}

//Cancel notification - using identifier
