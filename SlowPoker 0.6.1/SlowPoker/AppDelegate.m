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
#import "PlayerProfileViewController.h"
#import "AchievementEarnedView.h"
#import "UIWebViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;
@synthesize homeViewController;
@synthesize registerLoginViewController;
@synthesize tmpViewController;
@synthesize playerProfileViewController;
@synthesize achievementEarnedView;
@synthesize achievementsQueue;
@synthesize isQueueAnimating;
@synthesize uiWebViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"showAchievement" options:NSKeyValueObservingOptionOld context:nil];
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"addAchievement" options:NSKeyValueObservingOptionOld context:nil];
    
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"showStatCode" options:NSKeyValueObservingOptionOld context:nil];
    
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
    
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"isTableView", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    [DataManager sharedInstance].deviceTok = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[DataManager sharedInstance] registerForAPN];
}

-(void)pushToPlayersProfile:(NSString *)userID{
    if(!playerProfileViewController){
        self.playerProfileViewController = [[PlayerProfileViewController alloc] initWithNibName:nil bundle:nil];
    }
    playerProfileViewController.userID = userID;
    playerProfileViewController.needsReload = YES;
    [self.navController pushViewController:playerProfileViewController animated:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"showAchievement"]){
        UIAlertView *achievementAlert;
        if([@"YES" isEqualToString:[[DataManager sharedInstance].showAchievement valueForKey:@"canBuy"]]){
            achievementAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"I'll earn it",@"Buy it now",nil];
            NSString *messageKey = [NSString stringWithFormat:@"achievement.%@.description",[[DataManager sharedInstance].showAchievement valueForKey:@"code"]];
            achievementAlert.message = NSLocalizedString(messageKey,nil);
            achievementAlert.message = [achievementAlert.message stringByAppendingFormat:@".\n\n Gotta have it now? Buy this card for %@ Pro Chips.",[[DataManager sharedInstance].showAchievement valueForKey:@"purchaseValue"]];
        }else{
            achievementAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            NSString *messageKey = [NSString stringWithFormat:@"achievement.%@.description",[[DataManager sharedInstance].showAchievement valueForKey:@"code"]];
            achievementAlert.message = NSLocalizedString(messageKey,nil);
        }
        NSString *titleKey = [NSString stringWithFormat:@"achievement.%@.title",[[DataManager sharedInstance].showAchievement valueForKey:@"code"]];
        achievementAlert.title = NSLocalizedString(titleKey,nil);
        

        
        [achievementAlert show];
    }else if([keyPath isEqualToString:@"addAchievement"]){
        if(!achievementsQueue){
             self.achievementsQueue = [[NSMutableArray alloc] init];
        }
        if(![[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"PROFILE"]){
            [achievementsQueue addObject:[DataManager sharedInstance].addAchievement];
            //NSLog(@"addAchievement:%@",[DataManager sharedInstance].addAchievement);
            [self processAchievementsQueue];
        }
        
        
        if([[DataManager sharedInstance] shouldIncrementPrimaryAchievement:[[DataManager sharedInstance].addAchievement valueForKey:@"category"]]){
            if([[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"PLATINUM"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"PLATINUM_BRACELET" category:@"PLATINUM"];
                if(![[gameAchievement valueForKey:@"code"] isEqualToString:[[DataManager sharedInstance].addAchievement valueForKey:@"code"]]){
                    [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                }
                
            }else if([[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"GOLD"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GOLD_BRACELET" category:@"GOLD"];
                if(![[gameAchievement valueForKey:@"code"] isEqualToString:[[DataManager sharedInstance].addAchievement valueForKey:@"code"]]){
                    [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                }
                
            }else if([[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"SILVER"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"SILVER_BRACELET" category:@"SILVER"];
                if(![[gameAchievement valueForKey:@"code"] isEqualToString:[[DataManager sharedInstance].addAchievement valueForKey:@"code"]]){
                    [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                }
                
            }else if([[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"BRONZE"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BRONZE_BRACELET" category:@"BRONZE"];
                if(![[gameAchievement valueForKey:@"code"] isEqualToString:[[DataManager sharedInstance].addAchievement valueForKey:@"code"]]){
                    [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                }
                
            }else if([[[DataManager sharedInstance].addAchievement valueForKey:@"category"] isEqualToString:@"BLACK"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BLACK_BRACELET" category:@"BLACK"];
                if(![[gameAchievement valueForKey:@"code"] isEqualToString:[[DataManager sharedInstance].addAchievement valueForKey:@"code"]]){
                    [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                }
                
            }
        }
        
        
        
    }else if([keyPath isEqualToString:@"showStatCode"]){
        NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",[DataManager sharedInstance].showStatCode];
        NSString *messageKey = [NSString stringWithFormat:@"profile.%@.description",[DataManager sharedInstance].showStatCode];
        UIAlertView *statAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(titleKey,nil) message:NSLocalizedString(messageKey,nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [statAlert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[DataManager sharedInstance] purchaseShowAchievementForPlayerProfile];
    }
}




-(void)processAchievementsQueue{
    while([achievementsQueue count] > 0 && !isQueueAnimating){
        [self showAchievement:[achievementsQueue objectAtIndex:0]];
    }
}

-(void)showAchievement:(NSMutableDictionary *)achievement{
    isQueueAnimating = YES;
    if(!achievementEarnedView){
        self.achievementEarnedView = [[AchievementEarnedView alloc] initWithFrame:CGRectMake(0, 460, 320, 80)];
        [self.window addSubview:achievementEarnedView];
    }
    [achievementEarnedView setAchievementData:achievement];
    achievementEarnedView.center = CGPointMake(160, 540);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAchievement)];
    achievementEarnedView.center = CGPointMake(160, 440);
    [UIView commitAnimations];
}

-(void)hideAchievement{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:7];
    [UIView setAnimationDidStopSelector:@selector(doneAnimating)];
    achievementEarnedView.center = CGPointMake(160, 540);
    [UIView commitAnimations];
}

-(void)doneAnimating{
    isQueueAnimating = NO;
    [achievementsQueue removeObjectAtIndex:0];
    [self processAchievementsQueue];
}

-(void)emailBug:(UIViewController *)viewController{
    self.tmpViewController = viewController;
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSString *viewMode = @"Table View";
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isTableView"] isEqualToString:@"YES"]){
        viewMode = @"Bet View";
    }
    
    
    // Set the subject of email
    [picker setSubject:[NSString stringWithFormat:@"Slow Poker Bug",[DataManager sharedInstance].myUserName]];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"	
    [picker setToRecipients:[NSArray arrayWithObjects:@"jamie.simpson@mobilefringe.com",nil]];
    NSError *error;
    if([DataManager sharedInstance].currentGame){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[DataManager sharedInstance].currentGame options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // Fill out the email body text
        NSString *emailBody = [NSString stringWithFormat:@"Issue:\n\n\n\nView Mode:%@\n\n\n\nGame State:\n%@",viewMode,jsonString];
        //NSLog(@"jsonString:%@",jsonString);
        
        // This is not an HTML formatted email
        [picker setMessageBody:emailBody isHTML:NO];
    }
    // Show email view	
    [tmpViewController presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    [tmpViewController dismissModalViewControllerAnimated:YES];
}



-(void)applicationSignificantTimeChange:(UIApplication *)application{
    [DataManager sharedInstance].isNewDay = YES;
}


-(void)goToHomViewController:(BOOL)animated{
    [self.navController pushViewController:homeViewController animated:animated];
}

-(void)goToWebViewControllerWithURL:(NSString *)url withTitle:(NSString *)title{
    if(!uiWebViewController){
        self.uiWebViewController = [[UIWebViewController alloc] initWithNibName:nil bundle:nil];
    }
    uiWebViewController.title = title;
    [uiWebViewController loadURL:url];
    [self.navController pushViewController:uiWebViewController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DataManager sharedInstance] sendAchievements:YES];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs valueForKey:@"userName"] && [prefs valueForKey:@"password"] ){
        NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
        [registerDict setValue:[prefs valueForKey:@"userName"] forKey:@"login"];
        //[registerDict setValue:emailAddress.text forKey:@"login"];
        [registerDict setValue:[prefs valueForKey:@"password"] forKey:@"password"];
        NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:registerDict];
        //NSLog(@"sucess:%@",[results objectForKey:@"success"]);
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            
        }else{
            [navController popToRootViewControllerAnimated:YES];
        }
    }
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
