//
//  AppDelegate.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "DataManager.h"
#import "RegisterLoginViewController.h"
#import "APIDataManager.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;
@synthesize homeViewController;
@synthesize registerLoginViewController;
@synthesize tmpViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    self.registerLoginViewController = [[RegisterLoginViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:registerLoginViewController];
    self.navController.navigationBar.tintColor = [UIColor blackColor];
    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs valueForKey:@"userName"] && [prefs valueForKey:@"password"] ){
        NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
        [registerDict setValue:[prefs valueForKey:@"userName"] forKey:@"login"];
        //[registerDict setValue:emailAddress.text forKey:@"login"];
        [registerDict setValue:[prefs valueForKey:@"password"] forKey:@"password"];
        NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:registerDict];
        //NSLog(@"sucess:%@",[results objectForKey:@"success"]);
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            [self goToHomViewController:NO];
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    [DataManager sharedInstance].deviceTok = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[DataManager sharedInstance] registerForAPN];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
}

-(void)emailBug:(UIViewController *)viewController{
    self.tmpViewController = viewController;
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:[NSString stringWithFormat:@"%@ is reporting a bug",[DataManager sharedInstance].myUserName]];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"	
    [picker setToRecipients:[NSArray arrayWithObjects:@"jamie.simpson@mobilefringe.com",nil]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[DataManager sharedInstance].currentGame options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"Issue:\n\n\n\nGame State:\n%@",jsonString];
    NSLog(@"jsonString:%@",jsonString);
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];
    
    // Show email view	
    [tmpViewController presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    [tmpViewController dismissModalViewControllerAnimated:YES];
}






-(void)goToHomViewController:(BOOL)animated{
    [self.navController pushViewController:homeViewController animated:animated];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
