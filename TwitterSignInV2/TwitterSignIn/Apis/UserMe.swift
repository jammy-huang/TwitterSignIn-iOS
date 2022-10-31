//
//  UserMe.swift
//  TwitterSignInV2
//
//  Created by jammy-huang on 2022/11/1.
//

import Foundation

public class UserMe
{
    public typealias UserMeCallback = (UserMeResponse?, NSError?)->Void;
    
    static internal func request(bearerToken:String, callback:@escaping UserMeCallback)
    {
        let userMeHttp = UserMeHttp(bearerToken)
        HttpClient().request(userMeHttp) { (response:UserMeResponse?, error:NSError?) in
            if let error = error {
                callback(nil, error)
                return
            }
            
            callback(response, nil)
        }
    }
    
    private class UserMeHttp: HttpRequest
    {
        override var method:HTTP_METHOD {
            return HTTP_METHOD.get;
        }

        override var url:String {
            return "https://api.twitter.com/2/users/me";
        }

        override var header:[String:String] {

            let authorizationHeader = ["Authorization" : "Bearer \(self._bearerToken)"]
            return authorizationHeader;
        }

        private var _bearerToken:String = ""
        public init(_ bearerToken:String) {
            super.init()
            self._bearerToken = bearerToken
        }
    }

    public struct UserMeData: Decodable
    {
        public var id:String?
        public var name:String?
        public var username:String?
    }
    
    public struct UserMeResponse: Decodable
    {
        public var data:UserMeData?
    }
}


