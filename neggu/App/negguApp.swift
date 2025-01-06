//
//  negguApp.swift
//  neggu
//
//  Created by 유지호 on 8/3/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct negguApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    @StateObject private var authCoordinator = AuthCoordinator()
    
    @StateObject private var authViewModel: AuthViewModel = .init()
    
    init() {
        DIContainer.shared.registerPresentationDependencies()
        
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
        
        // MARK: Version Check API
        print(Util.appVersion)
    }
    
    var body: some Scene {
        WindowGroup {
//            if showTabFlow {
//                ContentView()
//            } else {
//                NavigationStack(path: $authCoordinator.path) {
//                    authCoordinator.buildScene(.login)
//                        .navigationDestination(for: AuthCoordinator.Destination.self) { destination in
//                            authCoordinator.buildScene(destination)
//                        }
//                }
//                .environmentObject(authCoordinator)
//                .onOpenURL { url in
//                    if AuthApi.isKakaoTalkLoginUrl(url) {
//                        _ = AuthController.handleOpenUrl(url: url)
//                    } else {
//                        GIDSignIn.sharedInstance.handle(url)
//                    }
//                }
//            }
            LookBookEditView()
        }
    }
}


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
