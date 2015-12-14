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
    
    private let mangaList: [String] = ["Bleach",
                                       "One Piece",
                                       "Fairy Tail",
                                       "Fairy Tail Zero",
                                       "Naruto Gaiden",
                                       "Attack On Titan",
                                       "Assassination Classroom",
                                       "One Punch Man"]
    
    enum SegueIdentifier: String {
        case ShowSeriesViewController = "SegueToSeries"
    }
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTable.delegate = self
        theTable.dataSource = self
    }
}

extension ViewController: SegueHandlerType {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segueIdentifierForSegue(segue) {
        case .ShowSeriesViewController:
            guard let vc = segue.destinationViewController as? SerieViewController else {
            fatalError("wrong view controller type")
        }
        
        vc.index = index
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        index = indexPath.row
        performSegueWithIdentifier(.ShowSeriesViewController, sender: self)
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = mangaList[indexPath.row]
        
        return cell
    }
}
