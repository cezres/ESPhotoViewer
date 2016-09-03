//
//  ESPhotoViewer.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 2016/9/3.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

public class ESPhotoViewer: UIViewController {
    
    var index: Int = 0 {
        willSet {
            
        }
        didSet {
            guard index != oldValue else {
                return
            }
            print(index)
        }
    }
    
    public class func view(imageURLs: [URL], inController controller: UIViewController) {
        controller.present(ESPhotoViewer(imageURLs: imageURLs), animated: true, completion: nil)
    }
    
    
    private var imageURLs: [URL]!
    
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    
    init(imageURLs: [URL]) {
        super.init(nibName: nil, bundle: nil)
        self.imageURLs = imageURLs
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ESPhotoCache.removeAllCache()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white()
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.itemSize = view.bounds.size
        flowLayout.sectionInset = UIEdgeInsetsZero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = view.backgroundColor
        collectionView.register(ESPhotoCell.classForCoder(), forCellWithReuseIdentifier: "Photo")
        view.addSubview(collectionView)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ESPhotoCache.removeAllCache()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if collectionView.frame != view.bounds {
            flowLayout.itemSize = view.bounds.size
            collectionView.frame = view.bounds
            collectionView.contentOffset = CGPoint(x: CGFloat(index) * collectionView.bounds.size.width, y: 0)
            collectionView.reloadData()
        }
        
    }
    
}



extension ESPhotoViewer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Number
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    // MARK: - Size
    
    // MARK: - Cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath)
    }
    
    // MARK: - Data
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photo = cell as? ESPhotoCell else {
            return
        }
        photo.imageURL = imageURLs[indexPath.row]
        ESPhotoCache.shared.loadImage(url: imageURLs[indexPath.row])
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
}
