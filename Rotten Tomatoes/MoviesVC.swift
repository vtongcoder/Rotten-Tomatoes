//
//  MoviesVC.swift
//  Rotten Tomatoes
//
//  Created by Dan Tong on 8/27/15.
//  Copyright (c) 2015 DanTong. All rights reserved.
//

import UIKit


class MoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    var movies: [NSDictionary]?
    var refreshControl:UIRefreshControl!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock{(status: AFNetworkReachabilityStatus) -> Void in
            switch status.hashValue{
            case AFNetworkReachabilityStatus.NotReachable.hashValue:
                println("Not reachable")
                self.networkErrorAlert()
            case AFNetworkReachabilityStatus.ReachableViaWiFi.hashValue, AFNetworkReachabilityStatus.ReachableViaWWAN.hashValue:
                println("Reachable")
                self.getInformation()
            default:
                println("Unknown status")
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.addSubview(refreshControl)
        
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(sender:AnyObject)
    {
        self.getInformation()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail")as! String)!
        
        cell.posterImage.setImageWithURL(url)
        return cell
     }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        let movieDetails = segue.destinationViewController as! MovieDetailsViewController
        movieDetails.movie = movie
    }
    
    func networkErrorAlert(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Network error❗️", message: "Network connect has error. Please check you wifi connection then try again. Thank you!", preferredStyle: .Alert)
        let okButton: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {action -> Void in
              self.loadingIndicator.stopAnimating()
        }
        actionSheetController.addAction(okButton)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    func getInformation() {
        loadingIndicator.startAnimating()
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if response != nil {
                let httpResponse: NSHTTPURLResponse = (response as! NSHTTPURLResponse?)!
                let code = httpResponse.statusCode
                
                if (error == nil && code == 200)
                {
                    self.loadingIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        self.movies = json["movies"] as? [NSDictionary]
                        self.moviesTableView.reloadData()
                    }
                } else {
                    println("Error: \(error.code)")
                }
            }
        }
        
    }
    
    
}
