//
//  UIView+Gesture.swift
//  Meniny Lab
//
//  Blog  : https://meniny.cn
//  Github: https://github.com/Meniny
//
//  No more shall we pray for peace
//  Never ever ask them why
//  No more shall we stop their visions
//  Of selfdestructing genocide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  Screams of terror, panic spreads
//  Bombs are raining from the sky
//  Bodies burning, all is dead
//  There's no place left to hide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  (A voice was heard from the battle field)
//
//  "Couldn't care less for a last goodbye
//  For as I die, so do all my enemies
//  There's no tomorrow, and no more today
//  So let us all fade away..."
//
//  Upon this ball of dirt we lived
//  Darkened clouds now to dwell
//  Wasted years of man's creation
//  The final silence now can tell
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  When I wrote this code, only I and God knew what it was.
//  Now, only God knows!
//
//  So if you're done trying 'optimize' this routine (and failed),
//  please increment the following counter
//  as a warning to the next guy:
//
//  total_hours_wasted_here = 0
//
//  Created by Elias Abel on 2018/1/8.
//  Copyright © 2018 Meniny Lab. All rights reserved.
//

public extension Gesture where Self: UIView {
    /**
        Attaches a gesture recognizer to the view for all its states.
    
        - parameter gesture: An object whose class descends from the UIGestureRecognizer class
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func on<T: UIGestureRecognizer>(_ gesture: T, _ callback: @escaping (T) -> Void) -> Self {
        let actor = Actor(gesture: gesture, callback: callback)
        
        self.addGestureRecognizer(actor, gesture)
        
        return self
    }
    
    /**
        Attaches a gesture recognizer to the view for a given state.
    
        - parameter gesture: An object whose class descends from the UIGestureRecognizer class
    
        - parameter state: The state the gesture recognizer should be in
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func on<T: UIGestureRecognizer>(_ gesture: T, _ state: UIGestureRecognizerState, _ callback: @escaping (T) -> Void) -> Self {
        let actor = Actor(gesture: gesture, states: [state], callback: callback)
        
        self.addGestureRecognizer(actor, gesture)
        
        return self
    }
    
    /**
        Attaches a gesture recognizer to the view for multiple states.
    
        - parameter gesture: An object whose class descends from the UIGestureRecognizer class
    
        - parameter states: The states the gesture recognizer should be in
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func on<T: UIGestureRecognizer>(_ gesture: T, _ states: [UIGestureRecognizerState], _ callback: @escaping (T) -> Void) -> Self {
        let actor = Actor(gesture: gesture, states: states, callback: callback)
        
        self.addGestureRecognizer(actor, gesture)
        
        return self
    }
    
    /**
        Attaches a gesture recognizer to the view and declares callbacks for its different states.
    
        - parameter gesture: An object whose class descends from the UIGestureRecognizer class
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func on<T: UIGestureRecognizer>(_ gesture: T, _ callbacks: [UIGestureRecognizerState: (T) -> Void]) -> Self {
        let actor = Actor(gesture: gesture, callbacks: callbacks)
        
        self.addGestureRecognizer(actor, gesture)
        
        return self
    }
    
    fileprivate func addGestureRecognizer<T>(_ actor: Actor<T>, _ gesture: T) {
        guard let proxy = actor.proxy else { return }
        
        gesture.addTarget(proxy, action: .recognized)
        self.addGestureRecognizer(gesture)
    }
}

// MARK: Remove gesture recognizer

public extension Gesture where Self: UIView {
    /**
        Detaches a gesture recognizer from the receiving view.
    
        - parameter gesture: An object whose class descends from the UIGestureRecognizer class
    
        - returns: The view
    */
    @discardableResult
    public func off(_ gesture: UIGestureRecognizer) -> Self {
        self.removeGestureRecognizer(gesture)
        return self
    }
    
    /**
        Detaches all the gestures recognizer of a given type from the receiving view.
    
        - parameter gestureType: A type of gesture recognizer
    
        - returns: The view
    */
    @discardableResult
    public func off<T: UIGestureRecognizer>(_ gestureType: T.Type) -> Self {
        guard let gestures = self.gestureRecognizers else { return self }
        
        for gesture in gestures where gesture is T {
            self.removeGestureRecognizer(gesture)
        }
        
        return self
    }
    
    /**
        Detaches all the gestures recognizer from the receiving view.
    
        - returns: The view
    */
    @discardableResult
    public func off() -> Self {
        guard let gestures = self.gestureRecognizers else {
            return self
        }
        
        for gesture in gestures {
            self.removeGestureRecognizer(gesture)
        }
        return self
    }
}

