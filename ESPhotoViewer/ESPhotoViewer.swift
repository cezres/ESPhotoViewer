//
//  ESPhotoViewer.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import Foundation

public protocol ESPhotoViewerDelegate: NSObjectProtocol {
    func photoViewer(photoViewer: ESPhotoViewer, willDisplayPhoto item: ESPhotoItem)
    func photoViewer(photoViewer: ESPhotoViewer, didSelectPhoto item: ESPhotoItem)
}

public class ESPhotoViewer: UIView {
    
    public var imageSource = [NSURL]()
    
    public var currentIndex: Int = 0
    
    public weak var delegate: ESPhotoViewerDelegate?
    
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    
    
    public init() {
        super.init(frame: CGRectZero)
        initializationSubViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializationSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func AZ() {
        print("AZUSA")
    }
    
    private func initializationSubViews() {
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ESPhotoViewerCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Item")
        collectionView.pagingEnabled = true
        
        self.addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        
        collectionView.frame = bounds
        
        flowLayout.itemSize = CGSize(width: frame.width, height: frame.height - 20)
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        
        super.layoutSubviews()
    }
}


extension ESPhotoViewer: UICollectionViewDelegate {
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//        print(currentIndex)
    }
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
        if let photoCell = cell as? ESPhotoViewerCollectionViewCell {
            photoCell.setImageURL(imageSource[indexPath.row])
            photoCell.item.index = indexPath.row
            delegate?.photoViewer(self, willDisplayPhoto: photoCell.item)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = collectionView.cellForItemAtIndexPath(indexPath) as? ESPhotoViewerCollectionViewCell {
            delegate?.photoViewer(self, didSelectPhoto: photoCell.item)
        }
    }
}

extension ESPhotoViewer: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Item", forIndexPath: indexPath)
    }
    
}

