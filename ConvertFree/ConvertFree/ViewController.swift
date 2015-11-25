//
//  ViewController.swift
//  ConvertFree
//
//  Created by RaghavendraX Gutta on 23/11/15.
//  Copyright © 2015 Intel. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    private let CURRENCY = "Currency"
    lazy var context = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //country names
        getInfo (.COUNTRY_LIST, response: { (dict:[NSObject : AnyObject]?) -> Void in
            if let response = dict {
                self.storeCurrencyNames(response)
            }
        })
        //currency values
        getInfo (.CURRENCY_LIST, response: { (dict:[NSObject : AnyObject]?) -> Void in
            if let response = dict {
                self.storeCurrencyValues(response)
            }
        })
        
        
    }
    
    func storeCurrencyValues(response:[NSObject : AnyObject]) {
        if let rates = response["rates"] as? [String:AnyObject] where rates.count > 0{
            if !updateCurrencyValues(rates) {
                let codes = rates.keys
                for key in codes {
                    let item = NSEntityDescription.insertNewObjectForEntityForName(CURRENCY, inManagedObjectContext: context) as! Currency
                    item.code = key
                    item.value = rates[key]?.floatValue
                }
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                print(__FUNCTION__ + ":data inserted")
            }
        }
        
    }
    
    func storeCurrencyNames(response:[NSObject : AnyObject]) {
        if let names = response as? [String:AnyObject] where names.count > 0{
            if response.count > 0{
                if !updateCurrencyNames(response as! [String:AnyObject]) {
                    let codeList = names.keys
                    for code in codeList {
                        let item = NSEntityDescription.insertNewObjectForEntityForName(CURRENCY, inManagedObjectContext: context) as! Currency
                        item.code = code
                        item.name = names[code] as? String
                    }
                    (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                    print(__FUNCTION__ + ":data inserted")
                }
            }
        }
        
    }
    
    func updateCurrencyNames(response:[String : AnyObject]) -> Bool {
        let fetchResult = fetchCurrencyList() as? [Currency]
        if fetchResult?.count > 0 {
            for currencyItem:Currency in fetchResult! {
                currencyItem.name = response[currencyItem.code!] as? String
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            print(__FUNCTION__ + ":data updated")
            return true
        }
        return false
    }
    
    func updateCurrencyValues(response:[String : AnyObject]) -> Bool {
        let fetchResult = fetchCurrencyList() as? [Currency]
        if fetchResult?.count > 0 {
            for currencyItem:Currency in fetchResult! {
                currencyItem.value = response[currencyItem.code!]?.floatValue
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            print(__FUNCTION__ + ":data updated")
            return true
        }
        return false
    }
    
    func fetchCurrencyList() -> Array<AnyObject>? {
        let request = NSFetchRequest(entityName:CURRENCY)
        do {
            let results = try context.executeFetchRequest(request)
            return results
        }catch{
            print(__FUNCTION__ + ":data fetch error")
            return nil
        }
    }
    
    func getInfo(type:RequestType, response:([NSObject:AnyObject]?) -> Void) {
        do{
            try HttpCurrency().getList(type, historicalDate: nil) { (code:Int16, data:NSData?, error:NSError?) -> Void in
                if let error = error {
                    response(error.userInfo)
                } else{
                    do{
                        let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [NSObject:AnyObject]
                        response(dict)
                    }catch {
                        response(["exception":"json serialization error"])
                    }
                    
                }
            }
        } catch {
            print("cannot made request")
            response(["error":"cannot made request"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

