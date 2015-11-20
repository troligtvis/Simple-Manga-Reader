//
//  ContentViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-06-04.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var pageNr: UILabel!
    
    var pageIndex: Int!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Imagefile: \(imageFile)")
        self.theImageView.imageFromUrl(imageFile)
        self.pageNr.text = "\(pageIndex + 1)"
        self.view.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if error != nil{
                    print("error")
                }

                self.image = UIImage(data: data!)
            }
        }
    }
}

