/*
 Copyright (C) 2018 Gennaro Amura All Rights Reserved.
 
 Abstract:
 The primary view controller that hosts a `CanvasView` for the user to interact with.
 */

import UIKit

class ViewController: UIViewController {
    // MARK: Properties

    var visualizeAzimuth = false
//    var buddahTimer: Timer!
    var ifTimer = false
    var buddahTimer: Timer!

    let reticleView: ReticleView = {
        let view = ReticleView(frame: CGRect.null)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        return view
    }()
    

    

    override func viewDidLoad() {
//        canvasView.addSubview(reticleView)
        view.backgroundColor = .white
        

    }
    
    var arrayOfcanavs: [CanvasView] = []

    // MARK: Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newcanvasView = CanvasView()
        newcanvasView.frame = view.bounds
        newcanvasView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        newcanvasView.addSubview(reticleView)
        arrayOfcanavs.append(newcanvasView)
        view.addSubview(newcanvasView)
        
        newcanvasView.drawTouches(touches: touches, withEvent: event)
        
        buddahTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        
        
        if visualizeAzimuth {
            for touch in touches {
                if touch.type == .stylus {
                    reticleView.isHidden = false
                    updateReticleViewWithTouch(touch: touch, event: event)
                }
            }
        }
    }
    
    @objc func runTimedCode(){
        
        UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
            guard let canvas = self.arrayOfcanavs.first else { return }
            canvas.alpha = 0
        }, completion: {_ in
            guard let canvas = self.arrayOfcanavs.first else { return }
            canvas.removeFromSuperview()
            self.arrayOfcanavs.remove(at: 0)
        })
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        arrayOfcanavs.last?.drawTouches(touches: touches, withEvent: event)

        if visualizeAzimuth {
            for touch in touches {
                if touch.type == .stylus {
                    updateReticleViewWithTouch(touch: touch, event: event)

                    // Use the last predicted touch to update the reticle.
                    guard let predictedTouch = event?.predictedTouches(for: touch)?.last else { return }

                    updateReticleViewWithTouch(touch: predictedTouch, event: event, isPredicted: true)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        arrayOfcanavs.last?.drawTouches(touches: touches, withEvent: event)
        arrayOfcanavs.last?.endTouches(touches: touches, cancel: false)
        
        
//        print(buddahTimer.fireDate)
//            ifTimer = true
            
        

        if visualizeAzimuth {
            for touch in touches {
                if touch.type == .stylus {
                    reticleView.isHidden = true
                }
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        arrayOfcanavs.last?.endTouches(touches: touches, cancel: true)

        if visualizeAzimuth {
            for touch in touches {
                if touch.type == .stylus {
                    reticleView.isHidden = true
                }
            }
        }
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        arrayOfcanavs.last?.updateEstimatedPropertiesForTouches(touches: touches)
    }

    // MARK: Rotation

    override var shouldAutorotate: Bool {
        get { return true }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return [.landscapeLeft, .landscapeRight] }
    }


    // MARK: Convenience

    func updateReticleViewWithTouch(touch: UITouch?, event: UIEvent?, isPredicted: Bool = false) {
        guard let touch = touch, touch.type == .stylus else { return }

        reticleView.predictedDotLayer.isHidden = !isPredicted
        reticleView.predictedLineLayer.isHidden = !isPredicted

        let azimuthAngle = touch.azimuthAngle(in: view)
        let azimuthUnitVector = touch.azimuthUnitVector(in: view)
        let altitudeAngle = touch.altitudeAngle

        if isPredicted {
            reticleView.predictedAzimuthAngle = azimuthAngle
            reticleView.predictedAzimuthUnitVector = azimuthUnitVector
            reticleView.predictedAltitudeAngle = altitudeAngle
        }
        else {
            let location = touch.preciseLocation(in: view)
            reticleView.center = location
            reticleView.actualAzimuthAngle = azimuthAngle
            reticleView.actualAzimuthUnitVector = azimuthUnitVector
            reticleView.actualAltitudeAngle = altitudeAngle
        }
    }
}

