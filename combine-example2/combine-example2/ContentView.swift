//
//  ContentView.swift
//  combine-example2
//
//  Created by phuong.doan on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RepositoriesViewModel()

    var body: some View {
        List(viewModel.repositories) { repo in
            Text(repo.name)
        }
        .onAppear {
            viewModel.loadRepositories()
        }
    }
}

#Preview {
    ContentView()
}
