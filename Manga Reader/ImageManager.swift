//
//  ImageManager.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-12-14.
//  Copyright © 2015 kj. All rights reserved.
//

import Foundation

struct ImageManager {
    static var totalPages = 0
    static var pageIndex = 0
    static var pages = [String: String]()
    
    static func requestFetchImages(urlString: String, first: Bool, completionHandler: ([String]? -> ())?){
       
        guard let url = NSURL(string: urlString) else {
            print("error bad url")
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            guard let data = data where error == nil else {
                completionHandler?(nil)
                return
            }
            
            guard let urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                completionHandler?(nil)
                return
            }
            
            let urlContentArray = urlContent.componentsSeparatedByString("<option value=\"")
            
            guard urlContentArray.count > 0 else {
                completionHandler?(nil)
                return
            }
            
            var strip = urlContentArray.last!.componentsSeparatedByString("<img id=\"img\"")
            
            guard strip.count > 0 else {
                completionHandler?(nil)
                return
            }
            
            strip = strip[1].componentsSeparatedByString(".jpg\"")
            strip = strip[0].componentsSeparatedByString("src=\"")
            let firstImageUrl: String = "\(strip[1]).jpg"
            strip = strip[1].componentsSeparatedByString("/")
            pages["\(strip[5])"] = firstImageUrl
            pageIndex++
            
            if first {
                totalPages = urlContentArray.count - 1
                
                for i in 2...totalPages {
                    let firstCut = urlContentArray[i].componentsSeparatedByString("\">")
                    requestFetchImages("http://www.mangareader.net\(firstCut[0])", first: false, completionHandler: completionHandler)
                }
            }
            
            
            //print(pageIndex, totalPages)
           if pageIndex == totalPages {
                let sortedPages = pages.sort { $0.0 < $1.0 }
                
                var pageImageUrls = [String]()
                for (_, url) in sortedPages {
                    pageImageUrls.append(url)
                }
                
                completionHandler?(pageImageUrls)
            }
        }.resume()
    }
}