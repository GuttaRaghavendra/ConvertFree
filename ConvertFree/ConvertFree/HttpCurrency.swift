//
//  HttpCurrency.swift
//  ConvertFree
//
//  Created by RaghavendraX Gutta on 24/11/15.
//  Copyright © 2015 Intel. All rights reserved.
//

import UIKit

enum RequestType {
    case CURRENCY_LIST
    case COUNTRY_LIST
    case HISTORICAL_LIST
}
public class HttpCurrency: NSURLSession {
    private let APP_ID = "3dee49820cd54f129498866c1896f0ae"
    private let APP_ID_TAG = "app_id"
    private let BASE_URL = "https://openexchangerates.org/api/"
    private let LATEST = "latest.json"
    private let CURRENCIES = "currencies.json"
    private let HISTORICAL = "historical"
    
    func getList(type:RequestType, historicalDate:NSDate?, response:(Int16, NSData?, NSError?) -> Void) throws {
        var urlString:String?
        switch type{
        case .CURRENCY_LIST:
            urlString = getCurrencyUrl()
        case .COUNTRY_LIST:
            urlString = getCountryUrl()
        case .HISTORICAL_LIST:
            urlString = getHistoryUrl(historicalDate)
        }
        let session = HttpCurrency.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: urlString!)!) { (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) -> Void in
            let code = (urlResponse as! NSHTTPURLResponse).statusCode
            response(Int16(code), data, error)
        }
        task.resume()
    }
    
    private func getCurrencyUrl() -> String {
        return BASE_URL + LATEST + "?" + APP_ID_TAG + "=" + APP_ID
    }
    
    private func getCountryUrl() -> String {
        return BASE_URL + CURRENCIES + "?" + APP_ID_TAG + "=" + APP_ID
    }
    
    private func getHistoryUrl(date:NSDate?) -> String {
        let url = BASE_URL + HISTORICAL + "/" + getFormattedDate(date) + ".json" + "?" + APP_ID_TAG + "=" + APP_ID
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    private func getFormattedDate(date:NSDate?) -> String {
        let formatter = NSDateFormatter()
        if let date = date {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            return formatter.stringFromDate(date)
        }
        return formatter.stringFromDate(NSDate())
    }
    
}
