//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/27.
//

import Foundation
import UIKit

internal class SSORequest
{
    public typealias AppAuthCallback = (AppAuthResponse?, NSError?)->Void;
    
    private static var _appAuthCallback:AppAuthCallback?
    
    static public func appAuth(consumerKey:String,
                        consumerSecret:String,
                        callbackUrl:String,
                        callback:@escaping AppAuthCallback)
    {        
        guard let callbackURLScheme = callbackUrl.components(separatedBy: "://").first else {
            return
        }
        let appAuthUrlStr = "twitterauth://authorize?consumer_key=\(consumerKey)&consumer_secret=\(consumerSecret)&oauth_callback=\(callbackURLScheme)"
        guard let appAuthURL:URL = URL(string: appAuthUrlStr) else {
            return
        }
        
        if (!UIApplication.shared.canOpenURL(appAuthURL)) {
            callback(nil, TwitterSignInError.NoTwitterAppError())
            return
        }
        
        _appAuthCallback = callback
        
        UIApplication.shared.open(appAuthURL)
    }
    
    struct AppAuthResponse: Decodable
    {
        public var secret:String?;
        public var token:String?;
        public var username:String?;
    }
    
    static public func handleUrl(_ url:URL)
    {
        guard let paramStr = url.absoluteString.components(separatedBy: "://").last else {
            return
        }
        
        if (paramStr.isEmpty) {
            _appAuthCallback?(nil, TwitterSignInError.CancelFromAppError())
            return
        }
        
        let response:AppAuthResponse? = HttpClient.decodeQueryString(queryString: paramStr)
        _appAuthCallback?(response, nil)
    }
}