// MARK: Long press shorthand methods

public extension Gesture where Self: UIView {
    public typealias LongPressCallback = (UILongPressGestureRecognizer) -> Void
    
    fileprivate var longPress: UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer()
    }
    
    /**
        Attaches an instance of UILongPressGestureRecognizer to the view for all its states.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func longPress(_ callback: @escaping LongPressCallback) -> Self {
        return self.on(self.longPress, callback)
    }
    
    /**
        Attaches an instance of UILongPressGestureRecognizer to the view for a given state.
    
        - parameter state: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func longPress(_ state: UIGestureRecognizerState, _ callback: @escaping LongPressCallback) -> Self {
        return self.on(self.longPress, state, callback)
    }
    
    /**
        Attaches an instance of UILongPressGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func longPress(_ states: [UIGestureRecognizerState], _ callback: @escaping LongPressCallback) -> Self {
        return self.on(self.longPress, states, callback)
    }
    
    /**
        Attaches an instance of UILongPressGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func longPress(_ callbacks: [UIGestureRecognizerState: LongPressCallback]) -> Self {
        return self.on(self.longPress, callbacks)
    }
}

// MARK: Pan shorthand methods

public extension Gesture where Self: UIView {
    public typealias PanCallback = (UIPanGestureRecognizer) -> Void
    
    fileprivate var pan: UIPanGestureRecognizer {
        return UIPanGestureRecognizer()
    }
    
    /**
        Attaches an instance of UIPanGestureRecognizer to the view for all its states.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pan(_ callback: @escaping PanCallback) -> Self {
        return self.on(self.pan, callback)
    }
    
    /**
        Attaches an instance of UIPanGestureRecognizer to the view for a given state.
    
        - parameter state: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pan(_ state: UIGestureRecognizerState, _ callback: @escaping PanCallback) -> Self {
        return self.on(self.pan, state, callback)
    }
    
    /**
        Attaches an instance of UIPanGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pan(_ states: [UIGestureRecognizerState], _ callback: @escaping PanCallback) -> Self {
        return self.on(self.pan, states, callback)
    }
    
    /**
        Attaches an instance UIPanGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func pan(_ callbacks: [UIGestureRecognizerState: PanCallback]) -> Self {
        return self.on(self.pan, callbacks)
    }
}

// MARK: Pinch shorthand methods

public extension Gesture where Self: UIView {
    public typealias PinchCallback = (UIPinchGestureRecognizer) -> Void
    
    fileprivate var pinch: UIPinchGestureRecognizer {
        return UIPinchGestureRecognizer()
    }
    
    /**
        Attaches an instance of UIPinchGestureRecognizer to the view for all its states.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pinch(_ callback: @escaping PinchCallback) -> Self {
        return self.on(self.pinch, callback)
    }
    
    /**
        Attaches an instance of UIPinchGestureRecognizer to the view for a given state.
    
        - parameter state: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pinch(_ state: UIGestureRecognizerState, _ callback: @escaping PinchCallback) -> Self {
        return self.on(self.pinch, state, callback)
    }
    
    /**
        Attaches an instance of UIPinchGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func pinch(_ states: [UIGestureRecognizerState], _ callback: @escaping PinchCallback) -> Self {
        return self.on(self.pinch, states, callback)
    }
    
    /**
        Attaches an instance UIPinchGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func pinch(_ callbacks: [UIGestureRecognizerState: PinchCallback]) -> Self {
        return self.on(self.pinch, callbacks)
    }
}

// MARK: Rotation shorthand methods

public extension Gesture where Self: UIView {
    public typealias RotationCallback = (UIRotationGestureRecognizer) -> Void
    
    fileprivate var rotation: UIRotationGestureRecognizer {
        return UIRotationGestureRecognizer()
    }
    
    /**
        Attaches an instance of UIRotationGestureRecognizer to the view.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func rotation(_ callback: @escaping RotationCallback) -> Self {
        return self.on(self.rotation, callback)
    }
    
    /**
        Attaches an instance of UIRotationGestureRecognizer to the view for a given state.
    
        - parameter state: The states the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func rotation(_ state: UIGestureRecognizerState, _ callback: @escaping RotationCallback) -> Self {
        return self.on(self.rotation, state, callback)
    }
    
    /**
        Attaches an instance of UIRotationGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func rotation(_ states: [UIGestureRecognizerState], _ callback: @escaping RotationCallback) -> Self {
        return self.on(self.rotation, states, callback)
    }
    
    /**
        Attaches an instance UIRotationGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func rotation(_ callbacks: [UIGestureRecognizerState: RotationCallback]) -> Self {
        return self.on(self.rotation, callbacks)
    }
}

// MARK: Swipe shorthand methods

public extension Gesture where Self: UIView {
    public typealias SwipeCallback = (UISwipeGestureRecognizer) -> Void
    
    fileprivate var swipe: UISwipeGestureRecognizer {
        return UISwipeGestureRecognizer()
    }
    
    /**
        Attaches an instance of UISwipeGestureRecognizer to the view for all its states.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func swipe(_ callback: @escaping SwipeCallback) -> Self {
        return self.on(self.swipe, callback)
    }
    
    /**
        Attaches an instance of UISwipeGestureRecognizer to the view for a given state.
    
        - parameter state: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func swipe(_ state: UIGestureRecognizerState, _ callback: @escaping SwipeCallback) -> Self {
        return self.on(self.swipe, state, callback)
    }
    
    /**
        Attaches an instance of UISwipeGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func swipe(_ states: [UIGestureRecognizerState], _ callback: @escaping SwipeCallback) -> Self {
        return self.on(self.swipe, states, callback)
    }
    
    /**
        Attaches an instance UISwipeGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func swipe(_ callbacks: [UIGestureRecognizerState: SwipeCallback]) -> Self {
        return self.on(self.swipe, callbacks)
    }
}

// MARK: Tap shorthand methods

public extension Gesture where Self: UIView {
    public typealias TapCallback = (UITapGestureRecognizer) -> Void
    
    fileprivate var tap: UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }
    
    /**
        Attaches an instance of UITapGestureRecognizer to the view for all its states.
    
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func tap(_ callback: @escaping TapCallback) -> Self {
        return self.on(self.tap, callback)
    }
    
    /**
        Attaches an instance of UITapGestureRecognizer to the view for a given state.
    
        - parameter state: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func tap(_ state: UIGestureRecognizerState, _ callback: @escaping TapCallback) -> Self {
        return self.on(self.tap, state, callback)
    }
    
    /**
        Attaches an instance of UITapGestureRecognizer to the view for a multiple states.
    
        - parameter states: The state the gesture recognizer should be in
        - parameter callback: A function to be invoked when the gesture occurs
    
        - returns: The view
    */
    @discardableResult
    public func tap(_ states: [UIGestureRecognizerState], _ callback: @escaping TapCallback) -> Self {
        return self.on(self.tap, states, callback)
    }
    
    /**
        Attaches an instance UITapGestureRecognizer to the view and declares callbacks for its different states.
    
        - parameter callbacks: A dictionary with a state as the key and a callback as the value
    
        - returns: The view
    */
    @discardableResult
    public func tap(_ callbacks: [UIGestureRecognizerState: TapCallback]) -> Self {
        return self.on(self.tap, callbacks)
    }
}

