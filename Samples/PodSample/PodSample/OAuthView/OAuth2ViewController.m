//
//  OAuth2ViewController.m
//  SignInSample
//
//  Created by jammy-huang on 2022/11/2.
//

#import "OAuth2ViewController.h"

#import <TwitterSignInV2/TwitterSignInV2-Swift.h>

@implementation OAuth2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //config***************************
    TwitterSignIn.sharedInstance.clientId = @"your value";
    TwitterSignIn.sharedInstance.callbackUrl = @"your value";
}

- (IBAction)gotoOAuth1:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *OAuth1VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"OAuth1View"];
    OAuth1VC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:OAuth1VC animated:false completion:nil];

}


- (IBAction)onSignInTwitter:(id)sender {
    
    _outputText.text = @"output...";
    
    [TwitterSignIn.sharedInstance signIn:^(TwitterUser *user, NSError *error) {
        
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
        NSString* showText = [NSString stringWithFormat:@"Twitter SignIn Success!\n%@\n\n%@", dateString, tokenText];
        NSLog(@"[Simple] %@", showText);
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_outputText.text = showText;
        });
        
        
    }];
    
}


@end
