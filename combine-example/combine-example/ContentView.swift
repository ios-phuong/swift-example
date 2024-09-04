//
//  ContentView.swift
//  combine-example
//
//  Created by phuong.doan on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            TextField("Enter your name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("Hello, \(viewModel.name)!")
                .font(.largeTitle)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
