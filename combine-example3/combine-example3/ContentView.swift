//
//  ContentView.swift
//  combine-example3
//
//  Created by phuong.doan on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserPostViewModel() // Initialize the view model
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("User Information")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("Name: \(user.name)")
                            .font(.title2)
                        
                        Text("User ID: \(user.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Divider()
                    
                    List(viewModel.posts, id: \.title) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                        }
                    }
                } else {
                    ProgressView("Loading user and posts...")
                        .padding()
                }
            }
            .navigationTitle("User and Posts")
            .onAppear {
                viewModel.fetchUserAndPosts(userId: 1)
            }
        }
    }
}

#Preview {
    ContentView()
}
