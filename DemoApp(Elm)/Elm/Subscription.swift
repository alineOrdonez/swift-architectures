//
//  Subscription.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import Foundation

public enum Subscription<Message: Equatable> {
    case timer(interval: TimeInterval, message: Message)
}

extension Subscription: Equatable {
    public static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        switch (lhs, rhs) {
        case let (.timer(interval, message), .timer(interval1, message1)):
            return interval == interval1 && message == message1
        }
    }
}

extension Subscription {
    public func map<B>(_ transform: @escaping (Message) -> B) -> Subscription<B> {
        switch self {
        case let .timer(interval: interval, message: message):
            return .timer(interval: interval, message: transform(message))
        }
    }
}

final class SubscriptionManager<Message: Equatable> {
    var callback: (Message) -> ()
    var timers: [Timer] = []
    
    init(_ callback: @escaping (Message) -> ()) {
        self.callback = callback
    }
    
    func update(subscriptions: [Subscription<Message>]) {
        var newTimers: [Timer] = []
        var oldTimers = timers
        for subscription in subscriptions {
            switch subscription {
            case let .timer(interval: interval, message: message):
                if let index = oldTimers.firstIndex(where: { ($0.userInfo as? Subscription) == subscription }) {
                    let timer: Timer = oldTimers.remove(at: index)
                    newTimers.append(timer)
                } else {
                    newTimers.append(Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [unowned self] _ in
                        self.callback(message)
                    }))
                }
            }
        }
        for old in oldTimers {
            old.invalidate()
        }
        timers = newTimers
        
    }
}
