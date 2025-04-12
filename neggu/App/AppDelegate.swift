//
//  AppDelegate.swift
//  neggu
//
//  Created by 유지호 on 1/6/25.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import AppsFlyerLib

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppsFlyerLib.shared().start()
//    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
 
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        #if DEBUG
        print(userInfo)
        #endif
        
        return [[.banner, .sound]]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        
        #if DEBUG
        print(userInfo)
        #endif
    }
    
}


extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        #if DEBUG
        print("Firebase registration token: \(String(describing: fcmToken))")
        #endif
        
        UserDefaultsKey.User.fcmToken = fcmToken
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
}
