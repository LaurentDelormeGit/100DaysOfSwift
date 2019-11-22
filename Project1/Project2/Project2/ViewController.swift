//
//  ViewController.swift
//  Project2
//
//  Created by Laurent Delorme on 11/08/2019.
//  Copyright © 2019 Laurent Delorme. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var previousScore = 0
    var score = 0
    var correctAnswer = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "score") as? Data {
            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Int {
                previousScore = decodedData
            }
        }
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
     
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderColor = UIColor.black.cgColor
        
        askQuestion()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
        registerLocal()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
//        title = "Game [ \(counter) ] Score : [ \(score) ] Find : \(countries[correctAnswer].uppercased())"
        counter += 1
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            save()
        } else {
            title = "Nop! Correct flag is n°\(correctAnswer + 1)"
            score -= 1
            save()
        }
        
        if score < 10 {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            sender.transform = .identity
        
        } else {
            let ac = UIAlertController(title: title, message: "Victory ! Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
            score = 0
            counter = 0
            save()
        }
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Score", message: "You score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: score, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "score")
        }
    }
    
    @objc func registerLocal() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Authorization granted")
                    self.printStuff()
                    self.scheduleLocal()
                } else {
                    print("Authorization denied")
                }
            }
        }
        
        @objc func scheduleLocal() {
            registerCategories()
            
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            
            let content = UNMutableNotificationContent()
            content.title = "Late wake up call"
            content.body = "The early bird catches the worm, but the second mouse gets the cheese."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default
            
    //        var dateComponents = DateComponents()
    //        dateComponents.hour = 10
    //        dateComponents.minute = 30
    //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            print("done")
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        
        }
        
        func registerCategories() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let show = UNNotificationAction(identifier: "show", title: "Show me more", options: .foreground)
            let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .destructive)
            let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [], options: [])
            center.setNotificationCategories([category])
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            // pull out the buried userInfo dictionary
            let userInfo = response.notification.request.content.userInfo
            
            if let customData = userInfo["customData"] as? String {
                print("Custom data received = \(customData)")
                
                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    // The user swiped to unlock
                    print("default identifier")
                    
                    let ac = UIAlertController(title: "default opening", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(ac, animated: true)
                    
                case "show" :
                    // the user tapped our "show more info…" button
                    print("show more information...")
                    
                    let ac = UIAlertController(title: "custom button show tapped", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(ac, animated: true)
                    
                case "reminder" :
                    scheduleLocal()
                    
                default :
                    break
                }
            }
            
            // you must call the completion handler when you're done
            completionHandler()
        }
    
    func printStuff() {
        print("stuff")
    }
    
}

