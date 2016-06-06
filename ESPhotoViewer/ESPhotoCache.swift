//
//  ESPhotoCache.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoCache: NSObject {
    
    static let sharedInstance = ESPhotoCache()
    
    var callbacks = [ESLoadImageCallback]()
    
    let imageCache = NSCache()
    
    let queue = NSOperationQueue()
    
    override init() {
        super.init()
        imageCache.countLimit = 6
    }
    
    func removeAllObjects() {
        imageCache.removeAllObjects()
    }
    
    func imageForPath(imagePath: String, callback: (imagePath: String, image: UIImage)->Void) {
        // Cache
        if let image = imageCache.objectForKey(imagePath) as? UIImage {
            callback(imagePath: imagePath, image: image)
            return
        }
        // File
        for loadImageCallback in callbacks {
            if loadImageCallback.imagePath == imagePath {
                callbacks.append(ESLoadImageCallback(imagePath: imagePath, callback: callback))
                return
            }
        }
        callbacks.append(ESLoadImageCallback(imagePath: imagePath, callback: callback))
        
        queue.addOperationWithBlock { 
            if let image = UIImage(contentsOfFile: imagePath) {
                
                self.imageCache.setObject(image, forKey: imagePath)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    let cbs = self.callbacks
                    for (idx,callback) in cbs.enumerate() {
                        if callback.imagePath == imagePath {
                            callback.callback(imagePath: imagePath, image: image)
                            let index = idx - (cbs.count - self.callbacks.count)
                            self.callbacks.removeAtIndex(index)
                        }
                    }
                })
                
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    let cbs = self.callbacks
                    for (idx,callback) in cbs.enumerate() {
                        if callback.imagePath == imagePath {
                            let index = idx - (cbs.count - self.callbacks.count)
                            self.callbacks.removeAtIndex(index)
                        }
                    }
                })
                
            }
        }
    }
    
    
}


struct ESLoadImageCallback {
    var imagePath: String
    var callback: (imagePath: String, image: UIImage)->Void
}

