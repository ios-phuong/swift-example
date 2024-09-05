//
//  ContentView.swift
//  combine-example5
//
//  Created by phuong.doan on 9/5/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
//            combineLatest()
//            zip()
//            retry()
            catchOperator()
        }
    }
    
    //Combines the latest values of two or more publishers whenever any of them emit a new value.
    func combineLatest() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()

        let cancellable = publisher1
            .combineLatest(publisher2)
            .sink { print("Received \($0) and \($1)") }

        publisher1.send(1)
        publisher2.send("A")
        publisher2.send("B")
        //Received 1 and A
        //Received 1 and B
    }
    
    //Combines values from two publishers into tuples, emitting only when both publishers have emitted
    func zip() {
        let numbers = [1, 2, 3, 4, 5].publisher
        let string = ["A", "B", "C"].publisher
        
        let cancellable = Publishers.Zip(numbers, string)
            .sink {
                print($0)
            }
        //(1, "A")
        //(2, "B")
        //(3, "C")
    }
    
    func retry() {
        var attemptCount = 0
        let publisher = Fail<Int, Error>(error: URLError(.badServerResponse))
            .tryCatch { error -> Just<Int> in
                attemptCount += 1
                if attemptCount >= 3 {
                    return Just(1)
                } else {
                    print("error")
                    throw error
                }
            }
            .retry(2)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                print(value)
            })
    }

    func catchOperator() {
        let numbers = [1, 2, 3, 4, 5].publisher

        let cancellable = numbers
            .tryMap { value -> Int in
                if value == 3 {
                    throw URLError(.badServerResponse)
                }
                return value
            }
            .catch { _ in
                Just(0)  // Provide a fallback value of 0 if an error occurs
            }
            .sink { print($0) }

        // Output: 1, 2, 0
    }
}

#Preview {
    ContentView()
}
