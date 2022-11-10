//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

//using 3-legged OAuth flow
//https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens
internal class OAuthRequest
{
    private static let TWITTER_API:String = "https://api.twitter.com"
    
    //Step 1: request token
    //https://developer.twitter.com/en/docs/authentication/api-reference/request_token
    public typealias RequestTokenCallback = (RequestTokenResponse?, NSError?)->Void;
    static func requestToken(consumerKey:String,
                             consumerSecret:String,
                             callbackUrl:String,
                             callback:@escaping RequestTokenCallback)
    {
        let requestTokenHttp = OAuthRequest.RequestTokenHttp(consumerKey, consumerSecret, callbackUrl)
        HttpClient().request(requestTokenHttp) { (response:RequestTokenResponse?, error:NSError?) in
            if let error = error {
                callback(nil, error)
                return
            }
            
            if let authErrors = response?.errors {
                callback(nil, TwitterSignInError.FailedError(code: authErrors[0].code, description: authErrors[0].message))
                return
            }
            
            callback(response, nil)
        }
    }
    
    
    public class RequestTokenHttp: HttpRequest
    {
        override var method:HTTP_METHOD {
            return HTTP_METHOD.post;
        }
        
        override var url:String {
            return "\(TWITTER_API)/oauth/request_token";
        }
        
        override var header:[String:String] {
            
            let authorizationHeader = Authorization.createAuthorizationHeader(url: self.url,
                                                                              httpMethod: self.method,
                                                                              consumerKey: _consumerKey,
                                                                              consumerSecret: _consumerSecret,
                                                                              callbackUrl: _callbackUrl)
            return authorizationHeader;
        }
        
        private var _consumerKey:String = ""
        private var _consumerSecret:String = ""
        private var _callbackUrl:String = ""
        public init(_ consumerKey:String, _ consumerSecret:String, _ callbackUrl:String) {
            super.init()
            self._consumerKey = consumerKey
            self._consumerSecret = consumerSecret
            self._callbackUrl = callbackUrl
        }
    }
    
    struct RequestTokenError: Decodable
    {
        public var code:Int = -1
        public var message:String = ""
    }
    
    struct RequestTokenResponse: Decodable
    {
        public var oauth_token:String?
        public var oauth_token_secret:String?
        public var oauth_callback_confirmed:String?
        
        public var errors:[RequestTokenError]?
    }
    
    
    
    //Step 2: authorize
    //https://developer.twitter.com/en/docs/authentication/api-reference/authorize
    public typealias AuthorizeCallback = (AuthorizeResponse?, NSError?)->Void;
    static func authorize(oauthToken:String, callbackUrl:String, callback:@escaping AuthorizeCallback)
    {
        let authorizeUrl:String = "\(TWITTER_API)/oauth/authorize?oauth_token=\(oauthToken)";
        
        WebAuthBridge.shared.auth(authUrl: authorizeUrl,
                                  callbackUrl: callbackUrl)
        { url, error in
            if let error = error {
                callback(nil, error)
                return
            }
            
            guard let urlStr:String = url?.absoluteString else {
                print("[TwitterSignIn] Error: Web auth success, but url is nil.")
                return
            }
            
            var paramStr = ""
            let urlList = urlStr.split(separator: "?")
            paramStr = urlList.count >= 2 ? String(urlList[1]) : urlStr
            
            let response:AuthorizeResponse? = HttpClient.decodeQueryString(queryString: paramStr)
            
            if (response?.denied != nil) {
                callback(nil, TwitterSignInError.CancelFromWebError())
                return
            }
            
            callback(response, nil)
        }
    }
    
    struct AuthorizeResponse: Decodable
    {
        public var denied:String?
        public var oauth_token:String?
        public var oauth_verifier:String?
    }
    
    
    
    //Step 3: get access token
    //https://developer.twitter.com/en/docs/authentication/api-reference/access_token
    public typealias AccessTokenCallback = (AccessTokenResponse?, NSError?)->Void;
    static func accessToken(consumerKey:String,
                            consumerSecret:String,
                            callbackUrl:String,
                            oauthToken:String,
                            oauthVerifier:String,
                            callback:@escaping AccessTokenCallback)
    {
        let accessTokenHttp = OAuthRequest.AccessTokenHttp(consumerKey, consumerSecret, callbackUrl, oauthToken, oauthVerifier)
        HttpClient().request(accessTokenHttp) { (response:AccessTokenResponse?, error:NSError?) in
            if let error = error {
                callback(nil, error)
                return
            }
            
            callback(response, nil)
        }
    }
    
    class AccessTokenHttp: HttpRequest
    {
        override var method:HTTP_METHOD {
            return HTTP_METHOD.post;
        }
        
        override var url:String {
            return "\(TWITTER_API)/oauth/access_token";
        }
        
        override var header:[String:String] {
            
            let authorizationHeader = Authorization.createAuthorizationHeader(url: self.url,
                                                                              httpMethod: self.method,
                                                                              consumerKey: _consumerKey,
                                                                              consumerSecret: _consumerSecret,
                                                                              callbackUrl: _callbackUrl,
                                                                              otherParam: _otherParam)
            return authorizationHeader;
        }
        
        private var _consumerKey:String = ""
        private var _consumerSecret:String = ""
        private var _callbackUrl:String = ""
        private var _otherParam:[String:String]?
        public init(_ consumerKey:String, _ consumerSecret:String, _ callbackUrl:String,
                    _ oauthToken:String, _ oauthVerifier:String) {
            super.init()
            self._consumerKey = consumerKey
            self._consumerSecret = consumerSecret
            self._callbackUrl = callbackUrl
            
            self._otherParam = [:]
            self._otherParam!["oauth_token"] = oauthToken
            self._otherParam!["oauth_verifier"] = oauthVerifier
        }
    }
    
    struct AccessTokenResponse: Decodable
    {
        public var oauth_token:String?
        public var oauth_token_secret:String?
        public var user_id:String?
        public var screen_name:String?
    }
    
}

