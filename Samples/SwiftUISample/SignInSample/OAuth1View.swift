//
//  OAuth1View.swift
//  SignInSample
//
//  Created by jammy-huang on 2022/10/31.
//

import SwiftUI

import TwitterSignInV1

class OAuth1Data: ObservableObject {
    @Published var responseTime:String = ""
    @Published var errorDesc:String = ""
    @Published var token:String = ""
    @Published var secret:String = ""
    @Published var userId:String = ""
    @Published var userName:String = ""
    
    
    func doSignIn()
    {
        //reset data
        self.responseTime = ""
        self.errorDesc = ""
        
        //config***************************
        TwitterSignIn.sharedInstance.consumerKey = "your value"
        TwitterSignIn.sharedInstance.consumerSecret = "your value"
        TwitterSignIn.sharedInstance.callbackUrl = "your value"

        //Is use Twitter App sign in***************************
        //TwitterSignIn.sharedInstance.appAuthEnable = true
        
        //begin sign in***************************
        TwitterSignIn.sharedInstance.signIn { user, error in
            //sign in response***************************
            DispatchQueue.main.async {
                self.responseTime = Date().description(with: .current)

                if let error = error {
                    self.errorDesc = error.description
                    return
                }

                if let user = user {
                    self.token = user.token
                    self.secret = user.secret ?? ""
                    self.userId = user.userId ?? ""
                    self.userName = user.userName ?? ""
                }
            }
        }
        
    }
    
}

struct OAuth1View: View
{
    @EnvironmentObject var currOAuthViewData:OAuthViewData
    
    @StateObject private var oauth1Data = OAuth1Data()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Version: OAuth 1.1a")
                    Button("Go to OAuth 2.0") {
                        currOAuthViewData.OAuthVersion = 2
                    }
                    .padding(.top, 2)
                }
                .padding(.top, 15)
                .padding(.leading, 20)
                Spacer()
            }
            .padding(.bottom, 80)

            Button(action: {
                oauth1Data.doSignIn()
            }, label: {
                Image("sign-in-with-twitter-gray")
                    .resizable()
                    .frame(width: 240, height: 40)
            })
            .padding(.bottom, 50)
            
            OAuth1ResponseText(responseData: oauth1Data)
            
            Spacer()
        }
        .onOpenURL { url in
            //If use App Auth, need to recived openUrl***************************
            TwitterSignIn.sharedInstance.handleUrl(url)
        }
    }
}

struct OAuth1ResponseText: View
{
    @StateObject var responseData: OAuth1Data
    
    func getShowTest() ->String
    {
        if (responseData.responseTime.isEmpty) {
            return "output..."
        } else {
            let timeText = "\(responseData.responseTime)"
            if (responseData.errorDesc.isEmpty) {
                let tokenText = "token=\(responseData.token)"
                let secretText = "secret=\(responseData.secret)"
                let userIdText = "userId=\(responseData.userId)"
                let userNameText = "userName=\(responseData.userName)"
                
                let showText = "Twitter SignIn Success!\n\(timeText)\n\n\(tokenText)\n\(secretText)\n\(userIdText)\n\(userNameText)"
                print("[Simple] \(showText)")
                return showText
            }
            else {
                let errorText = "error=\(responseData.errorDesc)"
                let showText = "Twitter SignIn Failed!\n\(timeText)\n\n\(errorText)"
                print("[Simple] \(showText)")
                return showText
            }
        }
    }
    
    var body: some View {
        Text(getShowTest())
            .textSelection(.enabled)
    }
}


struct OAuth1View_Previews: PreviewProvider {
    static var previews: some View {
        OAuth1View()
    }
}
