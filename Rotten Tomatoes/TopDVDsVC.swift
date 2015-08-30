//
//  TopDVDsVC.swift
//  Rotten Tomatoes
//
//  Created by Dan Tong on 8/30/15.
//  Copyright (c) 2015 DanTong. All rights reserved.
//

import UIKit

class TopDVDsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dvdListTableView: UITableView!
    var dvds:[NSDictionary]?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            //            println(json)
            if let json = json {
                self.dvds = json["movies"] as? [NSDictionary]
                self.dvdListTableView.reloadData()
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dvds = self.dvds {
            return dvds.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DVDCell", forIndexPath: indexPath) as! dvdCellTableViewCell
        let dvd = dvds![indexPath.row]
        cell.dvdTitleLabel.text = dvd["title"] as? String
        cell.dvdSynopsisLabel.text = dvd["synopsis"] as? String
        let url = NSURL(string: dvd.valueForKeyPath("posters.thumbnail")as! String)!
        cell.dvdPosterImage.setImageWithURL(url)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
