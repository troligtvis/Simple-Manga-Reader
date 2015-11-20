//
//  ViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-06-03.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theTable: UITableView!
    
    private var mangaList = [String]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        theTable.delegate = self
        theTable.dataSource = self
        
        mangaList = ["Bleach",
                     "One Piece",
                     "Fairy Tail",
                     "Fairy Tail Zero",
                     "Naruto Gaiden",
                     "Attack On Titan",
                     "Assassination Classroom",
                     "One Punch Man"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToStart(segue: UIStoryboardSegue) {
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToSeries" {
            if let nav = segue.destinationViewController as? UINavigationController{
                if let vc = nav.topViewController as? SerieViewController{
                    vc.index = index
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        performSegueWithIdentifier("SegueToSeries", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel?.text =
            mangaList[indexPath.row]
        
        return cell
    }
}
