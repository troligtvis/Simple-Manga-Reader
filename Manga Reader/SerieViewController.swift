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
    
    var chapters = [[String]]()
    var urlToChapter = ""
    
    var index: Int = 0
    var serieIndex: Series!
    
    enum Series: Int{
        case Bleach = 0
        case OnePiece
        case FairyTail
        case FairyTailZero
        case NarutoGaiden
        case AttackOnTitan
        case AssassinationClassroom
        case OnePunchMan
        
        func name() -> String{
            switch self{
            case .Bleach:
                return "Bleach"
            case .OnePiece:
                return "One Piece"
            case .FairyTail:
                return "Fairy Tail"
            case .FairyTailZero:
                return "Fairy Tail Zero"
            case .NarutoGaiden:
                return "Naruto Gaiden"
            case .AttackOnTitan:
                return "Attack On Titan"
            case .AssassinationClassroom:
                return "Assassination Classroom"
            case .OnePunchMan:
                return "One Punch Man"
            }
        }
        
        func pageUrl() -> String{
            switch self{
            case .Bleach:
                return "http://www.mangareader.net/94/bleach.html"
            case .OnePiece:
                return "http://www.mangareader.net/103/one-piece.html"
            case .FairyTail:
                return "http://www.mangareader.net/135/fairy-tail.html"
            case .FairyTailZero:
                return "http://www.mangareader.net/fairy-tail-zero"
            case .NarutoGaiden:
                return "http://www.mangareader.net/naruto-gaiden-the-seventh-hokage"
            case .AttackOnTitan:
                return "http://www.mangareader.net/shingeki-no-kyojin"
            case .AssassinationClassroom:
                return "http://www.mangareader.net/assassination-classroom"
            case .OnePunchMan:
                return "http://www.mangareader.net/onepunch-man"
            }
        }
        
        func logoImg() -> UIImage{
            switch self{
            case .Bleach:
                return UIImage(named: "logo_bleach")!
            case .OnePiece:
                return UIImage(named: "logo_onepiece")!
            case .FairyTail:
                return UIImage(named: "logo_fairytail")!
            case .FairyTailZero:
                return UIImage(named: "logo_fairytail_zero")!
            case .NarutoGaiden:
                return UIImage(named: "logo_naruto")!
            case .AttackOnTitan:
                return UIImage(named: "logo_attackontitan")!
            case .AssassinationClassroom:
                return UIImage(named: "logo_assassination_classroom")!
            case .OnePunchMan:
                return UIImage(named: "logo_one_punch_man")!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTable.delegate = self
        theTable.dataSource = self
        
        serieIndex = Series(rawValue: index)
        imgView.image = serieIndex.logoImg()
        self.navigationItem.title = serieIndex.name()
        
        getChapters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChapters(){
        let url = NSURL(string: serieIndex.pageUrl())
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                print("Done")
                var urlError = false
            
                if let data = data where error == nil {
                    let urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    var urlContentArray = urlContent.componentsSeparatedByString("<div class=\"chico_manga\"></div>")
                    
                    if urlContentArray.count > 0 {
                        print("1: \(urlContentArray.count)")
                        
                        var index = 0
                        for var i = 7; i < urlContentArray.count; i++ {
                            var firstCut = urlContentArray[i].componentsSeparatedByString("</td>")
                            var w = firstCut[0].componentsSeparatedByString("<a href=\"")
                            var s = w[1].componentsSeparatedByString("\">")
                            var chapterNrAndTitle = s[1].componentsSeparatedByString("</a> : ")
                            
                            let chapterUrl = s[0]
                            let chapterNr = chapterNrAndTitle[0]
                            let title = chapterNrAndTitle[1]
                            
                            self.chapters.append( ["\(index)", chapterUrl, chapterNr, title] )
                            index++
                        }
                    } else {
                        urlError = true
                    }
                } else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if urlError == true {
                        print("\(error!.localizedDescription)")
                    } else {
                        self.chapters = Array(self.chapters.reverse())
                        self.theTable.reloadData()
                    }
                }
            })
            
            task.resume()
        }
    }
    
    @IBAction func unwindToSerie(segue: UIStoryboardSegue) {
    }
}

extension SerieViewController: UITableViewDelegate, UITableViewDataSource{
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MoveToChapter"{
            if let vc = segue.destinationViewController as? ChapterViewController{
                vc.urlToChapter = urlToChapter
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        urlToChapter = "http://www.mangareader.net\(chapters[indexPath.row][1])"
        performSegueWithIdentifier("MoveToChapter", sender: self)
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