// MARK: Actor

private protocol Triggerable {
    func trigger(_ gesture: UIGestureRecognizer)
}

private struct Actor<T: UIGestureRecognizer>: Triggerable {
    typealias State = UIGestureRecognizerState
    typealias Callback = (T) -> Void
    
    var callbacks: [State: Callback] = [:]
    
    var proxy: Proxy?

    init(gesture: T, states: [State] = State.all, callback: @escaping Callback) {
        let gesture = gesture.proxy == nil ? gesture : gesture.clone()
        
        for state in states {
            self.callbacks[state] = callback
        }
        
        self.proxy = Proxy(actor: self, gesture: gesture)
    }
    
    init(gesture: T, callbacks: [State: Callback]) {
        let gesture = gesture.proxy == nil ? gesture : gesture.clone()
        
        self.callbacks = callbacks
        self.proxy = Proxy(actor: self, gesture: gesture)
    }
    
    func trigger(_ gesture: UIGestureRecognizer) {
        if let gesture = gesture as? T, let callback = callbacks[gesture.state] {
            callback(gesture)
        }
    }
}

// MARK: Proxy

private var key = "io.delba.tactile.proxy"

extension UIGestureRecognizer {
    fileprivate var proxy: Proxy? {
        get {
            var proxy: Proxy?
            
            self.synchronized {
                proxy = objc_getAssociatedObject(self, &key) as? Proxy
            }
            return proxy
        }
        
        set {
            self.synchronized {
                objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
}

private class Proxy: NSObject {
    var actor: Triggerable?
    
    init(actor: Triggerable, gesture: UIGestureRecognizer) {
        super.init()
        self.actor = actor
        gesture.proxy = self
    }
    
    @objc func recognized(_ gesture: UIGestureRecognizer) {
        self.actor?.trigger(gesture)
    }
}

private extension Selector {
    static let recognized = #selector(Proxy.recognized(_:))
}
