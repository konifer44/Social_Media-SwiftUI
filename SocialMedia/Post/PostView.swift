//
//  PostView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 06/02/2021.
//

import SwiftUI
import CoreHaptics

struct PostView: View {
    @State private var hapticFeedback = UINotificationFeedbackGenerator()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var firebase: Firebase
    @State private var unwrappedUID : String = ""
    
    private var post: PostModel
    init(post: PostModel) { self.post = post }
    
    let fakeShares = Int.random(in: 50...55)
    let fakeComments = Int.random(in: 60...65)
    
    var body: some View {
        VStack(spacing: 5){
            HStack{
                post.userPhoto?
                    .resizable()
                    .frame(width: 55, height: 55, alignment: .center)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(post.userName)
                        .fontWeight(.bold)
                    HStack{
                        Text( Date(timeIntervalSince1970: Double(post.creationTime!)), style: .date)
                        Text( Date(timeIntervalSince1970: Double(post.creationTime!)), style: .time)
                    }
                    .foregroundColor(.gray)
                }
                Spacer()
               
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
            Divider()
            
            
            HStack {
                Text(post.message)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
                Spacer()
            }
            .padding(.leading, 50)
            Spacer()
            Divider()
            HStack{
                Spacer()
                Button(action: {
                    postsViewModel.likePost(post: post, by: unwrappedUID)
                    if !post.isLikedByCurrentUser {
                        self.hapticFeedback.notificationOccurred(.success)
                    }
                    
                }
                , label: {
                    
                    Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                    Text("\(post.likes)")
                })
                Spacer()
                Image(systemName: "square.and.arrow.up")
                Text("\(fakeShares)")
                Spacer()
                Image(systemName: "text.bubble")
                Text("\(fakeComments)")
                Spacer()
                
            }
            .frame(height: 25)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
        }
        
        .onAppear{
            print("on appear")
            guard let uid = firebase.user?.uid else { return }
            unwrappedUID = uid
            postsViewModel.isLikedByCurrentUser(post: post, by: unwrappedUID)
            postsViewModel.observeForNewLikes(postID: post.postID)
        }
        .onDisappear{
            // postsViewModel.removeLikeObserver(postID: post.postID)
        }
        
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 250, maxHeight: 400, alignment: .topLeading)
        .background(Color(.systemGray6))//(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .contextMenu {
            Button {
                postsViewModel.likePost(post: post, by: unwrappedUID)
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
                    postsViewModel.removePost(postID: post.postID)
                } label: {
                    Label("Delete Post", systemImage: "trash")
                }
            }
            
        }//.buttonStyle(PlainButtonStyle())
        //.padding(5)
    }
}

struct PostView_Previews: PreviewProvider {
    private let images = ["man1", "man2", "women"]
    static var previews: some View {
        PostView(post: PostModel(userID: "user id", userName: "Jan", userPhotoURL: "", message: "I konfederacje", likes: 110))
    }
}

let loremIpsum = "I was born in 1955 and raised by adoptive parents in Cupertino, California. Though he was interested in engineering, his passions as a youth varied. After dropping out of Reed College, I worked as a video game designer at Atari and later went to India to experience Buddhism."
