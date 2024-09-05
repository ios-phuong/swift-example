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
//            catchOperator()
            exampleThrottle()
        }
    }
    
    //Combines the latest values of two or more publishers whenever any of them emit a new value.
    func combineLatest() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()

        let _ = publisher1
            .combineLatest(publisher2)
            .sink { value in
                print("Received \(value.0) and \(value.1)")
            }

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
        
        let _ = Publishers.Zip(numbers, string)
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
                
                print("\(attemptCount)")
                
                if attemptCount == 5 {
                    return Just(100)
                }
                throw error
            }
            .retry(10)
        
        let subscriber = AnySubscriber<Int, Error>(
            receiveSubscription: { subscription in
                subscription.request(.unlimited)
            },
            receiveValue: { value in
                print(value)
                return .unlimited
            },
            receiveCompletion: { completion in
                print(completion)
            }
        )
        publisher.subscribe(subscriber)
    }

    func catchOperator() {
        let numbers = [1, 2, 3, 4, 5].publisher

        let _ = numbers
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
    
    func exampleThrottle() {
        let subject = PassthroughSubject<String, Never>()

        let _ = subject
            .throttle(for: .seconds(2), scheduler: RunLoop.main, latest: true)
            .sink { print($0) }

        subject.send("Hello")
        subject.send("World")
        subject.send("Combine")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            subject.send("Swift")
        }
        
        RunLoop.main.run(until: Date().addingTimeInterval(5))
    }
}

#Preview {
    ContentView()
}
