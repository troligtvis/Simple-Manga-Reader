//
//  ChapterViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-06-04.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

class ChapterViewController: UIViewController {

    var pageViewcontroller: UIPageViewController!
    
    var pages = [String: String]()
    var pageImageUrls = [String]()
    
    var pageIndex = 0
    var totalPages = 0
    
    var urlToChapter: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchImages(urlToChapter, first: true)
    }
    
    func fetchImages(urlStr: String, first: Bool){
        var url = NSURL(string: urlStr)
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                var urlError = false
                
                if error == nil {
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    var urlContentArray = urlContent.componentsSeparatedByString("<option value=\"")
                    
                    if urlContentArray.count > 0 {
                        var firstCut = urlContentArray.last!.componentsSeparatedByString("<img id=\"img\"")
                        if firstCut.count > 0 {
                            var im = firstCut[1].componentsSeparatedByString(".jpg\"")
                            var im2 = im[0].componentsSeparatedByString("src=\"")
                            var firstImageUrl: String = "\(im2[1]).jpg"
                            var strForSorting = firstImageUrl as NSString

                            self.pages["\(strForSorting.substringFromIndex(27))"] = firstImageUrl
                            self.pageIndex++
                        }
                        
                        if first{
                            self.totalPages = urlContentArray.count - 1
                        
                            for var i = 2; i < urlContentArray.count; i++ {
                                var firstCut = urlContentArray[i].componentsSeparatedByString("\">")
                                self.fetchImages("http://www.mangareader.net\(firstCut[0])", first: false)
                            }
                        }
                    } else {
                        urlError = true
                    }
                } else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        println("\(error.localizedDescription)")
                    } else {
                        if self.pageIndex == self.totalPages {
                            let sortedKeysAndValues = sorted(self.pages) { $0.0 < $1.0 }
                            for i in sortedKeysAndValues{
                                self.pageImageUrls.append(i.1)
                            }
                            self.setupPageViewController()
                        }
                    }
                }
            })
            
            task.resume()
        } else {
            
        }

    }
    
    func setupPageViewController(){

        self.pageViewcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewcontroller.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as ContentViewController
        
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewcontroller.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        self.pageViewcontroller.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 40)
        
        self.addChildViewController(self.pageViewcontroller)
        self.view.addSubview(self.pageViewcontroller.view)
        self.pageViewcontroller.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChapterViewController: UIPageViewControllerDataSource {
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        if self.pageImageUrls.count == 0 || index >= self.pageImageUrls.count {
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = pageImageUrls[index]
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index: Int = vc.pageIndex
        
        if index == 0 || index == NSNotFound{
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index: Int = vc.pageIndex
        
        if index == NSNotFound{
            return nil
        }
        
        index++
        
        if index == pageImageUrls.count{
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageImageUrls.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}