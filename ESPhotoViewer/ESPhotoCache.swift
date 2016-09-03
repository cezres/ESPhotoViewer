//
//  ESPhotoCache.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 2016/9/3.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoCache {
    
    typealias Callback = (url: URL, image: UIImage) -> Void
    
    private struct LoadImageCallback {
        let url: URL
        let callback: Callback
    }
    
    private var operations = [URL]()
    private var callbacks = [Int: LoadImageCallback]()
    private var queue = OperationQueue()
    
    static let shared = ESPhotoCache()
    
    private var cache: Cache<NSURL, UIImage>!
    
    private var operationsLock: OSSpinLock = OS_SPINLOCK_INIT
    private var callbacksLock: OSSpinLock = OS_SPINLOCK_INIT
    
    private init() {
        cache = Cache()
        cache.countLimit = 10
    }
    
    // MARK: - Func
    
    /**
     *  清除缓存
     */
    class func removeAllCache() {
        shared.cache.removeAllObjects()
    }
    
    /**
     *  取消回调
     */
    class func cancelCallack(hash: Int) {
        OSSpinLockLock(&shared.callbacksLock)
        shared.callbacks.removeValue(forKey: hash)
        OSSpinLockUnlock(&shared.callbacksLock)
    }
    
    /**
     *  加载图片
     */
    class func loadImage(hash: Int, url: URL, callback: Callback!) {
        if let result = shared.cache.object(forKey: url) {
            callback?(url: url, image: result)
            return
        }
        
        appendCallback(hash: hash, url: url, callback: callback)
        
        if hasOperation(url: url) {
            return
        }
        appendOperation(url: url)
        
        
        shared.queue.addOperation {
            var image: UIImage!
            
            defer {
                removeOperation(url: url)
                ESPhotoCache.callback(url: url, image: image)
            }
            
            do {
                let imageData = try Data(contentsOf: url)
                image = UIImage(data: imageData)
            }
            catch {
                image = nil
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, 1)
            image.draw(in: CGRect(origin: CGPoint(), size: image.size))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard image != nil else {
                return
            }
            shared.cache.setObject(image!, forKey: url)
        }
    }
    
    // MARK: Private
    
    private class func hasOperation(url: URL) -> Bool {
        for obj in shared.operations {
            if obj == url {
                return true
            }
        }
        return false
    }
    
    private class func appendOperation(url: URL) {
        OSSpinLockLock(&shared.operationsLock)
        defer {
            OSSpinLockUnlock(&shared.operationsLock)
        }
        shared.operations.append(url)
    }
    private class func removeOperation(url: URL) {
        OSSpinLockLock(&shared.operationsLock)
        defer {
            OSSpinLockUnlock(&shared.operationsLock)
        }
        for (idx, obj) in shared.operations.enumerated() {
            if obj == url {
                shared.operations.remove(at: idx)
                break
            }
        }
        
    }
    
    private class func appendCallback(hash: Int, url: URL, callback: Callback!) {
        if callback != nil {
            OSSpinLockLock(&shared.callbacksLock)
            defer {
                OSSpinLockUnlock(&shared.callbacksLock)
            }
            shared.callbacks[hash] = LoadImageCallback(url: url, callback: callback)
        }
    }
    
    private class func callback(url: URL, image: UIImage!) {
        OSSpinLockLock(&shared.callbacksLock)
        defer {
            OSSpinLockUnlock(&shared.callbacksLock)
        }
        let callbacks = shared.callbacks
        for (idx, callback) in callbacks {
            if callback.url == url {
                shared.callbacks.removeValue(forKey: idx)
                if image != nil {
                    OperationQueue.main().addOperation({ 
                        callback.callback(url: url, image: image)
                    })
                }
            }
        }
    }
    
    
}

