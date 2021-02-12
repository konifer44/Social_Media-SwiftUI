//
//  PostView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 06/02/2021.
//

import SwiftUI

struct PostView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var firebase: Firebase
    @State private var isLiked = false
    @State private var unwrappedUID : String = ""
    
    private var post: PostModel
    private let images = ["man1", "man2", "women"]
    
    init(post: PostModel) {
        self.post = post
    }
    
    var body: some View {
            VStack(spacing: 5){
                HStack{
                    Image(images.randomElement()!)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Text( Date(timeIntervalSince1970: Double(post.creationTime!)), style: .date)
                    Text( Date(timeIntervalSince1970: Double(post.creationTime!)), style: .time)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
                Divider()
                
                
                HStack {
                    Text(post.message)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
                    Spacer()
                }
                
                Spacer()
                Divider()
                
                HStack{
                    Spacer()
                    Button(action: {
                        postsViewModel.like(postID: post.postID, userID: unwrappedUID)
                    }
                    , label: {
                        
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                        Text("\(post.likes)")
                    })
                    
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                    Text("50")
                    Spacer()
                    Image(systemName: "text.bubble")
                    Text("50")
                    Spacer()
                }
                .frame(height: 25)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
            }
            .onDisappear()
            .onAppear{
                postIsLiked()
                guard let uid = firebase.user?.uid else { return }
                unwrappedUID = uid
            }
            .contextMenu {
                Button {
                    postsViewModel.like(postID: post.postID, userID: unwrappedUID)
                } label: {
                    Label("Like", systemImage: "hand.thumbsup")
                }
                
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    
                } label: {
                    Label("Comment", systemImage: "text.bubble")
                }
                if post.userID == unwrappedUID {
                    Button {
                        postsViewModel.removePost(postID: post.postID, userID: unwrappedUID)
                    } label: {
                        Label("Delete Post", systemImage: "trash")
                    }
                }
            
            }  .buttonStyle(PlainButtonStyle())
            
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 250, maxHeight: 250, alignment: .topLeading)
            .background(Color(.systemGray5))//(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5) , radius: 5)
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))

        //.padding(5)
    }
    
    func postIsLiked() {
        postsViewModel.isLikedByCurrentUser(userID: firebase.user!.uid, postID: post.postID) { isLiked in
            self.isLiked = isLiked
        }
    }
}

struct PostView_Previews: PreviewProvider {
    private let images = ["man1", "man2", "women"]
    static var previews: some View {
        PostView(post: PostModel(userID: "user id", message: "I konfederacje", likes: 110))
    }
}

let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
