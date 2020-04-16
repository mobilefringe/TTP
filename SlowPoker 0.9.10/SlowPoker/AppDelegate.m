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
#import "NavBarView.h"
#import "StoreViewControllerViewController.h"
#import "StoreFront.h"
#import "GiftSelectionView.h"
#import "BuyGamePopUp.h"
#import "OAuth.h"
#import "OAuth+DEExtensions.h"
#import "OAuthConsumerCredentials.h"
#import "Settings.h"
#import "UpdatingPopUp.h"
#import "SocialManager.h"
#import "TurnsViewController.h"
#import "GamesViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "GamesViewController.h"
#import "GamesViewController.h"
#import <UserNotifications/UserNotifications.h>


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
@synthesize navBar;
@synthesize storeViewControllerViewController;
@synthesize giftSelectionView;
@synthesize buyGamePopUp;
@synthesize facebook;
@synthesize twitter;
@synthesize updatingPopUp;
@synthesize gamesViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:YES];

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"showAchievement" options:NSKeyValueObservingOptionOld context:nil];
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"addAchievement" options:NSKeyValueObservingOptionOld context:nil];
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"showStatCode" options:NSKeyValueObservingOptionOld context:nil];
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"giftUserID" options:NSKeyValueObservingOptionOld context:nil];
    [[StoreFront sharedStore] addObserver:self forKeyPath:@"notEnoughProChips" options:NSKeyValueObservingOptionOld context:nil];
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"isUpdatingGame" options:NSKeyValueObservingOptionOld context:nil];
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }else{
            NSLog(@"error notification %@", error);
        }
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    self.registerLoginViewController = [[RegisterLoginViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:registerLoginViewController];
    self.navController.navigationBar.tintColor = [UIColor blackColor];
    self.gamesViewController = [[GamesViewController alloc] initWithNibName:nil bundle:nil];

    self.navBar = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width , 45)];
    [navBar.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
        
    self.storeViewControllerViewController = [[StoreViewControllerViewController alloc] initWithNibName:nil bundle:nil];
    [storeViewControllerViewController closeStore:NO];
    
    [navController.navigationBar addSubview:self.navBar];
    
    self.giftSelectionView = [[GiftSelectionView alloc] initWithFrame:CGRectMake(5, 20, 310, 350) delegate:self];
    [navController.view addSubview:giftSelectionView];

    [giftSelectionView hide];
    
    self.buyGamePopUp = [[BuyGamePopUp alloc] initWithFrame:CGRectMake((self.window.bounds.size.width-310)/2, (self.window.bounds.size.height-350)/2, 310, 350) delegate:self];
    [navController.view addSubview:buyGamePopUp];
    [buyGamePopUp hide];
    
    [navController.view addSubview:storeViewControllerViewController.view];
    
    self.updatingPopUp = [[UpdatingPopUp alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [navController.view addSubview:updatingPopUp];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [[StoreFront sharedStore] loadProducts];
    [[Settings sharedInstance] loadRemoteSettings];

    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"isTableView", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

    return YES;
}

- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    if (notificationSettings.types != UIUserNotificationTypeNone){
        [application registerForRemoteNotifications];
    }
    else{
        
        
    }
}

- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    [DataManager sharedInstance].deviceTok = [self stringFromDeviceToken:deviceToken];
        NSLog(@"deviceToken : %@", [DataManager sharedInstance].deviceTok);
    [[DataManager sharedInstance] registerForAPN];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
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
        
        if([@"YES" isEqualToString:[[DataManager sharedInstance].showAchievement valueForKey:@"canBuy"]] && [[[DataManager sharedInstance].playerProfile valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            achievementAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"I'll earn it",@"Buy it now",nil];
            
            NSString *messageKey = [NSString stringWithFormat:@"achievement.%@.description",[[DataManager sharedInstance].showAchievement valueForKey:@"code"]];
            achievementAlert.message = NSLocalizedString(messageKey,nil);
            achievementAlert.message = [achievementAlert.message stringByAppendingFormat:@".\n\n Gotta have it now? Buy this achievement for %@ Pro Chips.",[[DataManager sharedInstance].showAchievement valueForKey:@"purchaseValue"]];
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
        
    }else if([keyPath isEqualToString:@"giftUserID"]){
        
        [giftSelectionView show];    
    }else if([keyPath isEqualToString:@"notEnoughProChips"]){
        
        [storeViewControllerViewController showStoreNotEnoughChips];    
    }else if([keyPath isEqualToString:@"isUpdatingGame"]){
        
        if([DataManager sharedInstance].isUpdatingGame){
            [updatingPopUp showWithMessage:@"Posting move"];
        }else{
            [updatingPopUp hide];
        }
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == achievementAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] purchaseShowAchievementForPlayerProfile];
        }
    }else if (alertView == emailAlert)
    {
        NSMutableDictionary *emailDict = [[NSMutableDictionary alloc] init];
        [emailDict setValue: [alertView textFieldAtIndex:0].text forKey:@"email"];
        [emailDict setValue: [DataManager sharedInstance].myUserID forKey:@"userID"];
        [emailDict setValue:twitter.user_id forKey:@"twitter_id"];
        [emailDict setValue:twitter.screen_name forKey:@"userName"];
        NSMutableDictionary *results = [[DataManager sharedInstance] registerTwitterPlayer:emailDict];
        
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:twitter.user_id forKey:@"twitter_id"];
            [defaults synchronize];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        }
        else
        {
            [self askForEmail:[results objectForKey:@"error"]];
        }
    }

}

