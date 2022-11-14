//
//  OAuth1ViewController.m
//  SignInSample
//
//  Created by jammy-huang on 2022/11/2.
//

#import "OAuth1ViewController.h"

#import <TwitterSignInV1/TwitterSignInV1-Swift.h>

@implementation OAuth1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TwitterSignIn.sharedInstance.consumerKey = @"your value";
    TwitterSignIn.sharedInstance.consumerSecret = @"your value";
    TwitterSignIn.sharedInstance.callbackUrl = @"your value";
    
//    TwitterSignIn.sharedInstance.appAuthEnable = true;
}


- (IBAction)backToOAuth2:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}



- (IBAction)onSignInTwitter:(id)sender {
    
    _outputText.text = @"output...";
    
    [TwitterSignIn.sharedInstance signIn:^(TwitterUser* user, NSError* error) {
        
        NSString* dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterFullStyle];
        
        //SignIn failed
        if (error != nil)
        {
            NSString* errorText = [NSString stringWithFormat:@"error=%@", error.localizedDescription];
            NSString* showText =  [NSString stringWithFormat:@"Twitter SignIn Failed!\n%@\n\n%@", dateString, errorText];
            NSLog(@"[Simple] %@", showText);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_outputText.text = showText;
            });
            return;
        }
        
        //SignIn Success
        NSString* tokenText = [NSString stringWithFormat:@"token=%@", user.token];
        NSString* secretText = [NSString stringWithFormat:@"secret=%@", user.secret];
        NSString* userIdText = [NSString stringWithFormat:@"userId=%@", user.userId];
        NSString* userNameText = [NSString stringWithFormat:@"userName=%@", user.userName];
        NSString* showText = [NSString stringWithFormat:@"Twitter SignIn Success!\n%@\n\n%@\n%@\n%@\n%@", dateString, tokenText, secretText, userIdText, userNameText];
        NSLog(@"[Simple] %@", showText);
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_outputText.text = showText;
        });
        
    }];
    
}



@end
