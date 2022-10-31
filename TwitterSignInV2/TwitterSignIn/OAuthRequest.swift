//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

import CommonCrypto


//OAuth 2.0 Authorization Code Flow with PKCE
//https://developer.twitter.com/en/docs/authentication/oauth-2-0/user-access-token
internal class OAuthRequest
{
    private static let TWITTER_AUTH_API:String = "https://twitter.com/i/oauth2/authorize?response_type=code"
    private static let TWITTER_API:String = "https://api.twitter.com"
    
    //Step 1: Construct an Authorize URL
    static func constructAuthorizeUrl(clientId:String, callbackUrl:String) ->(authorizeUrl:String, codeVerifier:String)
    {
        let scope = "tweet.read users.read".urlEncoded()
        let state = "TwitterSignIn"
        
        let codeChallengeMethod = "S256"
        let codeVerifier = UUID().uuidString.base64WithUrlencode()
        let codeChallenge = codeVerifierToCodeChallenge(codeVerifier)
        
        let authorizeUrl:String = "\(TWITTER_AUTH_API)&client_id=\(clientId)&redirect_uri=\(callbackUrl)&scope=\(scope)&state=\(state)&code_challenge=\(codeChallenge)&code_challenge_method=\(codeChallengeMethod)"
        
        return (authorizeUrl, codeVerifier)
    }
    
    
    static private func codeVerifierToCodeChallenge(_ verifier:String) ->String
    {
        guard let data = verifier.data(using: .utf8) else { return "" }
        var buffer = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        let hash = Data(buffer)
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return challenge
    }
    
    //Step 2: GET oauth2/authorize
    public typealias AuthorizeCallback = (AuthorizeResponse?, NSError?)->Void;
    static func authorize(authorizeUrl:String, callbackUrl:String, callback:@escaping AuthorizeCallback)
    {
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
            
            if let responseError = response?.error {
                if (responseError == "access_denied") {
                    callback(nil, TwitterSignInError.CancelFromWebError())
                } else {
                    callback(nil, TwitterSignInError.UnKnowError(description: responseError))
                }
                return
            }

            callback(response, nil)
        }
    }
    
    struct AuthorizeResponse: Decodable
    {
        public var error:String?
        public var state:String?
        public var code:String?
    }
    

    //Step 3: POST oauth2/token - Access Token
    public typealias AccessTokenCallback = (AccessTokenResponse?, NSError?)->Void;
    static func accessToken(authCode:String,
                            clientId:String,
                            callbackUrl:String,
                            codeVerifier:String,
                            callback:@escaping AccessTokenCallback)
    {
        let accessTokenHttp = OAuthRequest.AccessTokenHttp(authCode, clientId, callbackUrl, codeVerifier)
        HttpClient().request(accessTokenHttp) { (response:AccessTokenResponse?, error:NSError?) in
            if let error = error {
                callback(nil, error)
                return
            }
            
            if let responseError = response?.error {
                let errorMsg = "\(responseError) \(response.debugDescription)"
                callback(nil, TwitterSignInError.UnKnowError(description: errorMsg))
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
            return "\(TWITTER_API)/2/oauth2/token";
        }
        
        override var body:Any {
            var encodeData:[String:String] = [:]
            encodeData["code"] = _authCode.urlEncoded()
            encodeData["grant_type"] = "authorization_code"
            encodeData["client_id"] = _clientId.urlEncoded()
            encodeData["redirect_uri"] = _callbackUrl.urlEncoded()
            encodeData["code_verifier"] = _codeVerifier
            
            return encodeData;
        }
        
        private var _authCode:String = ""
        private var _clientId:String = ""
        private var _callbackUrl:String = ""
        private var _codeVerifier:String = ""
        
        public init(_ authCode:String, _ clientId:String, _ callbackUrl:String, _ codeVerifier:String) {
            super.init()
            self._authCode = authCode
            self._clientId = clientId
            self._callbackUrl = callbackUrl
            self._codeVerifier = codeVerifier
        }
    }
    
    struct AccessTokenResponse: Decodable
    {
        public var error:String?
        public var error_description:String?
        
        public var token_type:String?
        public var expires_in:Int?
        public var access_token:String?
        public var scope:String?
    }
    
}

