//
//  WebServiceManager.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/23/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class WebServiceManger: NSObject,URLSessionDelegate {
    
    class func requestUrl(_ strUrl:String, completion:@escaping(_ data: AnyObject?, _ response: URLResponse?, _ error: Error?)-> Void){
        let targetURLString = strUrl
        let urlRequest = NSMutableURLRequest(url: URL(string: targetURLString as String)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest){(data,response, error)in
        
            if error == nil{
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200
                {
                    let strData = String(data: data!, encoding:String.Encoding.utf8)
                    
                    do{
                        let dataArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        completion(dataArray as AnyObject?, response,error)
                        

                    }catch let dataError
                    {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        return
                    }
                }else{
                    do{
                        let dataArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        completion(dataArray as? Data as AnyObject?, response, error)
                    }catch let dataError {
                        print(dataError)
                        let jsonStr = NSString(data:data!, encoding: String.Encoding.utf8.rawValue)
                         print("Error could not parse JSON: '\(jsonStr)'")
                        return
                        
                    }
                }
            }else{
                let jsonStr = NSString(data:data!, encoding: String.Encoding.utf8.rawValue)
                completion(jsonStr as AnyObject?, response, error)
            }
        }.resume()
    }
    
    class func requestUrl(_ strUrl:String, withPostStr soapStr:String, completion:@escaping (_ data: AnyObject?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        
        
        let targetURLString = strUrl
        
        let urlRequest = NSMutableURLRequest(url: URL(string: targetURLString as String)!)
        
        let msglength = String(format: "%lu", soapStr.characters.count)
        
        urlRequest.addValue(msglength, forHTTPHeaderField: "Content-Length")
        
        urlRequest.httpBody = soapStr.data(using:.utf8)
        
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            
            if error == nil {
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    
                    
                    let strData = String(data: data!, encoding: String.Encoding.utf8)
                  
                    do {
                        
                        let result = strData?.data(using: .utf8)
                        
                        
                        
                        let dataArray = try JSONSerialization.jsonObject(with: result!, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        //print(dataArray)
                        
                        completion(dataArray as AnyObject? , response, error)
                        
                        
                        
                    } catch let dataError {
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        
                        print(dataError)
                        
                        //let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
                        //print("Error could not parse JSON: '\(soapStr)'")
                        
                        // return or throw?
                        
                        return
                        
                    }
                    
                }else {
                    
                    do {
                        
                        let dataArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        completion(dataArray  as? Data as AnyObject?, response, error)
                        
                        
                        
                    }catch let dataError {
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        
                        // print(dataError)
                        
                        //let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
                        // print("Error could not parse JSON: '\(jsonStr)'")
                        
                        // return or throw?
                        
                        return
                        
                    }
                    
                }
                
            }else{
                
                //  the json object was nil, something went worng. Maybe the server isn't running?
                
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //  print("Error could not parse JSON: \(jsonStr)")
                
                completion(jsonStr as AnyObject?, response, error)
                
            }
            
            
            
            }.resume()
        
    }
    
}
    

