//
//  ContentView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var firebase: Firebase
    @State private var selectedTab = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab){
                NewsFeedTabView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(1)
                
                MessagesTabView()
                    .tabItem {
                        Image(systemName: "text.bubble")
                        Text("Messages")
                    }
                    .tag(2)
                
                NotificationsTabView()
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
                    .tag(3)
                
                UserManageTab()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Account")
                    }
                    .tag(4)
                
            }
          
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .clipShape(Circle())
                .position(x: 350, y: 750)
        }
        .onAppear{
            firebase.listen()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
