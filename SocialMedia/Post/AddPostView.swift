//
//  AddPostView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 07/02/2021.
//

import SwiftUI
import UIKit


struct AddPostView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firebase: Firebase
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Namespace var exampleNamespace
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            Color(UIColor.systemBackground).opacity(0.5)
            VStack(spacing: 5){
                HStack{
                    firebase.userImageToDisplay?
                        //Image("man1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(Circle())
                    
                    Text(firebase.user?.displayName ?? "")
                    Spacer()
                    Text(Date().addingTimeInterval(600), style: .date)
                    Text(Date().addingTimeInterval(600), style: .time)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
                Divider()
                
                TextEditor(text: $postsViewModel.newPost.message)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))

                Spacer()
                Divider()
                HStack{
                    Spacer()
                    Button("Cancel"){
                        postsViewModel.addPostIsPresented = false
                    }
                    .foregroundColor(.red)
                    Spacer(minLength: 70)
                    Divider()
                    Spacer(minLength: 70)
                    Button("Post"){
                        guard let userID = firebase.user?.uid else { return }
                        if let userURL = firebase.user?.photoURL {
                            postsViewModel.uploadData(userID: userID, userName: firebase.user?.displayName ?? "", userPhotoURL: userURL)
                        } 
                    }.disabled(postsViewModel.newPost.message.isEmpty)
                    Spacer()
                }
                .frame(height: 25)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
            }
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 250, alignment: .topLeading)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 50, trailing: 20))
            .shadow(color: colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5) , radius: 5)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AddPostView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddPostView()
            .preferredColorScheme(.light)
            .environmentObject(PostsViewModel())
            .environmentObject(Firebase())
    }
}
