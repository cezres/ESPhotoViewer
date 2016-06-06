//
//  ESPhotoViewer.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

public class ESPhotoViewer: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var imagePaths: [String]!
    
    var currentIndex: Int = 0 {
        didSet {
            print(currentIndex, scrollView.contentOffset.x)
            
            if currentIndex == 0 || currentIndex == imagePaths.count-1 {
                return
            }
            
            if currentIndex > oldValue {
                if currentIndex == 1 {
                    return
                }
                let item = photoItems.removeFirst()
                photoItems.append(item)
                item.imagePath = imagePaths[currentIndex + 1]
                item.frame = CGRectMake(CGFloat(currentIndex + 1) * scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
            }
            else if currentIndex < oldValue {
                if currentIndex == imagePaths.count-2 {
                    return
                }
                let item = photoItems.removeLast()
                photoItems.insert(item, atIndex: 0)
                item.imagePath = imagePaths[currentIndex - 1]
                item.frame = CGRectMake(CGFloat(currentIndex - 1) * scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
            }
        }
    }
    
    var photoItems = [ESPhotoItem]()
    
    public init(imagePaths: [String], index: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.imagePaths = imagePaths
        currentIndex = index
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        initSubviews()
        
    }
    
    public override func viewDidDisappear(animated: Bool) {
        ESPhotoCache.sharedInstance.removeAllObjects()
        super.viewDidDisappear(animated)
    }
    
    override public func viewWillLayoutSubviews() {
        
        if view.frame.width < view.frame.height {
            scrollView.frame = CGRectMake(0, 20, view.bounds.width, view.bounds.height - 20)
        }
        else {
            scrollView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.bounds.width * CGFloat(imagePaths.count), scrollView.bounds.height)
        scrollView.contentOffset = CGPointMake(scrollView.frame.width * CGFloat(currentIndex), 0)
        
//        let flag = currentIndex == 0 ? 0 : 1
        for (idx, item) in photoItems.enumerate() {
            let index = CGFloat(currentIndex - (currentIndex == 0 ? 0 : 1) + idx)
            item.frame = CGRectMake(index * scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
        }
        
        super.viewWillLayoutSubviews()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ESPhotoCache.sharedInstance.removeAllObjects()
    }
    
    func initSubviews() {
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        for i in 0..<3 {
            print(i)
            let item = ESPhotoItem()
            photoItems.append(item)
            scrollView.addSubview(item)
        }
        
        for (idx, item) in photoItems.enumerate() {
            item.imagePath = imagePaths[idx - (currentIndex == 0 ? 0 : 1) + currentIndex]
        }
        
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(currentIndex+1) * scrollView.frame.width {
            currentIndex += 1
        }
        else if scrollView.contentOffset.x < CGFloat(currentIndex-1) * scrollView.frame.width {
            currentIndex -= 1
        }
    }

}


