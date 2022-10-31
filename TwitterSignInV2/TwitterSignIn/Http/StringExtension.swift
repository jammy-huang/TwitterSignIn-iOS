//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

import CommonCrypto

internal extension String {
    
    func subString(startIndex:Int, endIndex:Int) ->String
    {
        if (startIndex == 0) {
            return String(self.prefix(endIndex + 1));
        }
        
        let beginIndex = self.index(self.startIndex, offsetBy: startIndex);
        let endIndex = self.index(self.startIndex, offsetBy: endIndex + 1);
        var result:String = String(self[beginIndex..<endIndex]);
        result = result.trimmingCharacters(in: CharacterSet.whitespaces);
        return result;
    }
    
    
    func urlEncoded() -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        allowedCharacterSet.insert(charactersIn: "[]")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    
    func sha256() -> String {
        guard let strData = self.data(using: String.Encoding.utf8) else {
            return ""
        }
        
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
        _ = strData.withUnsafeBytes {
            CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
        }
        var sha256String = ""
        for byte in digest {
            sha256String += String(format:"%02x", UInt8(byte))
        }
        
        return sha256String
    }
    
    func base64WithUrlencode() ->String
    {
        let base64Urlencode = Data(self.utf8).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        return base64Urlencode
    }
    
}
