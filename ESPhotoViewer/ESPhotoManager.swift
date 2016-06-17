//
//  ESPhotoManager.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


struct ESImageTask {
    let path: String
    let callback: (path: String, image: UIImage) -> Void
}

struct ESOriginalImageTask {
    let image: UIImage
    let path: String
    let callback: (path: String, image: UIImage) -> Void
}

class ESPhotoManager {
    
    static let manager = ESPhotoManager()
    
    let imageCache = NSCache()
    let thumbnailCache = NSCache()
//    let smallThumbnailCache = NSCache()
    
    var imageTasks = [ESImageTask]()
    
    var originalImageTasks = [ESOriginalImageTask]()
    
    let operationQueue = NSOperationQueue()
    
    init() {
        imageCache.countLimit = 8
        thumbnailCache.countLimit = 8
//        smallThumbnailCache.countLimit = 20
        
        runLoop = CFRunLoopGetMain()
    }
    
    
    
    
    func imageForPath(path: String, callback: ((path: String, image: UIImage) -> Void)) {
        
        if let image = imageCache.objectForKey(path) as? UIImage {
            callback(path: path, image: image)
            print("originalImageCache")
            return
        }
        else if let image = thumbnailCache.objectForKey(path) as? UIImage {
            callback(path: path, image: image)
            print("thumbnailCache")
            operationQueue.addOperationWithBlock({ 
                if let image = UIImage(contentsOfFile: path) {
                    self.addOriginalImageTask(ESOriginalImageTask(image: image, path: path, callback: callback))
                }
            })
            return
        }
        
        for task in imageTasks {
            if task.path == path {
                imageTasks.append(ESImageTask(path: path, callback: callback))
                return
            }
        }
        
        addImageTask(ESImageTask(path: path, callback: callback))
        
    }
    
    
    func addImageTask(imageTask: ESImageTask) {
        
        imageTasks.append(imageTask)
        
        operationQueue.addOperationWithBlock {
            var image = UIImage(contentsOfFile: imageTask.path)
            if image != nil {
                if let thumbnail = image!.thumbnailForSize(UIScreen.mainScreen().bounds.size) {
                    if CFRunLoopCopyCurrentMode(self.runLoop) == kCFRunLoopDefaultMode {
                        
                    }
                    else {
                        image = thumbnail
                        self.addOriginalImageTask(ESOriginalImageTask(image: image!, path: imageTask.path, callback: imageTask.callback))
                    }
                    self.thumbnailCache.setObject(thumbnail, forKey: imageTask.path)
                }
                else {
                    self.imageCache.setObject(image!, forKey: imageTask.path)
                }
                
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let tasks = self.imageTasks
                for (idx, task) in tasks.enumerate() {
                    if task.path == imageTask.path {
                        let index = idx - (tasks.count - self.imageTasks.count)
                        self.imageTasks.removeAtIndex(index)
                        if image != nil {
                            task.callback(path: imageTask.path, image: image!)
                            print("File")
                        }
                    }
                }
                
            })
            
        }
    }
    
    
    var runLoop: CFRunLoop!
    var observer: CFRunLoopObserver!
    var spinlock: OSSpinLock = OS_SPINLOCK_INIT
    
    
    func addOriginalImageTask(originalImageTask: ESOriginalImageTask) {
        OSSpinLockLock(&spinlock)
        originalImageTasks.append(originalImageTask)
        OSSpinLockUnlock(&spinlock)
                
        if observer == nil {
            observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 1 << 5, true, 0) { (observer, activity) in
                //
                print("AZUSA  \(self.originalImageTasks.count)")
                
                OSSpinLockLock(&self.spinlock)
                let tasks = self.originalImageTasks
                OSSpinLockUnlock(&self.spinlock)
                self.originalImageTasks.removeAll()
                
                
                for task in tasks {
                    task.callback(path: task.path, image: task.image)
                    print("RunLoop")
                }
                
                defer {
                    if self.originalImageTasks.count == 0 {
                        print("Remove")
                        CFRunLoopRemoveObserver(self.runLoop, observer, kCFRunLoopDefaultMode)
                    }
                }
                
            }
        }
        
        if !CFRunLoopContainsObserver(runLoop, observer, kCFRunLoopDefaultMode) {
            print("Add")
            CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode)
        }
        
    }
    

}



extension UIImage {
    
    func thumbnailForSize(drawSize: CGSize) -> UIImage? {
        
        let scale = UIScreen.mainScreen().scale
//        let scale: CGFloat = 1
        let drawableSize = CGSizeMake(drawSize.width * scale, drawSize.height * scale)
        
        if size.height <= drawableSize.height && size.width <= drawableSize.width {
            return nil
        }
        
        
        let newSize: CGSize
        let height = drawableSize.width * size.height / size.width
        if height < drawableSize.height {
            newSize = CGSizeMake(drawableSize.width, height)
        }
        else {
            let width = drawableSize.height * size.width / size.height
            newSize = CGSizeMake(width, drawableSize.height)
        }
        
        
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}