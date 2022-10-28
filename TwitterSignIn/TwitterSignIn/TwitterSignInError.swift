//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/27.
//

import Foundation

public class TwitterSignInError
{
    static public let UnKnow = -1
    static public let Success = 0
    static public let CancelFromWeb = 1
    static public let CancelFromApp = 2
    static public let NoTwitterApp = 3
    static public let Failed = 4
    
    static private let ERROR_DOMAIN = "TwitterSignIn"
    
    static public func UnKnowError(description:String? = nil) ->NSError
    {
        return NSError(domain: ERROR_DOMAIN, code: UnKnow, userInfo: [NSLocalizedDescriptionKey : description ?? "UnKnow Error"]);
    }
    
    static public func CancelFromWebError() ->NSError
    {
        return NSError(domain: ERROR_DOMAIN, code: CancelFromWeb, userInfo: [NSLocalizedDescriptionKey : "User cancelled Sign in from Web"]);
    }
    
    static public func CancelFromAppError() ->NSError
    {
        return NSError(domain: ERROR_DOMAIN, code: CancelFromApp, userInfo: [NSLocalizedDescriptionKey : "User cancelled Sign in from Twitter App"]);
    }
    
    static public func NoTwitterAppError() ->NSError
    {
        return NSError(domain: ERROR_DOMAIN, code: NoTwitterApp, userInfo: [NSLocalizedDescriptionKey : "No Twitter App installed."]);
    }
    
    static public func FailedError(description:String? = nil) ->NSError
    {
        return NSError(domain: ERROR_DOMAIN, code: Failed, userInfo: [NSLocalizedDescriptionKey : description ?? "UnKnow Failed"]);
    }
    
    static public func FailedError(error:NSError? = nil) ->NSError
    {
        if let error = error {
            return NSError(domain: ERROR_DOMAIN, code: Failed, userInfo: [NSLocalizedDescriptionKey : "\(error.code) \(error.localizedDescription)"]);
        } else {
            return NSError(domain: ERROR_DOMAIN, code: Failed, userInfo: [NSLocalizedDescriptionKey : "UnKnow Failed"]);
        }
    }
    
}
