//
//  ViewController.swift
//  ESPhotoViewer Demo
//
//  Created by 翟泉 on 16/6/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ESPhotoViewer

class ViewController: UIViewController {
    
    var imagePaths = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)[0] + "/RNB33 图包"
        
        traverseDirectory(path/*"/Users/cezr/Documents/存档/下载/RNB33 图包"*/) { (filePath) in
            
            let pathExtension = filePath.pathExtension
            
            
            if pathExtension == "png" {
                print(filePath)
                self.imagePaths.append(filePath as String)
            }
            else if pathExtension == "jpg" {
                print(filePath)
                self.imagePaths.append(filePath as String)
            }
            else if pathExtension == "jpeg" {
                print(filePath)
                self.imagePaths.append(filePath as String)
            }
            
            
        }
        
    }
    
    
    @IBAction func clickButton(sender: AnyObject) {
        
        presentViewController(ESPhotoViewer(imagePaths: imagePaths, index: 3), animated: true) {
            //
        }
        
    }
    
    
    func traverseDirectory(directoryPath: String, subDirectory: Bool = false, callback: (filePath: NSString)->Void ) {
        do {
            let filenames = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryPath)
            for filename in filenames {
                let path = directoryPath + "/" + filename
                
                
                
                
                callback(filePath: path)
                
                var flag: ObjCBool = false
                NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &flag)
                
                if subDirectory && flag.boolValue {
                    
                    traverseDirectory(path, subDirectory: subDirectory, callback: callback)
                    
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

