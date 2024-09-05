//
//  ContentView.swift
//  combine-example6
//
//  Created by phuong.doan on 9/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        List(viewModel.repositories) { repo in
            Text(repo.name)
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    ContentView()
}
