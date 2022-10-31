//
//  TwitterSignIn
//
//  Created by jammy-huang on 2022/10/25.
//

import Foundation

internal extension Array where Element == String {
    
    func toJsonString() -> String
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: []);
            return String(data: jsonData, encoding: .utf8) ?? "";
        } catch {
            print("ArrayExtension toJsonString Error:\(error)");
        }
        return "";
    }
}

internal extension Array where Element == [String:Any] {
    
    func toJsonString() -> String
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: []);
            return String(data: jsonData, encoding: .utf8) ?? "";
        } catch {
            print("ArrayExtension toJsonString Error:\(error)");
        }
        return "";
    }
}
