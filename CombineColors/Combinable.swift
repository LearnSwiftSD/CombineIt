//
//  Combinable.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/18/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit
import Combine

public struct Assignment<Base> {
    
    public let baseInstance: Base
    
    public init(_ base: Base) {
        self.baseInstance = base
    }
    
}

/**
 The `Combinable` protocol allows conformers to accept values
 through the means of an `Assignment`. The `Assignment` can be
 extended to supply various values to the input of the accepting type
 */
public protocol Combinable {
    
    associatedtype BaseType
    
    var input: Assignment<BaseType> { get }
    
}

extension NSObject: Combinable {}

public extension Combinable where Self: NSObject {
    
    var input: Assignment<Self> {
        return Assignment(self)
    }
    
}

// Create our custom operator
extension Publisher where Self.Failure == Never {
    
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// This method creates the subscriber and immediately requests an unlimited number of values, prior to returning the subscriber.
    /// - parameter combinableAssignment: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    public func supply(to combinableAssignment: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return sink(receiveValue: combinableAssignment)
    }
    
}

typealias Cancellables = Set<AnyCancellable>

/**
 The below code comes from an excellent article written by Antoine Van Der Lee.
 The article name is Called "Creating a custom Combine Publisher to extend UIKit"
 It can be found here https://www.avanderlee.com/swift/custom-combine-publisher/
 It's an excellent read and I highly recomend it 👍
 */

/// A custom subscription to capture UIControl target events.
final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        //Ignoring the Subscriber's demand
        _ = subscriber?.receive(control)
    }
}

/// A custom `Publisher` to work with our custom `UIControlSubscription`.
public struct UIControlPublisher<Control: UIControl>: Publisher {

    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event
    
    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// This portion has been changed from the original implementation to better fit the Combinable paradigm 😁
/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
public extension Combinable where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}
