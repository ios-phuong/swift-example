//
//  ContentViewModel.swift
//  combine-example5
//
//  Created by phuong.doan on 9/9/24.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func debounce() {
        let typingHelloWorld: [(TimeInterval, String)] = [
          (0.0, "H"),
          (0.1, "He"),
          (0.2, "Hel"),
          (0.3, "Hell"),
          (0.5, "Hello"),
          (0.6, "Hello "),
          (2.0, "Hello W"),
          (2.1, "Hello Wo"),
          (2.2, "Hello Wor"),
          (2.4, "Hello Worl"),
          (2.5, "Hello World")
        ]
        //subject
        let subject = PassthroughSubject<String, Never>()
        //debounce publisher
        let debounced = subject
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .share()
        //subscription
        subject
            .sink { string in
                print("\(self.printDate()) - 🔵 : \(string)")
            }
            .store(in: &subscriptions)
        debounced
            .sink { string in
                print("\(self.printDate()) - 🔴 : \(string)")
            }
            .store(in: &subscriptions)
        //loop
        let now = DispatchTime.now()
        for item in typingHelloWorld {
            DispatchQueue.main.asyncAfter(deadline: now + item.0) {
                subject.send(item.1)
            }
        }
    }
    
    func throttle() {
        
        let typingHelloWorld: [(TimeInterval, String)] = [
          (0.0, "H"),
          (0.1, "He"),
          (0.2, "Hel"),
          (0.3, "Hell"),
          (0.5, "Hello"),
          (0.6, "Hello_"),
          (2.0, "Hello W"),
          (2.1, "Hello Wo"),
          (2.2, "Hello Wor"),
          (2.4, "Hello Worl"),
          (2.5, "Hello World")
        ]
        
        //subject
        let subject = PassthroughSubject<String, Never>()
        
        //throttle publisher
        let throttle = subject
            .throttle(for: .seconds(1.0), scheduler: DispatchQueue.main, latest: true)
            .share()
        
        //subscription
        subject
            .sink { string in
                print("\(self.printDate()) - 🔵 : \(string)")
            }
            .store(in: &subscriptions)
        
        throttle
            .sink { string in
                print("\(self.printDate()) - 🔴 : \(string)")
            }
            .store(in: &subscriptions)
        
        //loop
        let now = DispatchTime.now()
        for item in typingHelloWorld {
            DispatchQueue.main.asyncAfter(deadline: now + item.0) {
                subject.send(item.1)
            }
        }
    }
    
    func delay() {
        let valuesPerSecond = 1.0
        let delayInSeconds = 3.0
        let sourcePublisher = PassthroughSubject<Date, Never>()
        let delayedPublisher = sourcePublisher.delay(for: .seconds(delayInSeconds), scheduler: DispatchQueue.main)
        //subscription
        sourcePublisher
            .sink(receiveCompletion: { print("Source complete 🔵: ", $0) }) { print("Source 🔵: ", $0)}
            .store(in: &subscriptions)
        delayedPublisher
           .sink(receiveCompletion: { print("Delay complete 🔴: \($0) - \(Date()) ") }) { print("Delay 🔴: \($0) - \(Date()) ")}
           .store(in: &subscriptions)
        //emit values by timer
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: valuesPerSecond, repeats: true) { _ in
                sourcePublisher.send(Date())
            }
        }
    }
    
//    func timeout() {
//        let subject = PassthroughSubject<Void, Never>()
//        
//        let timeoutSubject = subject.timeout(.seconds(5), scheduler: DispatchQueue.main)
//        
//        subject
//            .sink(receiveCompletion: { print("\(self.printDate()) - 🔵 completion: ", $0) }) { print("\(self.printDate()) - 🔵 : event")}
//            .store(in: &subscriptions)
//        
//        timeoutSubject
//            .sink(receiveCompletion: { print("\(self.printDate()) - 🔴 completion: ", $0) }) { print("\(self.printDate()) - 🔴 : event")}
//            .store(in: &subscriptions)
//        
//        print("\(printDate()) - BEGIN")
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            subject.send()
//        }
//    }
    
    /**
     Toán tử này rất chi là dễ hiểu, bạn cần set cho nó 1 thời gian. Nếu quá thời gian đó mà publisher gốc không có phát bất cứ gì ra thì publisher timeout sẽ tự động kết thúc.
     Còn nếu có giá trị gì mới được phát trong thời gian timeout thì sẽ tính lại từ đầu.
     */
    func timeout() {
        let subject = PassthroughSubject<Void, Never>()
        
        subject
            .handleEvents(receiveOutput: { _ in print("\(self.printDate()) - 🔵 : event") })
            .timeout(.seconds(5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("\(self.printDate()) - 🔴 completion: finished")
                case .failure(let error):
                    print("\(self.printDate()) - 🔴 completion: \(error)")
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
        
        print("\(printDate()) - BEGIN")
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                subject.send()
            }
        }
    }
    
    func printDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.S"
        return formatter.string(from: Date())
    }
}
