//
//  ImageAnalysisViewController.swift
//  ShoeScan
//
//  This is the view controller in which the image is run through the Core ML
//  model to detect the model of the shoe using image classification
//
//  Crashlytics enabled
//
//  Created by Rahul D'Costa on 7/2/19.
//  Copyright © 2019 Nihilent Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision
import ImageIO
import Crashlytics
import Firebase

class ImageAnalysisViewController: UIViewController {
    
    @IBOutlet weak var shoeLabel: UILabel!
    var shoeModel = ""
    var pixelbuffer: CVPixelBuffer? = nil
    
    var imageFinal: UIImage? = nil
    @IBOutlet weak var finalImage: UIImageView!
    
    var ref: DatabaseReference!
    
    // date and time variables for data logging purposes
    let date = Date()
    let calendar = Calendar.current
    let format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        shoeLabel.text = "Detecting model..."
        
        finalImage.image = imageFinal
        pixelbuffer = buffer(from: imageFinal!)
        
        predictResult(pixelBuffer: pixelbuffer!)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    func predictResult(pixelBuffer: CVPixelBuffer) {
        
        // MARK: Shoe model detection using Core ML model
        
        let model = YeezyDetector()
        
        guard let YeezyDetectorOutput = try? model.prediction(image: pixelBuffer) else {
            fatalError()
        }
        
        guard let probs = YeezyDetectorOutput.classLabelProbs[YeezyDetectorOutput.classLabel] else {
            fatalError()
        }
        
        //The following line helps verify if the image is a shoe or not. The threshold probability has been set to 95%
        //but may be changed according to the accuracy of the model
        
        if probs < 0.95 {
            shoeLabel.text = "This is not a registered shoe."
        }
            
        else {
            shoeModel = YeezyDetectorOutput.classLabel
            shoeLabel.text = "\(Int(probs * 100))% \(shoeModel)"
            
            // MARK: Firebase event and data logging
            
            // log event in Firebase console
            Analytics.logEvent("shoe_detected", parameters: ["prob_value": Int(probs * 100)])
            
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = format.string(from: date)
            
            // log data in realtime Firebase database
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                ref?.child("Models").child(uid).child(shoeModel).updateChildValues([formattedDate: Int(probs * 100)])
            }
        }

    }
    
    // The following function converts a UIImage to CVPixelBuffer
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
