//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

public class HttpClient :HttpClientSession
{
    public typealias HttpClientCallback<T :Decodable> = (T?, NSError?)->Void;
    
    public func request<T: Decodable>(_ request:HttpRequest, callback:@escaping HttpClientCallback<T>) {

        httpRequestHandler(httpMethod: request.method, urlAddress: request.url, header: request.header, body: request.body) { responseData, error in
            
            //network error or other connect error will first callback
            if let error = error {
                callback(nil, error);
                return;
            }

            //reaponse empty data see as success
            guard let responseData = responseData else {
                callback(nil, nil);
                return;
            }
            
            if (responseData.count <= 0) {
                callback(nil, nil);
                return;
            }
            
            guard let responseStr = String(data: responseData, encoding: .utf8) else {
                callback(nil, nil);
                return
            }
            
            let jsonResponseInstance:T?  = HttpClient.decodeJson(jsonString: responseStr);
            if (jsonResponseInstance != nil) {
                callback(jsonResponseInstance, nil);
                return;
            }
            
            let queryResponseInstance:T? = HttpClient.decodeQueryString(queryString: responseStr)
            callback(queryResponseInstance, nil);
        }
    }
    
    
    static public func decodeJson<T: Decodable>(jsonString:String) ->T?
    {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let jsonDecoder = JSONDecoder()
            let responseInstance:T = try jsonDecoder.decode(T.self, from: jsonData)
            return responseInstance
        } catch {
            return nil
        }
    }
    
    static public func decodeQueryString<T: Decodable>(queryString:String) ->T?
    {
        let paramStrList = queryString.split(separator: "&");
        var paramMap:[String:String] = [:]
        paramStrList.forEach { paramStr in
            let paramKV = paramStr.split(separator: "=")
            if (paramKV.count == 2) {
                paramMap[String(paramKV[0])] = String(paramKV[1])
            }
        }
        
        guard let queryJsonData = paramMap.toJsonString().data(using: .utf8) else {
            return nil
        }
        
        do {
            let jsonDecoder = JSONDecoder();
            let instance:T = try jsonDecoder.decode(T.self, from: queryJsonData)
            return instance
        }
        catch {
            return nil
        }
    }
    
    
}
