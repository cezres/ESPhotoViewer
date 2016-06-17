//
//  ESPhotoItem.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoItem: UIView {
    
    var imageView: UIImageView!
    
    var imagePath: String! {
        didSet {
//            imageView.image = nil
            guard imagePath != nil else {
                return
            }
            
            ESPhotoManager.manager.imageForPath(imagePath) { [weak self](path, image) in
                guard self != nil else {
                    return
                }
                guard path == self!.imagePath else {
                    return
                }
                self!.imageView.image = image
                self!.imageView.photo_centeringForSuperview()
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if imageView.frame == CGRectZero && imageView.image != nil {
            imageView.photo_centeringForSuperview()
        }
        super.layoutSubviews()
    }
    
}


public extension UIImageView {
    
    public func photo_centeringForSuperview() {
        guard let imageSize = image?.size else {
            return
        }
        guard let superviewSize = superview?.frame.size else {
            return
        }
        let height = superviewSize.width * imageSize.height / imageSize.width
        if height < superviewSize.height {
            frame = CGRectMake(0, (superviewSize.height-height) / 2, superviewSize.width, height)
        }
        else {
            let width = superviewSize.height * imageSize.width / imageSize.height
            frame = CGRectMake((superviewSize.width - width) / 2, 0, width, superviewSize.height)
        }
    }
    
}

