//
//  ContentView.swift
//  notificationTest
//
//  Created by 하연주 on 2023/07/28.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Button{
            NotificationCenter.default.post(name: Notification.Name("pressBtn"), object: nil)
            print("🍑🍑🍑🍑 create notification")
            
//            Messaging.messaging().token { token, error in
//              if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//              } else if let token = token {
//                print("FCM registration token: \(token)")
////                self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//              }
//            }
        } label: {
            Text("create notification")
        }
        
            .padding()
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
