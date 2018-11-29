

import UIKit
//import UIKit.UIGestureRecognizerSubclass

class CellPanGestureRecognizer: UIPanGestureRecognizer {
    var initialTouchLocation: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first?.location(in: view)
    }
}
