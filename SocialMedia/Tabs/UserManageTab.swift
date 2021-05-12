//
//  LoginView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI
import Firebase

struct UserManageTab: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var firebase: Firebase
    
    var body: some View {
 
            
                UserSettingsView()
                    .environmentObject(postsViewModel)
           
            // .edgesIgnoringSafeArea(.all)
        
    }
}

struct UserManageTab_Previews: PreviewProvider {
    static var previews: some View {
        UserManageTab()
    }
}











