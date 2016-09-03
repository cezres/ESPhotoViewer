//
//  ESPhotoCell.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 2016/9/3.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoCell: UICollectionViewCell {
    
    
    var imageURL: URL! {
        didSet {
            layer.contents = nil
            guard imageURL != nil else {
                return
            }
            /*
            ESPhotoCache.shared.loadImage(url: imageURL) { (url, image) in
                if url != self.imageURL {
                    return
                }
                self.layer.contents = image.cgImage
            }*/
            
            ESPhotoCache.loadImage(hash: hash, url: imageURL) { (url, image) in
                if url != self.imageURL {
                    return
                }
                self.layer.contents = image.cgImage
            }
            
            print(hash)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = UIViewContentMode.scaleAspectFit
        backgroundColor = UIColor.white()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
