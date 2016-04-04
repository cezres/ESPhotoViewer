//
//  ViewController.swift
//  Example
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit
import ESPhotoViewer





class ViewController: UIViewController, ESPhotoViewerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let _view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        _view.backgroundColor = UIColor.orangeColor()
//        view.addSubview(_view)
//        _view.es_centeringForSuperview()
        
        
        
        var imageSource = [NSURL]()
        
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/081ed02bfc0dd356.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/91a6cbc7d731abbe.png"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/48209762_p0.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/567f8a12043784e1a516d98e0b305d05.jpg"))
        
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/65as65d6sa5.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/6565.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/011317vswyrsew91y99oyw.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/011329kw0rsk8b892r9098.jpg"))
        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/011345bngvzhnvnzohu4hx.jpg"))
        
//        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/48209762_p0.jpg"))
//        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/48209762_p0.jpg"))
//        imageSource.append(NSURL(fileURLWithPath: "/Users/cezr/Documents/48209762_p0.jpg"))
        
        
        let photoViewer = ESPhotoViewer()
        photoViewer.frame = CGRectMake(0, 20, view.frame.width, view.frame.height-20)
        photoViewer.backgroundColor = UIColor.grayColor()
        photoViewer.AZ()
        
        photoViewer.delegate = self
        
        photoViewer.imageSource = imageSource
        
        
        view.addSubview(photoViewer)
        
        
        
//        NSCache()
    }
    
    // MARK: - ESPhotoViewerDelegate
    
    
    func photoViewer(photoViewer: ESPhotoViewer, willDisplayPhoto item: ESPhotoItem) {
        
    }
    
    func photoViewer(photoViewer: ESPhotoViewer, didSelectPhoto item: ESPhotoItem) {
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//extension ViewController: NSDiscardableContent {
//    
//}

