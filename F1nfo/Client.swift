//
//  Client.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    var session: NSURLSession

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - All purpose task method for data
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        // 1. Parameters
        
        // 2. Build url
        let urlString = Constants.BaseUrl + method + Constants.Format
        let url = NSURL(string: urlString)!
        
        // 3. Configure request
        let request = NSURLRequest(URL: url)
        
        // 4. Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let _ = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                // 5/6. Parse and use data
                Client.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    // MARK: - Helpers
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}
