//
//  ViewController.m
//  SignInSample
//
//  Created by jammy-huang on 2022/11/2.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
        
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *OAuth2VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"OAuth2View"];
    OAuth2VC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:OAuth2VC animated:false completion:nil];
}

@end
