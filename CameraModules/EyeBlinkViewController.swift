//
//  EyeBlinkViewController.swift
//  CameraModules
//
//  Created by Mufad Monwar on 31/5/20.
//  Copyright © 2020 reddot. All rights reserved.
//

import UIKit
import Firebase
import AVKit

class EyeBlinkViewController : UIViewController {
  
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var overlayView: UIView!

    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.photo

        let backCamera =  AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!

        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }

        if error == nil && (session?.canAddInput(input))! {
            session?.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
        }

        if (session?.canAddOutput(stillImageOutput!))! {
            session?.addOutput(stillImageOutput!)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
            session?.startRunning()

            // I'm adding a circle not a rectangle. Make that adjustment in your code.
            let radius : CGFloat = 50.0
            let xOffset : CGFloat = 100 //  Position according to your wish
            let yOffset : CGFloat = 100 //  Position according to your wish

            let path = CGMutablePath()

            path.addArc(center: CGPoint(x: xOffset, y: yOffset),
                        radius: radius,
                        startAngle: 0.0,
                        endAngle: 2.0 * .pi,
                        clockwise: false)

            path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))

            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path
            maskLayer.fillRule = .evenOdd

            overlayView.layer.mask = maskLayer
            overlayView.clipsToBounds = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer?.frame = cameraPreviewView.bounds
    }
   
}
 