-(void)pushToGameDetails:(NSString *)gameID{
    [(GamesViewController *)self.navController.visibleViewController loadGame:gameID];
}




-(void)processAchievementsQueue{
    while([achievementsQueue count] > 0 && !isQueueAnimating){
        [self performSelectorOnMainThread:@selector(showAchievement:) 
                               withObject:[achievementsQueue objectAtIndex:0] waitUntilDone:YES];
    }
}

-(void)showAchievement:(NSMutableDictionary *)achievement{
    isQueueAnimating = YES;
    if(!achievementEarnedView){
        self.achievementEarnedView = [[AchievementEarnedView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, UIScreen.mainScreen.bounds.size.width, 80)];
        [self.window addSubview:achievementEarnedView];
    }
    [achievementEarnedView setAchievementData:achievement];
    achievementEarnedView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height+80);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAchievement)];
    achievementEarnedView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-40);
    [UIView commitAnimations];
}

-(void)hideAchievement{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:4];
    [UIView setAnimationDidStopSelector:@selector(doneAnimating)];
    achievementEarnedView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height+80);
    [UIView commitAnimations];
}

-(void)doneAnimating{
    isQueueAnimating = NO;
    if([achievementsQueue count] > 0){
        [achievementsQueue removeObjectAtIndex:0];
    }
    [self processAchievementsQueue];
}

-(void)emailBug:(UIViewController *)viewController{
    self.tmpViewController = viewController;
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        NSString *viewMode = @"Table View";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isTableView"] isEqualToString:@"YES"]){
            viewMode = @"Bet View";
        }
        
        
        // Set the subject of email
        [picker setSubject:[NSString stringWithFormat:@"TTP Feedback",[DataManager sharedInstance].myUserName]];
        
        // Add email addresses
        // Notice three sections: "to" "cc" and "bcc"
        [picker setToRecipients:[NSArray arrayWithObjects:@"feedback@texasturnpoker.com",nil]];
        /*
        NSError *error;
        if([DataManager sharedInstance].currentGame){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[DataManager sharedInstance].currentGame options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            // Fill out the email body text
            NSString *emailBody = [NSString stringWithFormat:@"Issue:\n\n\n\nView Mode:%@\n\n\n\nGame State:\n%@",viewMode,jsonString];
            //NSLog(@"jsonString:%@",jsonString);
            
            // This is not an HTML formatted email
            [picker setMessageBody:emailBody isHTML:NO];
        }*/
        // Show email view
        [tmpViewController presentViewController:picker animated:YES completion:nil];
    }
}

-(void)emailLink:(NSString *)link{
    
    
}

-(void)updateHeaderWithTitle:(NSString *)title{
    [navBar updateHeaderWithTitle:title showLeft:YES showRight:YES];
    
}

-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight{
    [navBar updateHeaderWithTitle:title showLeft:showLeft showRight:showRight];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    [tmpViewController dismissModalViewControllerAnimated:YES];
}



