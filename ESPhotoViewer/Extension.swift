//
//  Extension.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIImage {
    
}


extension UIView {
    /**
     相对于父视图居中
     */
    func photo_centeringForSuperview() {
        guard superview != nil else {
            return
        }
        guard frame.size != CGSizeZero else {
            return
        }
        let height = superview!.frame.width * frame.height / frame.width
        if height < superview!.frame.size.height {
            self.frame = CGRectMake(0, (superview!.frame.height - height) / 2, superview!.frame.width, height)
        }
        else {
            let widht = superview!.frame.height * frame.width / frame.height
            self.frame = CGRectMake((superview!.frame.width - widht) / 2, 0, widht, superview!.frame.height)
        }
    }
}

extension UIImageView {
    
    override func photo_centeringForSuperview() {
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

