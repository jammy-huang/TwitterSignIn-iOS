//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

internal class Authorization
{
    private static let OAUTH_VERSION:String = "1.0"
    private static let OAUTH_SIGNATURE_METHOD:String = "HMAC-SHA1"
    
    static func createAuthorizationHeader(url:String,
                                          httpMethod:HttpRequest.HTTP_METHOD ,
                                          consumerKey:String,
                                          consumerSecret:String,
                                          callbackUrl:String,
                                          otherParam:[String: String]? = nil) ->[String:String]
    {
        var authParams:[String: String] = [:]
        authParams["oauth_version"] = OAUTH_VERSION
        authParams["oauth_signature_method"] = OAUTH_SIGNATURE_METHOD
        authParams["oauth_consumer_key"] = consumerKey
        authParams["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
        authParams["oauth_nonce"] = UUID().uuidString
        authParams["oauth_callback"] = callbackUrl
        
        if let otherParam = otherParam {
            authParams = authParams.append(other: otherParam)
        }
        
        let oauthSignature = creatingSignature(url: url, httpMethod: httpMethod, authParams: authParams, consumerSecret: consumerSecret)
        authParams["oauth_signature"] = oauthSignature
        
        let authorizationHeaderKey = "Authorization"
        //Creating authorization header value
        //1.Percent encode every key and value that will be signed.
        var encodedFinalAuthParams:[String: String] = [:]
        authParams.forEach { (key: String, value: String) in
            encodedFinalAuthParams[key.urlEncoded()] = value.urlEncoded()
        }
        //2.Sort the final params by key
        let sortedFinalKeyList = encodedFinalAuthParams.keys.sorted{ $0 < $1 }
        //3.For each key/value pair:
        //4.Append the encoded key to the output string.
        //5.Append the ‘=’ character to the output string.
        //6.Append the encoded value to the output string.
        var outputFinalParamList:[String] = []
        sortedFinalKeyList.forEach { key in
            outputFinalParamList.append("\(key)=\"\(encodedFinalAuthParams[key]!)\"")
        }
        //7.If there are more key/value pairs remaining, append ‘, ’ character to the output string.
        //(with a space after ’,‘)
        let finalParameterString = outputFinalParamList.joined(separator: ", ")
        let authorizationHeaderValue =  "OAuth " + finalParameterString
        
        return [authorizationHeaderKey : authorizationHeaderValue]
    }
    
    //Creating a signature
    //https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
    static func creatingSignature(url:String, httpMethod:HttpRequest.HTTP_METHOD, authParams:[String: String], consumerSecret:String) ->String
    {
        //Collecting parameters
        //1.Percent encode every key and value that will be signed.
        var encodedAuthParams:[String: String] = [:]
        authParams.forEach { (key: String, value: String) in
            encodedAuthParams[key.urlEncoded()] = value.urlEncoded()
        }
        //2.Sort the list of parameters alphabetically [1] by encoded key [2].
        let sortedKeyList = encodedAuthParams.keys.sorted{ $0 < $1 }
        //3.For each key/value pair:
        //4.Append the encoded key to the output string.
        //5.Append the ‘=’ character to the output string.
        //6.Append the encoded value to the output string.
        var outputParamList:[String] = []
        sortedKeyList.forEach { key in
            outputParamList.append("\(key)=\(encodedAuthParams[key]!)")
        }
        //7.If there are more key/value pairs remaining, append a ‘&’ character to the output string.
        let parameterString = outputParamList.joined(separator: "&")
        
        //Creating the signature base string
        var signatureBaseString:String = ""
        //1.Convert the HTTP Method to uppercase and set the output string equal to this value.
        let uppercaseMethod = httpMethod.rawValue.uppercased()
        signatureBaseString.append(uppercaseMethod)
        //2.Append the ‘&’ character to the output string.
        signatureBaseString.append("&")
        //3.Percent encode the URL and append it to the output string.
        signatureBaseString.append(url.urlEncoded())
        //4.Append the ‘&’ character to the output string.
        signatureBaseString.append("&")
        //5.Percent encode the parameter string and append it to the output string.
        signatureBaseString.append(parameterString.urlEncoded())
        
        //Getting a signing key
        let signingKey:String = "\(consumerSecret.urlEncoded())&"
        
        //Calculating the signature
        let signingKeyData = signingKey.data(using: .utf8)!

        let signatureBaseStringData = signatureBaseString.data(using: .utf8)!
        let signatureSha1 = HMAC.sha1(key: signingKeyData, message: signatureBaseStringData)!
        let OAuthSignature = signatureSha1.base64EncodedString(options: [])

        return OAuthSignature
    }
    
}