-(void)applicationSignificantTimeChange:(UIApplication *)application{
    [DataManager sharedInstance].isNewDay = YES;
}

-(void)pressBackButton{
    [self.navController popViewControllerAnimated:YES];
}


-(void)goToHomViewController:(BOOL)animated{
    BOOL isHomePushed = NO;
    for (UIViewController *viewController in self.navController.viewControllers) {
        if(viewController == homeViewController){
            isHomePushed = YES;
        }
    }
        
    if(!isHomePushed){
        [self.navController pushViewController:homeViewController animated:animated];
    }
}

-(void)goToWebViewControllerWithURL:(NSString *)url withTitle:(NSString *)title{
    if(!uiWebViewController){
        self.uiWebViewController = [[UIWebViewController alloc] initWithNibName:nil bundle:nil];
    }
    uiWebViewController.title = title;
    [uiWebViewController loadURL:url];
    [self.navController pushViewController:uiWebViewController animated:YES];
}

-(void)showStore{
    [storeViewControllerViewController showStore];
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
    [[DataManager sharedInstance].avatars removeAllObjects];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
    if([navController.visibleViewController isKindOfClass:[TurnsViewController class]]){
        [(TurnsViewController *)navController.visibleViewController loadGame];
    }else if([navController.visibleViewController isKindOfClass:[GamesViewController class]]){
        [(GamesViewController *)navController.visibleViewController loadGames];
        //[(GamesViewController *)navController.topViewController loadGames];
    }
    
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    /*
    NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
    if([prefs1 valueForKey:@"userName"] && [prefs1 valueForKey:@"password"]){
        [updatingPopUp showWithMessage:[NSString stringWithFormat:@"Logging in %@",[prefs1 valueForKey:@"userName"]]];
    }
    dispatch_async(kBgQueue, ^{
        [[StoreFront sharedStore] loadProducts];
        [[Settings sharedInstance] loadRemoteSettings];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if([prefs valueForKey:@"userName"] && [prefs valueForKey:@"password"] ){
            NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
            [registerDict setValue:[prefs valueForKey:@"userName"] forKey:@"login"];
            //[registerDict setValue:emailAddress.text forKey:@"login"];
            [registerDict setValue:[prefs valueForKey:@"password"] forKey:@"password"];
            NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:registerDict];
            [self performSelectorOnMainThread:@selector(finishAutoLogin:) 
                                   withObject:results waitUntilDone:YES];
        }
    });
    */
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    BOOL isAsnych = YES;
    if([navController.visibleViewController isKindOfClass:[RegisterLoginViewController class]]){
        isAsnych = NO;
    }else if([navController.visibleViewController isKindOfClass:[RegisterViewController class]]){
        isAsnych = NO;
    }else if([navController.visibleViewController isKindOfClass:[LoginViewController class]]){
        isAsnych = NO;        
    }
    [self autoLogin:isAsnych];
    
    
    
    
    
   // [updatingPopUp showWithMessage:[NSString stringWithFormat:@"Logging in %@",[prefs1 valueForKey:@"userName"]]];
    
        /*
     
     
     
     
    
    
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
    }else if (facebook.accessToken != nil)
    {
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
        [loginDict setValue:facebook.accessToken forKey:@"token"];
        NSMutableDictionary *results = [[DataManager sharedInstance] loginFacebookPlayer:loginDict];
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            [self goToHomViewController:NO];
        }
    }else if([OAuth isTwitterAuthorized] && [prefs objectForKey:@"twitter_id"])
    {
        twitter = [[OAuth alloc] initWithConsumerKey:kDEConsumerKey andConsumerSecret:kDEConsumerSecret];
        [twitter loadOAuthContext];
        
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
        [loginDict setValue:[prefs objectForKey:@"twitter_id"] forKey:@"twitter_id"];
        NSMutableDictionary *results = [[DataManager sharedInstance] loginTwitterPlayer:loginDict];
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            [self goToHomViewController:NO];
        }
    }*/

    /*
    [self performSelectorOnMainThread:@selector(finishAutoLogin:) 
                           withObject:results waitUntilDone:YES];*/

    
    
}



