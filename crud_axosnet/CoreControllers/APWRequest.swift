//
//  APWRequest.swift
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

import Alamofire

import Foundation
import UIKit

class APWSRequest : NSObject{
    // MARK:Life cycle
    @objc var baseURL = "https://devapi.axosnet.com/am/v2/api_receipts_beta/api/";
    var baseServer = URL.init(string: "https://devapi.axosnet.com/am/v2/api_receipts_beta/api");
    private static var _sharedInstance : APWSRequest?;
    @objc static func sharedInstance() -> APWSRequest{
        if (_sharedInstance == nil){
            _sharedInstance = APWSRequest.init();
        }

        return _sharedInstance!;
    }
    @objc static func resetInstance(){
        _sharedInstance = APWSRequest.init();
    }

    @objc public var isLoggedIn : Bool = false;
    var requestManager : Session!
    @objc override init() {
        super.init();

        let configuration = URLSessionConfiguration.default
        requestManager = Alamofire.Session(configuration: configuration)
        
    }

    // MARK: Requests
    @objc(POST: parameters: completion:)
    func post(path: String, parameters: [String: Any]? = [:], completion: @escaping (Any, Error?) -> Void)
    {
        
        let headers: HTTPHeaders = [.userAgent(""), .accept("0")]
        
        AF.request(baseURL+path, method: .post, headers: headers).response { response in
            switch response.result
                {
                case .success:
                    completion(true, nil)
                    
                case .failure(let error):

                    completion(false, error)
                }
           }
    }

    @objc(GET: parameters: completion:)
    func get(path: String, parameters: [String: Any]? = [:], completion: @escaping (Any, Error?) -> Void)
    {
       let headers: HTTPHeaders = [.userAgent("")]

       AF.request(baseURL+path, headers: headers).responseJSON { response in
        switch response.result
            {
            case .success(let value):
                completion(self.removeNullFromJSONData(value), nil)
                
            case .failure(let error):
                self.debugError(response: response, error: error);

                completion([:], error)
            }
       }
     }


    @objc(debugParams:)
    static func debugParams(params: [String: Any] ){
        #if DEBUG
        do {
            let paramsData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted);
            let paramsString = String(decoding: paramsData, as: UTF8.self);
            print(paramsString);

        } catch {
            print("Error - > \(error.localizedDescription) \n");
        }
        #endif
    }

    func debugError(response: Alamofire.AFDataResponse<Any>?, error: Error){
        #if DEBUG
        if let data = response?.data{
            let responseBody = String(decoding: data, as: UTF8.self);
            print(responseBody)
        }

//        response.response?.statusCode
        print(error.localizedDescription)
        #endif
    }


    // MARK:Auxiliary Functions
    @objc static func jsonObject(with data: Data!) -> Any {
      do {
        let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return object
      } catch {
        return String(decoding: data, as: UTF8.self)
      }
    }
    @objc static func jsonData(with object:[String: Any]?) -> Data? {
        if let obj = object{
            do {
              return try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed);
            } catch {
            }
        }
        return nil;
    }

    private func removeNullFromJSONData(_ JSONData: Any) -> Any {
        if JSONData as? NSNull != nil {
            return JSONData
        }

        var JSONObject: Any!

        if JSONData as? NSData != nil {
            JSONObject = try! JSONSerialization.data(withJSONObject: JSONData, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        else {
            JSONObject = JSONData
        }

        if JSONObject as? NSArray != nil {
            let mutableArray: NSMutableArray = NSMutableArray(array: JSONObject as! [Any], copyItems: true)
            let indexesToRemove: NSMutableIndexSet = NSMutableIndexSet()

            for index in 0 ..< mutableArray.count {
                let indexObject: Any = mutableArray[index]

                if indexObject as? NSNull != nil {
                    indexesToRemove.add(index)
                }
                else {
                    mutableArray.replaceObject(at: index, with: removeNullFromJSONData(indexObject))
                }
            }

            mutableArray.removeObjects(at: indexesToRemove as IndexSet)

            return mutableArray;
        }
        else if JSONObject as? NSDictionary != nil {
            let mutableDictionary: NSMutableDictionary = NSMutableDictionary(dictionary: JSONObject as! [AnyHashable : Any], copyItems: true)

            for key in mutableDictionary.allKeys {
                let indexObject: Any = mutableDictionary[key] as Any

                if indexObject as? NSNull != nil {
                    mutableDictionary.removeObject(forKey: key)
                }
                else {
                    mutableDictionary.setObject(removeNullFromJSONData(indexObject), forKey: key as! NSCopying)
                }
            }

            return mutableDictionary
        }
        else {
            return JSONObject as Any
        }
    }
}
