//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

open class HttpRequest
{
    public init() {}
    
    public enum HTTP_METHOD:String {
        case get    = "GET"
        case post   = "POST"
        case delete = "DELETE"
    }
    
    open var method:HTTP_METHOD { return HTTP_METHOD.get; };
    
    open var url:String {  return ""; }
    
    open var header:[String:String] { return [:]; }
    
    open var body:Any { return [:]; }
}
