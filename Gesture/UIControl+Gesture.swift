//
//  UIControl+Gesture.swift
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

public extension Gesture where Self: UIControl {
    /**
        Attaches an event handler function for an event.
    
        - parameter event: A UIControlEvents event
        
        - parameter callback: The event handler function
        
        - returns: The control
    */
    @discardableResult
    public func on(_ event: UIControlEvents, _ callback: @escaping (Self) -> Void) -> Self {
        let actor = Actor(control: self, event: event, callback: callback)
        self.addTarget(actor.proxy, action: .recognized, for: event)
        return self
    }
    
    /**
        Attaches an event handler function for multiple events.
    
        - parameter events: An array of UIControlEvents
        
        - parameter callback: The event handler function
        
        - returns: The control
    */
    @discardableResult
    public func on(_ events: [UIControlEvents], _ callback: @escaping (Self) -> Void) -> Self {
        for event in events {
            self.on(event, callback)
        }
        return self
    }
    
    /**
        Attaches event handler functions for different events.
        
        - parameter callbacks: A dictionary with a UIControlEvents event as the key and an event handler function as the value
        
        - returns: The control
    */
    @discardableResult
    public func on(_ callbacks: [UIControlEvents: (Self) -> Void]) -> Self {
        for (event, callback) in callbacks {
            self.on(event, callback)
        }
        return self
    }
}

// MARK: Actor

private protocol Triggerable {
    func trigger(_ control: UIControl)
}

private struct Actor<T: UIControl>: Triggerable {
    let callback: (T) -> Void
    var proxy: Proxy?
    
    init(control: T, event: UIControlEvents, callback: @escaping (T) -> Void) {
        self.callback = callback
        self.proxy = Proxy(actor: self, control: control, event: event)
    }
    
    func trigger(_ control: UIControl) {
        if let control = control as? T {
            self.callback(control)
        }
    }
}

// MARK: Proxy

private var key = "cn.meniny.gesture.proxies"

private extension UIControl {
    var proxies: [UInt: Proxy] {
        get {
            var proxies: [UInt: Proxy] = [:]
            
            self.synchronized {
                if let lookup = objc_getAssociatedObject(self, &key) as? [UInt: Proxy] {
                    proxies = lookup
                }
            }
            
            return proxies
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
    
    init(actor: Triggerable, control: UIControl, event: UIControlEvents) {
        super.init()
        
        self.actor = actor
        control.proxies[event.rawValue] = self
    }
    
    @objc func recognized(_ control: UIControl) {
        self.actor?.trigger(control)
    }
}

private extension Selector {
    static let recognized = #selector(Proxy.recognized(_:))
}
