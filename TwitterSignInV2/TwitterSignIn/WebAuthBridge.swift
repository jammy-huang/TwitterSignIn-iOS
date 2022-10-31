//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/26.
//

import Foundation
import SafariServices
import AuthenticationServices

internal class WebAuthBridge :NSObject
{
    public static let shared = WebAuthBridge()
    
    public typealias WebAuthCallback = (URL?, NSError?)->Void;
    
    
    //keep a reference at the top-level, otherwise, will not pop up UI and throw a Warning
    @available(iOS 12.0, *)
    private var _session: ASWebAuthenticationSession?
    
    @available(iOS 12.0, *)
    public func auth(authUrl:String, callbackUrl:String, callback:@escaping WebAuthCallback) {
        if (_session != nil) {
            print("[TwitterSignIn] There is already a request for authenticated session. Cancelling active authentication session before starting the new one.")
            DispatchQueue.main.async {
                self._session?.cancel()
                self._session = nil
            }
        }
        
        guard let authURL = URL(string: authUrl) else {
            callback(nil, TwitterSignInError.FailedError(description: "AuthenticationUrl is invalid"))
            return
        }
        
        let callbackURLScheme = callbackUrl.components(separatedBy: "://").first
        
        DispatchQueue.main.async {
            self._session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme) { (url, error) in
                if let error = error {
                    //When user click the cancel button on upper left corner of browser, will retuen ASWebAuthenticationSessionError.canceledLogin
                    if ((error as NSError).code == ASWebAuthenticationSessionError.canceledLogin.rawValue) {
                        callback(nil, TwitterSignInError.CancelFromWebError())
                    } else {
                        callback(nil, error as NSError)
                    }
                    return
                }
                
                callback(url, nil)
            }
            
            if #available(iOS 13.0, *) {
                self._session?.presentationContextProvider = self
            }

            self._session?.start()
        }
    }
    
}


// This is need for ASWebAuthenticationSession
@available(iOS 13.0, *)
extension WebAuthBridge: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!;
    }
}
