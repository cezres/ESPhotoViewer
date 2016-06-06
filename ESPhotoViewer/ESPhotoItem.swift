//
//  ESPhotoItem.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoItem: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView: UIImageView!
    
    var imagePath: String = "" {
        didSet {
            imageView.image = nil
            ESPhotoCache.sharedInstance.imageForPath(imagePath) { [weak self](filePath, image) in
                if self != nil && filePath == self!.imagePath {
                    self!.imageView.image = image
                    self?.imageView.photo_centeringForSuperview()
                }
            }
//            imageView.image = UIImage(contentsOfFile: imagePath)
//            imageView.photo_centeringForSuperview()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        imageView = UIImageView()
        addSubview(imageView)
        
        backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ESPhotoItem.statusBarOrientationChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func statusBarOrientationChange() {
        imageView.photo_centeringForSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if imageView.image == nil {
            imageView.frame = CGRectMake(10, 10, frame.size.width-20, frame.size.height-20)
        }
        super.layoutSubviews()
    }
    
    

}
