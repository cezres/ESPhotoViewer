//
//  ESPhotoViewer.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/6/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

public class ESPhotoViewer: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var photoItems = [ESPhotoItem]()
    
    var imagePaths: [String]!
    
    var currentIndex: Int = 0 {
        didSet {
            didSetCurrentIndex(oldValue)
        }
    }
    
    public init(imagePaths: [String], index: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.imagePaths = imagePaths
        currentIndex = index
        title = "\(currentIndex+1)/\(imagePaths.count)"
        view.backgroundColor = UIColor.whiteColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = view.backgroundColor
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        for idx in 0..<5 {
            let item = ESPhotoItem()
            photoItems.append(item)
            scrollView.addSubview(item)
            
            let offset: Int
            if currentIndex > imagePaths.count-2 {
                offset = imagePaths.count - 5
            }
            else if currentIndex < 2 {
                offset = 0
            }
            else {
                offset = currentIndex - 2
            }
            let index = offset + idx
            item.imagePath = imagePaths[index]
        }
        layoutSubviews()
    }
    
    func layoutSubviews() {
        let rect: CGRect
        if view.frame.width < view.frame.height {
            rect = CGRectMake(0, 20, view.bounds.width, view.bounds.height - 20)
        }
        else {
            rect = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        }
        
        if rect != scrollView.frame {
            scrollView.frame = rect
            scrollView.contentSize = CGSizeMake(scrollView.bounds.width * CGFloat(imagePaths.count), scrollView.bounds.height)
            scrollView.contentOffset = CGPointMake(scrollView.frame.width * CGFloat(currentIndex), 0)
            
            for (idx, item) in photoItems.enumerate() {
                
                
                let offset: Int
                if currentIndex > imagePaths.count-2 {
                    offset = imagePaths.count - 5
                }
                else if currentIndex < 2 {
                    offset = 0
                }
                else {
                    offset = currentIndex - 2
                }
                
                let index = CGFloat(offset + idx)
                item.frame = CGRectMake(index * scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
            }
        }
        
    }
    
    func didSetCurrentIndex(oldIndex: Int) {
        title = "\(currentIndex+1)/\(imagePaths.count)"
        
        print(currentIndex)
        
        if currentIndex < 2 || currentIndex > imagePaths.count-3 {
            return
        }
        
        if currentIndex > oldIndex {
            if currentIndex == 2 {
                return
            }
            let item = photoItems.removeFirst()
            photoItems.append(item)
            let offset = CGFloat(currentIndex + 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = CGAffineTransformTranslate(item.transform, offset, 0)
            item.imagePath = imagePaths[currentIndex + 2]
        }
        else if currentIndex < oldIndex {
            if currentIndex == imagePaths.count-3 {
                return
            }
            let item = photoItems.removeLast()
            photoItems.insert(item, atIndex: 0)
            
            let offset = CGFloat(currentIndex - 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = CGAffineTransformTranslate(item.transform, offset, 0)
            item.imagePath = imagePaths[currentIndex - 2]
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
