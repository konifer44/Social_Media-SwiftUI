//
//  ContentView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 06/02/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var firebase: Firebase
    @State private var selectedTab = 1
    
    var body: some View {
        VStack{
            if firebase.user != nil {
                TabView(selection: $selectedTab){
                    PostsView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(1)
                    
                    Text("")
                        // MessagesTabView()
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
                
                
            } else {
                LoginView()
                    .environmentObject(postsViewModel)
            }
        }
        .onChange(of: firebase.user?.uid){_ in
            print("hi")
            if firebase.user != nil {
                postsViewModel.observeForNewPosts()
                postsViewModel.observeForRemovedPosts()
            }
            
        }
        
        .onAppear{
            firebase.listen()
        }
        .onDisappear{
            firebase.removeListener()
        }
        
        .edgesIgnoringSafeArea(.all)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
