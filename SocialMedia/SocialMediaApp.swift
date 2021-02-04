//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI
import Firebase
import FirebaseStorage
@main
struct SocialMediaApp: App {
    @StateObject var firebase = Firebase()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebase)
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
    }

}
