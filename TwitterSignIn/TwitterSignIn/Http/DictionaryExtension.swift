//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

internal extension Dictionary {
    
    func toJsonString() -> String
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: []);
            return String(data: jsonData, encoding: .utf8) ?? "";
        } catch {
            print("DictionaryExtension toJsonString Error:\(error)")
        }
        return "";
    }
}

extension Dictionary where Key == String,Value == String
{
    public func append(other:Dictionary<String, String>) ->Dictionary<String, String>
    {
        var newDictionary:Dictionary<String, String> = [:];
        self.forEach { (selfKey, selfValue) in
            newDictionary[selfKey] = selfValue;
        }
        other.forEach { (otherKey, otherValue) in
            newDictionary[otherKey] = otherValue;
        }
        return newDictionary;
    }
}
