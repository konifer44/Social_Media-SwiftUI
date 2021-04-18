//
//  PostsView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 07/02/2021.
//

import SwiftUI

struct PostsView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            NavigationView{
               
                ScrollView{
                    ForEach(postsViewModel.posts, id: \.self) {
                        Spacer().frame(height: postsViewModel.addPostIsPresented ? 100 : 0)
                        PostView(post: $0)
                            .shadow(color: colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5) , radius: 2)
                            .padding(10)
                            .environmentObject(postsViewModel)
                            .buttonStyle(PlainButtonStyle())
                    }
                    .blur(radius: postsViewModel.addPostIsPresented ? 10 : 0)
                }
                .navigationBarTitle("News Feed")
                
                
            }
            if postsViewModel.addPostIsPresented {
                AddPostView()
            } else {
                Button(action: {
                    postsViewModel.addPostIsPresented = true
                }, label: {
                    
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 55))
                        .background(Color.white)
                        .clipShape(Circle())
                    
                })
                .position(x: 350, y: 700)
            }
           
        }
        .onAppear{
            //postsViewModel.observeForNewPosts()
        }
        .onDisappear{
            postsViewModel.removeAllObservers()
        }
    }
}
struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        
        PostsView()
            .environmentObject(PostsViewModel())
    }
}


/*
 ZStack{
 Color(.systemGray5).edgesIgnoringSafeArea(.all)
 ScrollView{
 
 }
 
 if postsViewModel.addPostIsPresented {
 AddPostView()
 } else {
 Button(action: {
 postsViewModel.addPostIsPresented = true
 }, label: {
 
 Image(systemName: "pencil.circle.fill")
 .font(.system(size: 55))
 .background(Color.white)
 .clipShape(Circle())
 
 })
 .position(x: 350, y: 700)
 }
 }
 
 
 
 */
