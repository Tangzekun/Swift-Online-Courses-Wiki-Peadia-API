//
//  ViewController.swift
//  FaceDetection
//
//  Created by TangZekun on 11/5/15.
//  Copyright © 2015 TangZekun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var faceImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let textFieldContent = textField.text
        {
            do
            {
                try wikiface.faceForPerson(textFieldContent, size: CGSize(width: 250, height: 250), completion: { (image: UIImage?, imageFound: Bool!) -> () in
                    if imageFound == true
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.faceImageView.image = image
                        //wikiface.centerImageViewOnface(self.faceImageView)
                            
                        })
                    }
               })
            }
            catch wikiface.wikifaceError.CouldNotDownloadImage
            {
                print("could not download")
            }
            catch
            {
                print(error)
            }
            
        }
        
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

