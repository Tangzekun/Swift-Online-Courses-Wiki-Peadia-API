//
//  wikiface.swift
//  FaceDetection
//
//  Created by TangZekun on 11/5/15.
//  Copyright © 2015 TangZekun. All rights reserved.
//

import UIKit
import ImageIO

class wikiface: NSObject {
    
    enum wikifaceError:ErrorType
    {
        case CouldNotDownloadImage
    }

    
    class func faceForPerson(Person: String, size: CGSize,completion: (image: UIImage?, imageFound:Bool!) ->()) throws
        
    {
     
        let escapedString = Person.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let pixelsForAPIRequest = Int(max(size.width, size.height))*2
        
        let url = NSURL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=\(escapedString!)&prop=pageimages&format=json&pithumbsize=\(pixelsForAPIRequest)")
        
        guard let task: NSURLSessionTask? = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
        
        if error == nil
        {
            let wikiDict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            
            if let query = wikiDict.objectForKey("query") as? NSDictionary
            {
                if let  pages = query.objectForKey("pages") as? NSDictionary
                {
                    if let pageContent = pages.allValues.first as? NSDictionary
                    {
                        if let thumbnail = pageContent.objectForKey("thumbnail") as? NSDictionary
                        {
                            if let thumbURL = thumbnail.objectForKey("source") as? String
                            {
                                let faceImage = UIImage(data: NSData(contentsOfURL: NSURL(string:thumbURL)!)!)
                                completion(image: faceImage, imageFound: true)
                            }
                        }
        
                    }
                }
            }
        
        }
        })
    
            else
            {
                throw wikifaceError.CouldNotDownloadImage
            }
            task!.resume()
    }
    
    
    
//    class func centerImageViewOnface (imageView: UIImageView)
//        {
//            let context = CIContext(options: nil)
//            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//            let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
//            
//            let faceImage = imageView.image
//            let ciImage = CIImage(CGImage: faceImage!.CGImage!)
//            
//            let features = detector.featuresInImage(ciImage)
//            
//            if features.count > 0
//            {
//                var face:CIFaceFeature!
//                
//                for rect in features
//                {
//                    face = rect as! CIFaceFeature
//                }
//                
//                var faceRectWithExtendeBounds = face.bounds
//                faceRectWithExtendeBounds.origin.x -= 20
//                faceRectWithExtendeBounds.origin.y -= 30
//                
//                faceRectWithExtendeBounds.size.width += 40
//                faceRectWithExtendeBounds.size.height += 60
//                
//                let x = faceRectWithExtendeBounds.origin.x / faceImage!.size.width
//                let y = (faceImage!.size.height - faceRectWithExtendeBounds.origin.y - faceRectWithExtendeBounds.size.height)/faceImage!.size.height
//                
//                let widthFace = faceRectWithExtendeBounds.size.width / faceImage!.size.width
//                let heightFace = faceRectWithExtendeBounds.size.height / faceImage!.size.height
//            
//                imageView.layer.contentsRect = CGRectMake(x, y, widthFace, heightFace)
//           }
//            
//        }
    
}












