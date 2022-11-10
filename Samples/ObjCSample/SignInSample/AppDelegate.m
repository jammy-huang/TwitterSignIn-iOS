//
//  AppDelegate.m
//  SignInSample
//
//  Created by jammy-huang on 2022/11/2.
//

#import "AppDelegate.h"

#import <TwitterSignInV1/TwitterSignInV1-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [TwitterSignIn.sharedInstance handleUrl:url];
    
    return YES;
}


@end
