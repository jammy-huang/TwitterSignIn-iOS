//
//  ContentView.swift
//  SignInSample
//
//  Created by jammy-huang on 2022/10/31.
//

import SwiftUI

class OAuthViewData: ObservableObject {
    @Published var OAuthVersion:Int = 2
}

struct ContentView: View {
    @StateObject private var currOAuthViewData = OAuthViewData()
    
    var body: some View {
        ZStack {
            if (currOAuthViewData.OAuthVersion == 1) {
                OAuth1View()
            } else if (currOAuthViewData.OAuthVersion == 2) {
                OAuth2View()
            }
        }
        .padding()
        .environmentObject(currOAuthViewData)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
