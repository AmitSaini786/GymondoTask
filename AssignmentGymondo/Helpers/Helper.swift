//
//  Helper.swift
//  Ally
//
//  Created by Admin on 06/09/18.
//  Copyright © 2018 Unyde. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration

public class InternetConnectionManager {
    
    
    private init() {
        
    }
    
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
struct Alert {
static func errorAlert(title: String, message: String?, cancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let actionOK = UIAlertAction(title: "Retry", style: .default) {
        _ in
        guard let completion = completion else { return }
        completion()
    }
    alert.addAction(actionOK)

//    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//    if cancelButton { alert.addAction(cancel) }

    return alert
  }
}
class Helper: NSObject {
    var spinnerView : SpinnerView?
    var viewWhite = UIView()
    var lblLoaderText = UILabel()

    
    //Mark: Show Alert
    class func showAlert(sender: UIViewController, title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(cancelAction)
        sender.present(alertView, animated: true, completion: nil)
    }
    


    static func startProgress(viewController: UIViewController){
        var spinnerView : SpinnerView?
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
            let view1 = UIView(frame: window.bounds)
            view1.isUserInteractionEnabled = false
            let width = view1.frame.size.width / 2
            let height = view1.frame.size.height / 4 - 45
            let transparentBackground = UIView(frame: UIScreen.main.bounds)
            transparentBackground.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            transparentBackground.tag = 1000000
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.addSubview(transparentBackground)
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.bringSubviewToFront(transparentBackground)
            let viewBG = UIView(frame: CGRect(x: view1.frame.size.width / 2 - width / 2 + 15, y: view1.frame.size.height / 2 - height / 2, width: width - 15 , height: 80))
            viewBG.backgroundColor = #colorLiteral(red: 0.3728225827, green: 0.3237656355, blue: 0.7548984885, alpha: 1)
            viewBG.layer.cornerRadius = viewBG.frame.size.height / 2

            spinnerView = SpinnerView(frame: CGRect(x: 20, y: viewBG.frame.size.height / 2 - 20 , width: 45, height: 45))
            viewBG.addSubview(spinnerView!)

            let lblText = UILabel(frame:  CGRect(x: (spinnerView?.frame.origin.x)! + (spinnerView?.frame.size.width)! + 10 ,y: ((spinnerView?.frame.size.height)! / 2) , width:viewBG.frame.size.width - (spinnerView?.frame.size.width)! - 40, height: 40))
            lblText.text = "please wait..."
            lblText.textColor = .white
            lblText.font = .boldSystemFont(ofSize: 17)
            viewBG.addSubview(lblText)
            transparentBackground.addSubview(viewBG)
        }
    }
    static func stopProgress(viewController: UIViewController){
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        let view1 = UIView(frame: window.bounds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            view1.isUserInteractionEnabled = true
            if let viewWithTag =  UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.viewWithTag(1000000) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
           }
        })
    }
    
    //MARK: Setup loading View
    @IBDesignable
    class SpinnerView : UIView {
        
        override var layer: CAShapeLayer {
            get {
                return super.layer as! CAShapeLayer
            }
        }
        
        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.fillColor = nil
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 6
            setPath()
        }
        
        override func didMoveToWindow() {
            animate()
        }
        
        private func setPath() {
            layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
        }
        
        struct Pose {
            let secondsSincePriorPose: CFTimeInterval
            let start: CGFloat
            let length: CGFloat
            init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
                self.secondsSincePriorPose = secondsSincePriorPose
                self.start = start
                self.length = length
            }
        }
        
        class var poses: [Pose] {
            get {
                return [
                    Pose(0.0, 0.000, 0.7),
                    Pose(0.6, 0.500, 0.5),
                    Pose(0.6, 1.000, 0.3),
                    Pose(0.6, 1.500, 0.1),
                    Pose(0.2, 1.875, 0.1),
                    Pose(0.2, 2.250, 0.3),
                    Pose(0.2, 2.625, 0.5),
                    Pose(0.2, 3.000, 0.7),
                ]
            }
        }
        
        func animate() {
            var time: CFTimeInterval = 0
            var times = [CFTimeInterval]()
            var start: CGFloat = 0
            var rotations = [CGFloat]()
            var strokeEnds = [CGFloat]()
            
            let poses = type(of: self).poses
            let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
            
            for pose in poses {
                time += pose.secondsSincePriorPose
                times.append(time / totalSeconds)
                start = pose.start
                rotations.append(start * 2 * .pi)
                strokeEnds.append(pose.length)
            }
            
            times.append(times.last!)
            rotations.append(rotations[0])
            strokeEnds.append(strokeEnds[0])
            
            animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
            animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
            
            animateStrokeHueWithDuration(duration: totalSeconds * 5)
        }
        
        func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
            let animation = CAKeyframeAnimation(keyPath: keyPath)
            animation.keyTimes = times as [NSNumber]?
            animation.values = values
            animation.calculationMode = CAAnimationCalculationMode.linear
            animation.duration = duration
            animation.repeatCount = Float.infinity
            layer.add(animation, forKey: animation.keyPath)
        }
        
        func animateStrokeHueWithDuration(duration: CFTimeInterval) {
            let count = 36
            let animation = CAKeyframeAnimation(keyPath: "strokeColor")
            animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
            animation.values = (0 ... count).map {_ in
                UIColor.white.cgColor
            }
            animation.duration = duration
            animation.calculationMode = CAAnimationCalculationMode.linear
            animation.repeatCount = Float.infinity
            layer.add(animation, forKey: animation.keyPath)
        }
        
        
    }
   
}

