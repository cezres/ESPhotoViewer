//
//  ViewController.swift
//  ESPhotoViewer Demo
//
//  Created by 翟泉 on 16/6/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ESPhotoViewer

class ViewController: UIViewController {
    
    var imageURLs = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let urls = Bundle.main().urlsForResources(withExtension: "jpg", subdirectory: nil) {
            imageURLs += urls
        }
        if let urls = Bundle.main().urlsForResources(withExtension: "png", subdirectory: nil) {
            imageURLs += urls
        }
        
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        ESPhotoViewer.view(imageURLs: imageURLs, inController: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

