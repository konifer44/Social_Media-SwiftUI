//
//  PostsView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 07/02/2021.
//

import SwiftUI

struct PostsView: View {
    @StateObject var postsViewModel = PostsViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
               
                VStack {
                  //  Spacer().frame(height: postsViewModel.addPostIsPresented ? 100 : 0)
                    List(postsViewModel.posts, id: \.self) {
                       
                        PostView(post: $0)
                            .environmentObject(postsViewModel)
                            .listRowInsets(EdgeInsets())
                            .transition(.slide)
                    }
                   
                    .listStyle(PlainListStyle())
//                    .navigationBarTitle("Posts")
//                    .navigationBarHidden(postsViewModel.addPostIsPresented ? true : false)
                    .blur(radius: postsViewModel.addPostIsPresented ? 10 : 0)
                }
                
            }
            
            Button(action: {
                postsViewModel.addPostIsPresented = true
            }, label: {

                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 55))
                    .background(Color.white)
                    .clipShape(Circle())
                
            })
            .position(x: 350, y: 700)
            
            if postsViewModel.addPostIsPresented {
                AddPostView()
                    .environmentObject(postsViewModel)
                    
                
            }
        }
        .onAppear(perform: {
            postsViewModel.fetchData()
        })
        
        
        
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
        
    }
}
