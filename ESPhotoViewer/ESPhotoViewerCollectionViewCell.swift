//
//  ESPhotoViewerCollectionViewCell.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit


extension UIView {
    
    func es_centeringForSuperview() {
        
        guard superview != nil else {
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



public class ESPhotoViewerCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    var item = ESPhotoItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: frame)
        addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        
        if let image = imageView.image {
            imageView.frame = CGRect(origin: CGPointZero, size: image.size)
            imageView.es_centeringForSuperview()
        }
        
        super.layoutSubviews()
    }
    
    public func setImageURL(url: NSURL) {
        
        imageView.image = nil
        
        item.url = url
        
        item.getImage { (image) in
            self.imageView.image = image
            self.setNeedsLayout()
        }
    }
}
