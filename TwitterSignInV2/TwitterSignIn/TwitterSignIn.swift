//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

public struct TwitterUser
{
    public var token:String
}

public class TwitterSignIn
{
    public static let sharedInstance = TwitterSignIn();
    
    
    public var clientId = ""
    public var callbackUrl:String = "";
    
    
    public typealias SignInCallback = (TwitterUser?, NSError?)->Void;
    private var _signInCallback:SignInCallback?
    
    
    public func signIn(callback:@escaping SignInCallback)
    {
        _signInCallback = callback
        
        signInWithWeb()
    }
    
    private func signInWithWeb()
    {
        //Step 1
        //The codeChallenge value create from AuthorizeUrl will use to access token
        let authorizeData =  OAuthRequest.constructAuthorizeUrl(clientId: clientId, callbackUrl: callbackUrl)
        
        //Step 2
        OAuthRequest.authorize(authorizeUrl: authorizeData.authorizeUrl, callbackUrl: callbackUrl) { response, error in
            if let error = error {
                self._signInCallback?(nil, TwitterSignInError.FailedError(error: error))
                return
            }
            
            guard let authCode = response?.code else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "web auth authorize success, but something wrong with response"))
                return
            }
            
            self.accessToken(authCode: authCode, codeVerifier: authorizeData.codeVerifier)
            
        }
        
    }
    
    
    //Step 3
    private func accessToken(authCode: String, codeVerifier:String)
    {
        OAuthRequest.accessToken(authCode: authCode, clientId: clientId, callbackUrl: callbackUrl, codeVerifier: codeVerifier)
        { (response:OAuthRequest.AccessTokenResponse?, error:NSError?) in
            if let error = error {
                self._signInCallback?(nil, TwitterSignInError.FailedError(error: error))
                return
            }
            
            guard let accessToken = response?.access_token
            else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "web auth accessToken success, but something wrong with response"))
                return
            }
            
            let user = TwitterUser(token: accessToken)
            self._signInCallback?(user, nil)
        }
    }
    
    
    //Apis*************************************
    
    public func userMe(token:String, callback:@escaping UserMe.UserMeCallback)
    {
        UserMe.request(bearerToken: token, callback: callback)
    }
    
}


