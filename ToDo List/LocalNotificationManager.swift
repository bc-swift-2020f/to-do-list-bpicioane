//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Brenden Picioane on 10/4/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import UIKit
import UserNotifications


struct LocalNotificationManager {
    
    static func authorizeLocalNotifications(viewController: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("access granted")
            } else {
                print("access denied")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select ToDo List > Notifications > Allow Notifications.")
                }
            }
        }
    }
    
    static func isAuthorized(completed: @escaping (Bool)->()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                completed(false)
                return
            }
            if granted {
                print("access granted")
                completed(true)
            } else {
                print("access denied")
                completed(false)
            }
        }
    }
    
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date : Date) -> String {
        //create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("L. \(error.localizedDescription)")
            }
            else {
                print("W. \(notificationID), \(content.title)")
            }
        }
        return notificationID
    }
    
}
