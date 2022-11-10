//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

@objcMembers
@objc
public class TwitterUser :NSObject
{
    public var token:String
    public var secret:String? = nil
    public var userId:String? = nil
    public var userName:String? = nil
    
    init(token: String, secret: String? = nil, userId: String? = nil, userName: String? = nil) {
        self.token = token
        self.secret = secret
        self.userId = userId
        self.userName = userName
    }
}

@objcMembers
@objc
public class TwitterSignIn :NSObject
{
    public static let sharedInstance = TwitterSignIn();
    
    //**Attention**
    //App authorization is not recommended!
    //It is implemented by UIApplication.open(url:), and it is easy to expose the consumerSecret and consumerKey.
    //This may create unknown and dangers risks.
    public var appAuthEnable:Bool = false
    
    public var consumerKey:String = "";
    public var consumerSecret:String = "";
    public var callbackUrl:String = "";
    
    public typealias SignInCallback = (TwitterUser?, NSError?)->Void;
    private var _signInCallback:SignInCallback?
    
    
    public func signIn(_ withCallback:@escaping SignInCallback)
    {
        _signInCallback = withCallback
        
        if (appAuthEnable == true) {
            signInWithApp()
        } else {
            signInWithWeb()
        }
    }
    
    private func signInWithApp()
    {
        SSORequest.appAuth(consumerKey: consumerKey, consumerSecret: consumerSecret, callbackUrl: callbackUrl)
        { (response:SSORequest.AppAuthResponse?, error:NSError?) in
            if let error = error {
                //no twitter app install, use web auth
                if (error.code == TwitterSignInError.NoTwitterApp) {
                    self.signInWithWeb()
                    return
                }
                
                self._signInCallback?(nil, error)
                return
            }
            
            guard let token = response?.token,
                  let secret = response?.secret,
                  let userName = response?.username
            else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "app auth success, but something wrong with response"))
                return
            }
            
            let user = TwitterUser(token: token, secret: secret, userId: "", userName: userName)
            self._signInCallback?(user, nil)
        }
    }
    
    private func signInWithWeb()
    {
        //Step 1
        OAuthRequest.requestToken(consumerKey: consumerKey, consumerSecret: consumerSecret, callbackUrl: callbackUrl)
        { (response:OAuthRequest.RequestTokenResponse?, error:NSError?) in
            if let error = error {
                self._signInCallback?(nil, TwitterSignInError.FailedError(error: error))
                return
            }
            
            guard let oauthToken:String = response?.oauth_token else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "web auth requestToken success, but something wrong with response"))
                return
            }
            
            self.authorize(oauthToken: oauthToken)
        }
    }
    
    //Step 2
    private func authorize(oauthToken:String)
    {
        OAuthRequest.authorize(oauthToken: oauthToken, callbackUrl: callbackUrl)
        { (response:OAuthRequest.AuthorizeResponse?, error:NSError?) in
            if let error = error {
                if (error.code == TwitterSignInError.CancelFromWeb) {
                    self._signInCallback?(nil, error)
                } else {
                    self._signInCallback?(nil, TwitterSignInError.FailedError(error: error))
                }
                return
            }
            
            guard let oauthToken = response?.oauth_token,
               let oauthVerifier = response?.oauth_verifier else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "web auth authorize success, but something wrong with response"))
                return
            }
            
            self.accessToken(oauthToken: oauthToken, oauthVerifier: oauthVerifier)
        }
    }
    
    
    //Step 3
    private func accessToken(oauthToken:String, oauthVerifier:String)
    {
        OAuthRequest.accessToken(consumerKey: consumerKey,
                                 consumerSecret: consumerSecret,
                                 callbackUrl: callbackUrl,
                                 oauthToken: oauthToken,
                                 oauthVerifier: oauthVerifier)
        { (response:OAuthRequest.AccessTokenResponse?, error:NSError?) in
            if let error = error {
                self._signInCallback?(nil, TwitterSignInError.FailedError(error: error))
                return
            }
            
            guard let token = response?.oauth_token,
                  let secret = response?.oauth_token_secret,
                  let userId = response?.user_id
            else {
                self._signInCallback?(nil, TwitterSignInError.UnKnowError(description: "web auth accessToken success, but something wrong with response"))
                return
            }
            
            let user = TwitterUser(token: token, secret: secret, userId: userId, userName: "")
            self._signInCallback?(user, nil)
        }
    }
    
    
    public func handleUrl(_ url:URL)
    {
        SSORequest.handleUrl(url)
    }
    
}


