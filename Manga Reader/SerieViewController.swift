//
//  ChapterViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-06-03.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

class SerieViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theTable: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    
    enum SegueIdentifier: String {
        case ShowChapterViewController = "SegueToChapter"
    }
    
    var chapters = [[String]]()
    var urlToChapter = ""
    
    var index: Int = 0
    private var serie: Serie!
    
    
    var pageImageUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTable.delegate = self
        theTable.dataSource = self
        
        serie = Serie(rawValue: index)
        imgView.image = serie.logoImg()
        self.navigationItem.title = serie.name()
        
        getChapters()
    }
    
    func getChapters(){
        guard let url = NSURL(string: serie.pageUrl()) else {
            print("error url is bad")
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            guard let data = data where error == nil else {
                print("error fetching chapters")
                return
            }
            
            guard let urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                print("error content is nil")
                return
            }
            
            let urlContentArray = urlContent.componentsSeparatedByString("<div class=\"chico_manga\"></div>")
            
            guard urlContentArray.count > 0 else {
                return
            }
            
            var index = 0
            for i in 7..<urlContentArray.count {
                var strip = urlContentArray[i].componentsSeparatedByString("</td>")
                strip = strip[0].componentsSeparatedByString("<a href=\"")
                strip = strip[1].componentsSeparatedByString("\">")
                var chapterNrAndTitle = strip[1].componentsSeparatedByString("</a> : ")
                
                let chapterUrl = strip[0]
                let chapterNr = chapterNrAndTitle[0]
                let title = chapterNrAndTitle[1]
                
                self.chapters.append( ["\(index)", chapterUrl, chapterNr, title] )
                index++
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.chapters = Array(self.chapters.reverse())
                self.theTable.reloadData()
            }
        }.resume()
    }
    
    @IBAction func didPressBackButton(sender: AnyObject) {
        print("BACK")
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension SerieViewController: SegueHandlerType {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .ShowChapterViewController:
            guard let vc = segue.destinationViewController as? PageViewController else {
                fatalError("wrong view controller type")
            }
            
            vc.pageImageUrls = pageImageUrls
        }
    }
}

extension SerieViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        urlToChapter = "http://www.mangareader.net\(chapters[indexPath.row][1])"
        
        ImageManager.requestFetchImages(urlToChapter, first: true) {
            urls in
            
            guard let urls = urls else {
                print("Failed")
                return
            }
            
            self.pageImageUrls = urls
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier(.ShowChapterViewController, sender: self)
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel?.text = chapters[indexPath.row][2]
        cell.detailTextLabel?.text = chapters[indexPath.row][3]
        return cell
    }
}