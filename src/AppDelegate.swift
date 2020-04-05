//
//  AppDelegate.swift
//  DistContactTracing
//
//  Created by Axel Backlund on 2020-03-02.
//  Copyright © 2020 Axel. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        handleSignIn()
        
        setupNotifications()
        application.registerForRemoteNotifications()
        application.setMinimumBackgroundFetchInterval(1800)
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        InfectionManager.shared.downloadInfectedInteractions { result, error in
            if let result = result {
                let hasResult = InfectionManager.shared.findMatch(from: result)
                if !hasResult && application.applicationState == .background {
                    self.showMatchNotification()
                }
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    func showMatchNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alert"
        content.body = "You have been near a person tested positive for COVID-19. Open the app to see next steps."

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func handleSignIn() {
        if Authentication().userID == nil {
            Auth.auth().signInAnonymously() { (authResult, error) in
                guard let user = authResult?.user else { return }
                Authentication().userID = user.uid
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("REPSONSED")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        Messaging.messaging().subscribe(toTopic: "region") { error in
          print("Subscribed to region topic")
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print full message.
        print("Message:", userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
