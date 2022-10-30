//
//  ViewController.swift
//  ubtest
//
//  Created by 한태희 on 2022/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var IV: UIImageView!
    @IBOutlet weak var faceIndicatingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let faceDetector = FaceDetector()
        let rect = faceDetector.getFaceRect(from: IV.image!, imageView: IV)
        
        faceIndicatingView.frame = rect
        faceIndicatingView.layer.borderColor = UIColor.red.cgColor
        faceIndicatingView.layer.borderWidth = 2
    }

}

class FaceDetector {
    
    let context = CIContext()
    let opt = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    var detector: CIDetector!
    
    init() {
        detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: opt)
    }
    
    func getFaceRect(from image: UIImage, imageView: UIImageView) -> CGRect {
        guard let ciimage = CIImage(image: image) else { return CGRect.zero }
        
        let ciImageSize = ciimage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        let features = detector.features(in: ciimage)
        
        // Apply the transform to convert the coordinates
        var faceViewBounds = features[0].bounds.applying(transform)
        print(features)
        print(features[0])
        print(faceViewBounds)
        
        // Calculate the actual position and size of the rectangle in the image view
        let viewSize = imageView.bounds.size
        let scale = min(viewSize.width / ciImageSize.width,
                        viewSize.height / ciImageSize.height)
        let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
        let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
        
        faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
        faceViewBounds.origin.x += offsetX
        faceViewBounds.origin.y += offsetY
        
        return faceViewBounds
    }
}
