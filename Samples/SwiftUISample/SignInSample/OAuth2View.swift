//
//  OAuth1View.swift
//  SignInSample
//
//  Created by jammy-huang on 2022/10/31.
//

import SwiftUI

import TwitterSignInV2

class OAuth2Data: ObservableObject {
    @Published var responseTime:String = ""
    @Published var errorDesc:String = ""
    
    @Published var token:String = ""
    
    
    func doSignIn()
    {
        //reset data
        self.responseTime = ""
        self.errorDesc = ""
        
        //config***************************
        TwitterSignIn.sharedInstance.clientId = "your value"
        TwitterSignIn.sharedInstance.callbackUrl = "your value"
        
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
                }
            }
        }
        
    }
}


class UserMeData: ObservableObject {
    @Published var errorDesc:String = ""
    @Published var userMeInfo:String = ""
    
    @Published var isShowAlert:Bool = false
    
    func doUserMe(token:String)
    {
        if (token.isEmpty) {
            return
        }
        
        self.errorDesc = ""
        self.userMeInfo = ""
        
        TwitterSignIn.sharedInstance.userMe(token: token) { meInfo, error in
            //User Me response***************************
            DispatchQueue.main.async {
                self.isShowAlert = true

                if let error = error {
                    self.errorDesc = error.description
                    return
                }

                if let meInfo = meInfo {
                    self.userMeInfo = """
                                    UserMeInfo:\n
                                    id=\(meInfo.data?.id ?? "null")\n
                                    username=\(meInfo.data?.username ?? "null")
                                    """
                }
            }
        }
    }
}

struct OAuth2View: View
{
    @EnvironmentObject var currOAuthViewData:OAuthViewData
    
    @StateObject private var oauth2Data = OAuth2Data()
    
    @StateObject private var userMeData = UserMeData()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Version: OAuth 2.0")
                    Button("Go to OAuth 1.1a") {
                        currOAuthViewData.OAuthVersion = 1
                    }
                    .padding(.top, 2)
                }
                .padding(.top, 15)
                .padding(.leading, 20)
                Spacer()
            }
            .padding(.bottom, 80)

            Button(action: {
                oauth2Data.doSignIn()
            }, label: {
                Image("sign-in-with-twitter-gray")
                    .resizable()
                    .frame(width: 240, height: 40)
            })
            .padding(.bottom, 50)
            
            if (!oauth2Data.responseTime.isEmpty &&
                !oauth2Data.token.isEmpty) {
                Button("Get UserMe Info") {
                    userMeData.doUserMe(token: oauth2Data.token)
                }
                .padding(.bottom, 50)
                .alert("UserMe Response", isPresented:$userMeData.isShowAlert, actions: {
                    Button("OK") { }
                }, message: {
                    if (!userMeData.userMeInfo.isEmpty) {
                        Text(userMeData.userMeInfo)
                    } else {
                        Text(userMeData.errorDesc)
                    }
                    
                })
            }
            
            OAuth2ResponseText(responseData: oauth2Data)
            
            Spacer()
        }
    }
}

struct OAuth2ResponseText: View
{
    @StateObject var responseData: OAuth2Data
    
    func getShowTest() ->String
    {
        if (responseData.responseTime.isEmpty) {
            return "output..."
        } else {
            let timeText = "\(responseData.responseTime)"
            if (responseData.errorDesc.isEmpty) {
                let tokenText = "token=\(responseData.token)"
                
                let showText = "Twitter SignIn Success!\n\(timeText)\n\n\(tokenText)"
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


struct OAuth2View_Previews: PreviewProvider {
    static var previews: some View {
        OAuth2View()
    }
}
