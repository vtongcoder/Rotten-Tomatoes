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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response != nil {
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                let code = httpResponse.statusCode
                if (error == nil && code == 200)
                {
                    self.loadingIndicator.stopAnimating()
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        self.dvds = json["movies"] as? [NSDictionary]
                        self.dvdListTableView.reloadData()
                    }
                } else {
                    println("Error: \(error.code)")
                }
            }
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock{(status: AFNetworkReachabilityStatus) -> Void in
            switch status.hashValue{
            case AFNetworkReachabilityStatus.NotReachable.hashValue:
                println("Not reachable")
                self.networkErrorAlert()
            case AFNetworkReachabilityStatus.ReachableViaWiFi.hashValue, AFNetworkReachabilityStatus.ReachableViaWWAN.hashValue:
                println("Reachable")
            default:
                println("Unknown status")
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
        var url = NSURL(string: dvd.valueForKeyPath("posters.thumbnail")as! String)!
        cell.dvdPosterImage.setImageWithURL(url)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       let cell = sender as! UITableViewCell
        let indexPath = dvdListTableView.indexPathForCell(cell)
        let dvd = dvds![indexPath!.row]
        let movieDetails = segue.destinationViewController as! MovieDetailsViewController
        movieDetails.movie = dvd
    }
    func networkErrorAlert(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Network error❗️", message: "Network connect has error. Please check you wifi connection then try again. Thank you!", preferredStyle: .Alert)
        let okButton: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {action -> Void in
            self.loadingIndicator.stopAnimating()
        }
        actionSheetController.addAction(okButton)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }


}
