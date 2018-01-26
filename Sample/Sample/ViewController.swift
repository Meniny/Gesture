//
//  ViewController.swift
//  Sample
//
//  Created by 李二狗 on 2018/1/26.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import Gesture

open class ViewController: UIViewController {

    var tapCounter: Int = 0
    var swipeCounter: Int = 0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tap(UIGestureRecognizerState.ended) { (_) in
            self.tapCounter += 1
            print("Tap: \(self.tapCounter)")
        }
        
        self.view.swipe(UIGestureRecognizerState.ended) { (_) in
            self.swipeCounter += 1
            print("Swipe: \(self.swipeCounter)")
        }
    }

}

