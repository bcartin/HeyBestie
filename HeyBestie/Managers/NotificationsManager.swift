//
//  NotificationsManager.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/21/21.
//

import UIKit
import UserNotifications
import Firebase

class NotificationsManager: NSObject, MessagingDelegate, UIApplicationDelegate {
    
    private override init() {}
    static let shared = NotificationsManager()
    let unCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard granted else {return}
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func unauthorize() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func configure() {
        unCenter.delegate = self
        Messaging.messaging().delegate = self
        
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
        saveToken()
    }
    
    func notificationsAuthStatus(completion: @escaping(_ status: Bool) -> Void) {
        unCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
        }
    }
    
    func saveToken() {
        if let token = Messaging.messaging().fcmToken {
            UserManager().saveUserData(data: [C_TOKEN:token]) { result in
                switch result {
                    
                case .success(_):
                    print("Notifications Token Saved")
                case .failure(let error):
                    print("Error saving token: ", error.localizedDescription)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        subscribeToNotifications(topic: C_EVERYONE)
        guard let token = fcmToken else {return}
        UserManager().saveUserData(data: [C_TOKEN:token]) { result in
            switch result {
                
            case .success(_):
                print("Notifications Token Saved")
            case .failure(let error):
                print("Error saving token: ", error.localizedDescription)
            }
        }
        
    }
    
    func subscribeToNotifications(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic)
    }
    
    func unsubscribeFromNotifications(topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic)
    }
    
    
}

extension NotificationsManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
    }
    
}

extension NotificationsManager {
    
    func createWaterNotificationRequest() {
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = C_WATER
        let content = UNMutableNotificationContent()
        content.body = "Get a fresh start on your water intake today with a refreshing morning glass of water!"
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger1)
        unCenter.add(request) { error in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("Morning Water Notification Added")
            }
        }
        
        dateComponents.hour = 15
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        content.body = "You should have had 4 glasses of water today already."
        let request2 = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger2)
        unCenter.add(request2) { error in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("Afternoon Water Notification Added")
            }
        }
        
        dateComponents.hour = 20
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        content.body = "Did you drink 8 glasses of water today?"
        let request3 = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger3)
        unCenter.add(request3) { error in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("Evening Water Notification Added")
            }
        }
    }
    
    func createMeditationNotificationRequest() {
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 15
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = C_MEDITATION
        let content = UNMutableNotificationContent()
        content.body = "It’s time for morning meditation. Manifest a productive day today by spending 15 minutes setting your intentions for the day."
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        unCenter.add(request) { error in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("Meditation Notification Added")
            }
        }
    }
    
    func createSkincareNotificationRequest() {
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = C_SKINCARE
        let content = UNMutableNotificationContent()
        content.body = "If you haven’t already, it’s time to do your skincare routine!"
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        unCenter.add(request) { error in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("Skincare Notification Added")
            }
        }
    }
    
    func deleteNotificationRequest(identifiers: [String]) {
        unCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Deleted \(identifiers) notifications")
    }
    
    func listDateNotificationRequests() {
        unCenter.getPendingNotificationRequests { (requests) in
            print(requests)
        }
    }
    
    func deleteAllDateNotificationRequests() {
        unCenter.removeAllPendingNotificationRequests()
        print("All notifications removed")
    }
    
}

