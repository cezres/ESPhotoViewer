//
//  ViewController.swift
//  ESPhotoViewer Demo
//
//  Created by 翟泉 on 16/6/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ESPhotoViewer

class ViewController: UIViewController {
    
    var imagePaths = [String]()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return
        }
        
        traverseDirectory(resourcePath) { (filePath) in
            
            let pathExtension = filePath.pathExtension
            
            if pathExtension == "png" {
                self.imagePaths.append(filePath as String)
            }
            else if pathExtension == "jpg" {
                self.imagePaths.append(filePath as String)
            }
            else if pathExtension == "jpeg" {
                self.imagePaths.append(filePath as String)
            }
            
        }
        
        
        imageView.image = UIImage(contentsOfFile: imagePaths[0])
        imageView.photo_centeringForSuperview()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
        
    }

    func handleTap(tapGestrue: UITapGestureRecognizer) {
        navigationController?.pushViewController(ESPhotoViewer(imagePaths: imagePaths, index: 1), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}

