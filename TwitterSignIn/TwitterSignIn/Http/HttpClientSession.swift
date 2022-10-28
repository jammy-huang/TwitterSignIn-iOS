//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

open class HttpClientSession : NSObject
{
    public static let DOMAIN:String = "HttpClient";
    public static let CODE_UNKNOW_ERROR:Int = -1;
    
    public typealias HttpSessionCallback = (Data?, NSError?)->Void;
    
    private var _requesting:Bool = false;
    
    public func httpRequestHandler(httpMethod:HttpRequest.HTTP_METHOD, urlAddress:String, header:[String:String]?, body:Any?, callBack:@escaping HttpSessionCallback) {
        
        if(_requesting) {
            callBack(nil, getError(code: HttpClientSession.CODE_UNKNOW_ERROR, desc: "It is requesting. Can not request again!"));
            return;
        }

        if (urlAddress.isEmpty) {
            callBack(nil, getError(code: HttpClientSession.CODE_UNKNOW_ERROR, desc: "urlAddress is null!"));
            return;
        }
        
        _requesting = true;
        
        var url:URL;
        var request:URLRequest;
        if (httpMethod == .get)
        {
            var getBodyStr:String = "";
            
            if let bodyDic:[String:Any] = body as? [String:Any] {
                if (bodyDic.count > 0) {
                    getBodyStr += "?";
                    bodyDic.forEach { (bodyKey: String, bodyValue: Any) in
                        getBodyStr += "\(bodyKey)=\(bodyValue)&";
                    }
                    getBodyStr = getBodyStr.subString(startIndex: 0, endIndex: getBodyStr.count - 2);
                }
            }
            let getUrlAddress = urlAddress + getBodyStr;
            url = URL(string: getUrlAddress)!;
            request = URLRequest(url: url)
            
            header?.forEach { (headerKey: String, headerValue: String) in
                request.addValue(headerValue, forHTTPHeaderField: headerKey);
            }
        }
        else {
            url = URL(string: urlAddress)!;
            request = URLRequest(url: url)
            
            header?.forEach { (headerKey: String, headerValue: String) in
                request.addValue(headerValue, forHTTPHeaderField: headerKey);
            }
            
            if let body = body {
                if let bodyDic:[String:Any] = body as? [String:Any] {
                    if (bodyDic.count > 0) {
                        request.httpBody = bodyDic.toJsonString().data(using: String.Encoding.utf8);
                    }
                } else if let bodyArr:[[String:Any]] = body as? [[String:Any]] {
                    if (bodyArr.count > 0) {
                        request.httpBody = bodyArr.toJsonString().data(using: String.Encoding.utf8);
                    }
                } else if let bodyStr:String = body as? String {
                    if (!bodyStr.isEmpty) {
                        request.httpBody = bodyStr.data(using: String.Encoding.utf8);
                    }
                }
            }
            
            if (request.httpBody != nil) {
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
        }
        
        let session = URLSession.shared
        request.httpMethod = httpMethod.rawValue;
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            self._requesting = false;
            self.httpCompletionHandler(data: data, error: error, callBack: callBack);
        });
        task.resume();
        
    }
    
    private func httpCompletionHandler(data:Data?, error:Error?, callBack:HttpSessionCallback)
    {
        if (error != nil)
        {
            if let nsError:NSError = error as NSError? {
                callBack(nil, nsError);
            } else {
                callBack(nil, getError(code: HttpClientSession.CODE_UNKNOW_ERROR, desc: error!.localizedDescription));
            }
            return;
        }

        guard let data = data else
        {
            callBack(nil, getError(code: HttpClientSession.CODE_UNKNOW_ERROR, desc: "response data is null!"));
            return;
        }
        
        callBack(data, nil);
    }
    
    public func getError(code:Int, desc:String) ->NSError
    {
        return NSError(domain: HttpClientSession.DOMAIN, code: code, userInfo: [NSLocalizedDescriptionKey : desc]);
    }
}

