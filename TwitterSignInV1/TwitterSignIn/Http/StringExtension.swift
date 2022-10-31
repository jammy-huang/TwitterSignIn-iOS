//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

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
    
}
