//
//  CommonUtilities.swift
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

extension UIControlEvents: Hashable {
    public var hashValue: Int {
        return Int(rawValue)
    }
}

internal extension UIGestureRecognizerState {
    internal static let all = [
        possible, began, changed, ended, cancelled, failed
    ]
}

internal extension UIGestureRecognizer {
    internal func clone() -> Self {
        let clone = type(of: self).init()
        
        downcast(self, and: clone, to: UILongPressGestureRecognizer.self) { a, b in
            b.numberOfTapsRequired    = a.numberOfTapsRequired
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
            b.minimumPressDuration    = a.minimumPressDuration
            b.allowableMovement       = a.allowableMovement
        }
        
        downcast(self, and: clone, to: UIPanGestureRecognizer.self) { a, b in
            b.maximumNumberOfTouches = a.maximumNumberOfTouches
            b.minimumNumberOfTouches = a.minimumNumberOfTouches
        }
        
        downcast(self, and: clone, to: UIScreenEdgePanGestureRecognizer.self) { a, b in
            b.edges = a.edges
        }
        
        downcast(self, and: clone, to: UISwipeGestureRecognizer.self) { a, b in
            b.direction               = a.direction
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
        }
        
        downcast(self, and: clone, to: UITapGestureRecognizer.self) { a, b in
            b.numberOfTapsRequired    = a.numberOfTapsRequired
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
        }
        
        return clone
    }
    
    internal func downcast<T, U>(_ a: T, and b: T, to: U.Type, block: (U, U) -> Void) {
        if let a = a as? U, let b = b as? U {
            block(a, b)
        }
    }
}

internal extension NSObject {
    internal func synchronized(_ block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        block()
    }
}
