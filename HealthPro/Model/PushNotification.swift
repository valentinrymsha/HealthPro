//
//  PushNotification.swift
//  HealthPro
//
//  Created by User on 9/1/22.
//

import UIKit
import UserNotifications

class PushNotification: NSObject {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    static func pushNote(_ message: String,_ timeinterval: Double) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hello, \(UsersData.userDefault.string(forKey: "currentUser") ?? "User" )"
        content.subtitle = message
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
 
}

extension PushNotification: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
   
}
