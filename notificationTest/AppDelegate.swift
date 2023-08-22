//
//  AppDelegate.swift
//  notificationTest
//
//  Created by 하연주 on 2023/07/31.
//

import Foundation
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate{
    
    //🌈🌈 firebase cloud messaging🌈🌈
//    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //🌈🌈 firebase cloud messaging🌈🌈
        FirebaseApp.configure()
        //🌈🌈 firebase cloud messaging🌈🌈
        Messaging.messaging().delegate = self //extension AppDelegate: MessagingDelegate {} 생성해주어야함
        
        remoteNotificationsRegistration(application)
        UNUserNotificationCenter.current().delegate = self
        
        //NotificationCenter.default.post를 통해 만들어진 알림을 수신하기 위해 observer를 추가해놓는다
//        NotificationCenter.default.addObserver(forName: Notification.Name("pressBtn"), object: nil, queue: nil) { _ in
//          // Handler ...
//          print("🍑🍑🍑🍑 Button was Pressed!")
//        }
//        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: nil) { _ in
//            print("스크린샷 감지!")
//
//        }

        
        return true
    }
    
    func remoteNotificationsRegistration(_ application: UIApplication) {
        print("remoteNotificationsRegistration -- ")
        //사용자에게 알림 권한 요청
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in //options: [.alert, .badge, .sound, .provisional]
            guard error == nil else {
                print("🌸Error while requesting permission for notifications.")
                return
            }
            
            print("🌸Success while requesting permission for notifications.")
            DispatchQueue.main.async {
                //⭐️⭐️remote notificaiton⭐️⭐️ APNs에 디바이스 토큰 등록
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    
    //⭐️⭐️remote notificaiton⭐️⭐️ 디바이스가 APNs에 등록실패했을 때
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification fail register")
        print(error.localizedDescription)
        print(error)
    }
    
    //⭐️⭐️remote notificaiton⭐️⭐️ 디바이스가 APNs에 등록되었을 때
    //위 코드의 registerForRemoteNotifications() 메서드를 통해 RemoteNotification이 등록되면 호출
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification did register -- deviceToken")
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print(deviceTokenString)
        
        //🌈🌈 firebase cloud messaging🌈🌈
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("🌸🌸🌸🌸🌸🌸RemoteNotification did Receive Remote Notification")
//
//
//
//
//        //🌈🌈 firebase cloud messaging🌈🌈
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//        }
//
//        print("🌈🌈userInfo",userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//
//    }
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    // 앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
    
    /*
    //두 가지 경우에 호출된다. 1.사용자가 노티를 종료했을 때 2.사용자가 노티를 클릭하여 앱을 열었을 때

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
        print("Body: \(response.notification.request.content.body)")
        print("userInfo: \(response.notification.request.content.userInfo)")
            
        let userInfo = response.notification.request.content.userInfo
            
        // Notification 분기처리
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SESAC PROJECT")
        }else {
            print("NOTHING")
        }
    }
    */
    
    
    /*
    // push를 탭한 경우 처리 (local notification 이든, remote notification 이든 푸쉬 알림 온 것을 탭했을 때 )
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🌸🌸 알림 탭")

        // deep link처리 시 아래 url값 가지고 처리
        let url = response.notification.request.content.userInfo
        print("🌸 알림 body ==> \(response.notification.request.content.body)")
        print("🌸 알림 왔을 때 그 push 를 탭한 경우 ==> url = \(url)")
        
        
        //https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0
        let application = UIApplication.shared
        
        //앱이 켜져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .active {
            print("푸쉬알림 탭(앱 켜져있음)")
        }
        
        //앱이 꺼져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .inactive {
          print("푸쉬알림 탭(앱 꺼져있음)")
        }
        
        
//        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index":1])
        

    }
    */
    
}


//🌈🌈 firebase cloud messaging🌈🌈 :
//import Firebase 해야함
extension AppDelegate: MessagingDelegate {
    //토큰의 갱신을 모니터링한다
    //일반적으로 앱 시작 시 등록 토큰을 사용하여 이 메서드를 한 번 호출
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("🌈🌈 Device token: ", deviceToken) // This token can be used for testing notifications on FCM
//        NotificationCenter.default.post(
//          name: Notification.Name("FCMToken"),
//          object: nil,
//          userInfo: deviceToken
//        )
    }
}
