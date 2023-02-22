//
//  UIControl+Extension.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }
    
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, event: event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
    
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, event: UIControl.Event, subscriber: EventSubscriber) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc private func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}

extension UITextField {
    var textChangePublisher: AnyPublisher<String, Never> {
        return controlPublisher(for: .editingChanged)
            .compactMap { ($0 as? UITextField)?.text as? String }
            .eraseToAnyPublisher()
    }
}

extension UITextView {
    var textChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification)
            .compactMap { ($0.object as? UITextView)?.text }
            .eraseToAnyPublisher()
    }
}
