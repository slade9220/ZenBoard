/*
 Copyright (C) 2018 Gennaro Amura All Rights Reserved.
 
 Abstract:
 The primary view controller that hosts a `CanvasView` for the user to interact with.
 */

import UIKit

class ViewController: UIViewController {
    // MARK: Properties


    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    

    // MARK: Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let newcanvasView = CanvasView()
        newcanvasView.frame = view.bounds
        newcanvasView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        view.addSubview(newcanvasView)
        
        newcanvasView.drawTouches(touches: touches, withEvent: event)
        

    }
    
    @objc func fadeoutAnimation() {
        
        print("timer",view.subviews.count)
        guard let view = view.subviews.first else {return}
        UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
           view.alpha = 0
        }, completion: {_ in
            view.removeFromSuperview()
        })
    
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let canvas = view.subviews.last as? CanvasView else {return}
        canvas.drawTouches(touches: touches, withEvent: event)
        

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let canvas = view.subviews.last as? CanvasView else {return}
        canvas.drawTouches(touches: touches, withEvent: event)
        canvas.endTouches(touches: touches, cancel: false)
        

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let canvas = view.subviews.last as? CanvasView else {return}
        canvas.endTouches(touches: touches, cancel: true)
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        
        guard let canvas = view.subviews.last as? CanvasView else {return}
        canvas.updateEstimatedPropertiesForTouches(touches: touches)
    }

    // MARK: Rotation

    override var shouldAutorotate: Bool {
        get { return true }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return [.landscapeLeft, .landscapeRight] }
    }


    
}

