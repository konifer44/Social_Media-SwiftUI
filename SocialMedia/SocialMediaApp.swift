//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 06/02/2021.
//

import SwiftUI
import Firebase

@main
struct SocialMediaApp: App {
    @StateObject var firebase = Firebase()
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebase)
        }
    }
    
   
//    class AppDelegate: NSObject, UIApplicationDelegate {
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            //FirebaseApp.configure()
//         //   Database.database().isPersistenceEnabled = true
//            return true
//        }
//    }

}