-(void)autoLogin:(BOOL)asynchronous{
    
    
    if(asynchronous){
        dispatch_async(kBgQueue, ^{
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            if ([prefs objectForKey:@"FBAccessTokenKey"] 
                && [prefs objectForKey:@"FBExpirationDateKey"]) {
                facebook.accessToken = [prefs objectForKey:@"FBAccessTokenKey"];
                facebook.expirationDate = [prefs objectForKey:@"FBExpirationDateKey"];
                //NSLog(@"facebook.expirationDate:%@",facebook.expirationDate);
            }
            
            
            
            NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
            
            [loginDict setValue:[prefs valueForKey:@"email"] forKey:@"email"];
            [loginDict setValue:[prefs valueForKey:@"password"] forKey:@"password"];
            [loginDict setValue:[prefs valueForKey:@"facebook_id"] forKey:@"facebook_id"];
            [loginDict setValue:[prefs valueForKey:@"twitter_id"] forKey:@"twitter_id"];
            //NSLog(@"loginDict:%@",loginDict);
            NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:loginDict];
            [self performSelectorOnMainThread:@selector(finishAutoLogin:) 
                                   withObject:results waitUntilDone:YES];
            
        });

    }else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([prefs objectForKey:@"FBAccessTokenKey"] 
            && [prefs objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [prefs objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [prefs objectForKey:@"FBExpirationDateKey"];
            //NSLog(@"facebook.expirationDate:%@",facebook.expirationDate);
        }
        
        
        
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
        
        [loginDict setValue:[prefs valueForKey:@"email"] forKey:@"email"];
        [loginDict setValue:[prefs valueForKey:@"password"] forKey:@"password"];
        [loginDict setValue:[prefs valueForKey:@"facebook_id"] forKey:@"facebook_id"];
        [loginDict setValue:[prefs valueForKey:@"twitter_id"] forKey:@"twitter_id"];
        //NSLog(@"loginDict:%@",loginDict);
        NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:loginDict];
        [self finishAutoLogin:results];
        
    }
    
}

-(void)finishAutoLogin:(NSMutableDictionary *)loginResults{
    [updatingPopUp hide];
    //NSLog(@"loginResults:%@",loginResults);
    if([@"1" isEqualToString:[loginResults objectForKey:@"success"]]){
        if([navController.visibleViewController isKindOfClass:[RegisterLoginViewController class]]){
            [self goToHomViewController:NO];
        }else if([navController.visibleViewController isKindOfClass:[RegisterViewController class]]){
            [self goToHomViewController:NO];
        }else if([navController.visibleViewController isKindOfClass:[LoginViewController class]]){
            [self goToHomViewController:NO];        
        }
    }else{
        if(facebook){
            [facebook logout];
        }
        [navController popToRootViewControllerAnimated:YES];
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

#pragma mark Facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"source application is %@ and url is %@", sourceApplication, url);
//    return [facebook handleOpenURL:url];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self getFacebookUser];
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    //NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)getFacebookUser
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    [registerDict setValue:appDel.facebook.accessToken forKey:@"token"];
    //NSLog(@"registerDict:%@",registerDict);
    NSMutableDictionary *results = [[DataManager sharedInstance] registerFacebookPlayer:registerDict];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:NO];
    }else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
    
}

-(void)getTwitterUser
{
    
    
    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    NSString *twitterID = [NSString stringWithFormat:@"%@",twitter.user_id];
    [registerDict setValue:twitterID forKey:@"twitter_id"];
    
    NSMutableDictionary *results = [[DataManager sharedInstance] doesTwitterPlayerExist:registerDict];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [self goToHomViewController:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:twitter.user_id forKey:@"twitter_id"];
        [defaults synchronize];
    }
    else if([@"2" isEqualToString:[results objectForKey:@"success"]]){
        [self askForEmail:@"Please Enter Your Email Address"];
    }
    else
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
}

-(void)askForEmail:(NSString *)msg
{
    emailAlert = [[UIAlertView alloc] initWithTitle:@"Email Address" message:msg delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    emailAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [emailAlert show];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[DataManager sharedInstance].avatars removeAllObjects];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Warning" 
                          message:@"Your device is low on memory..." 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
    //[alert show];
}

#pragma mark TwitterDialog Delegate Methods
- (void)twitterDidLogin
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel.twitter saveOAuthContext];
    [self getTwitterUser];
    
}

void uncaughtExceptionHandler(NSException *exception) {
}

@end
