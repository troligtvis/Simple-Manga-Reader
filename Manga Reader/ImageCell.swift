//
//  ImageCell.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-12-14.
//  Copyright © 2015 kj. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return theImageView
    }
    
    func downloadImage(url: String, completionHandler: ((UIImage) -> Void)?){
        
        downloadImageAsync(url) {
            image in
            dispatch_async(dispatch_get_main_queue(), {
                self.theImageView.image = image
                self.theImageView.hidden = false
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
                self.reloadInputViews()
                
                completionHandler?(image)
            })
        }
    }
    
    func downloadImageAsync(url: String, completionHandler: ((UIImage) -> Void)?){
        
        if let url = NSURL(string: url) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                guard let data = data where error == nil else {
                    print("Error")
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    print("Error no image")
                    return
                }
                
                completionHandler?(image)
            }
        }
    }
}