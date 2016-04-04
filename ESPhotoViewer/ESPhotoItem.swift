//
//  ESPhotoItem.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import Foundation

public class ESPhotoItem {
    
    public var url: NSURL!
    
    public var index: Int = 0
    
    func getImage(callback: (image: UIImage)-> Void) {
        guard url != nil else {
            return
        }
        guard url!.fileURL else {
            return
        }
        
        
        func loadImage(url: NSURL) -> UIImage? {
            
            let resultImage: UIImage?
            
            if let imageData = NSData(contentsOfURL: url) {
                resultImage = UIImage(data: imageData)
            }
            else {
                resultImage = nil
            }
            
//            sleep(2)
            
            return resultImage
        }
        
        
        
        if let image = ESImageCache.sharedInstance.objectForKey(url.absoluteString) as? UIImage {
            callback(image: image)
        }
        else {
            if let thumbnail: UIImage = ESThumbnailCache.sharedInstance.objectForKey(url.absoluteString) as? UIImage {
                callback(image: thumbnail)
            }
            
            let _url = self.url.copy() as! NSURL
            dispatch_async(dispatch_get_global_queue(0, 0), {
                if let image = loadImage(_url) {
                    if _url.isEqual(self.url) {
                        dispatch_async(dispatch_get_main_queue(), {
                            callback(image: image)
                        })
                    }
                    
                    ESImageCache.sharedInstance.setObject(image, forKey: _url.absoluteString)
                    ESThumbnailCache.sharedInstance.setObject(image.es_thumbnail(), forKey: _url.absoluteString)
                }
            })
        }
        
    }
    
}


/// 缓存
class ESImageCache: NSCache, NSCacheDelegate {
    
    static let sharedInstance = ESImageCache()
    
    private override init() {
        super.init()
        name = NSStringFromClass(classForCoder)
        countLimit = 2
        delegate = self
    }
    
    override func setObject(obj: AnyObject, forKey key: AnyObject) {
        super.setObject(obj, forKey: key)
    }
    
    // MARK: - NSCacheDelegate
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        
    }
}

/// 缩略图缓存
class ESThumbnailCache: NSCache, NSCacheDelegate {
    
    static let sharedInstance = ESThumbnailCache()
    
    private override init() {
        super.init()
        name = NSStringFromClass(classForCoder)
        countLimit = 20
        delegate = self
    }
    
    override func setObject(obj: AnyObject, forKey key: AnyObject) {
        super.setObject(obj, forKey: key)
    }
    
    // MARK: - NSCacheDelegate
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        
    }
}


extension UIImage {
    func es_scale(newWidth: CGFloat) -> UIImage {
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func es_thumbnail() -> UIImage {
        return es_scale(90)
    }
    
    func es_square() -> UIImage {
        let rect: CGRect
        if size.width > size.height {
            rect = CGRect(x: (size.width-size.height)/2, y: 0, width: size.height, height: size.height)
        }
        else if size.width < size.height {
            rect = CGRect(x: 0, y: (size.height-size.width)/2, width: size.width, height: size.width)
        }
        else {
            return self
        }
        if let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect) {
            return UIImage(CGImage: imageRef)
        }
        return self
    }
}


