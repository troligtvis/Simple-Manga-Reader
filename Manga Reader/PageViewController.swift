//
//  PageViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-12-14.
//  Copyright © 2015 kj. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    @IBOutlet weak var theCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let identifier = "collection cell"
    
    var imageCache = [String: UIImage]()
    var pageImageUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theCollection.delegate = self
        theCollection.dataSource = self
        
        flowLayout.itemSize = self.view.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        theCollection.reloadData()
    }
    
    @IBAction func didPressBackButton(sender: AnyObject) {
        print("BACK")
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension PageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ImageCell
        
        let url = pageImageUrls[indexPath.row]
        if let image = imageCache[url]{
            cell.theImageView.image = image
        } else {
            cell.downloadImage(url) {
                image in
                self.imageCache[url] = image
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageImageUrls.count
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let pageWidth = self.view.frame.width
        let minSpace: CGFloat = 0
        
        var cellToSwipe = (scrollView.contentOffset.x)/(pageWidth + minSpace) + 0.5
        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= CGFloat(pageImageUrls.count) {
            cellToSwipe = CGFloat(pageImageUrls.count - 1)
        }
        
        self.theCollection.scrollToItemAtIndexPath(NSIndexPath(forRow: Int(cellToSwipe), inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = self.view.frame.width
        let minSpace: CGFloat = 0
        
        var cellToSwipe = (scrollView.contentOffset.x)/(pageWidth + minSpace) + 0.5
        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= CGFloat(pageImageUrls.count) {
            cellToSwipe = CGFloat(pageImageUrls.count - 1)
        }
        
        self.theCollection.scrollToItemAtIndexPath(NSIndexPath(forRow: Int(cellToSwipe), inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
}