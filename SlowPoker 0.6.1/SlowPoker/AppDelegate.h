//
//  AppDelegate.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class HomeViewController;
@class RegisterLoginViewController;
@class PlayerProfileViewController;
@class AchievementEarnedView;
@class UIWebViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMailComposeViewControllerDelegate>{
    UINavigationController *navController;
    HomeViewController *homeViewController;
    RegisterLoginViewController *registerLoginViewController;
    UIViewController *tmpViewController;
    PlayerProfileViewController *playerProfileViewController;
    AchievementEarnedView *achievementEarnedView;
    NSMutableArray *achievementsQueue;
    BOOL isQueueAnimating;
    UIWebViewController *uiWebViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) HomeViewController *homeViewController;
@property (nonatomic, retain) RegisterLoginViewController *registerLoginViewController;
@property (nonatomic, retain) UIViewController *tmpViewController;
@property (nonatomic, retain) PlayerProfileViewController *playerProfileViewController;
@property (nonatomic, retain) AchievementEarnedView *achievementEarnedView;
@property (nonatomic, retain) NSMutableArray *achievementsQueue;
@property (nonatomic, retain) UIWebViewController *uiWebViewController;
@property (readwrite)BOOL isQueueAnimating;

-(void)goToHomViewController:(BOOL)animated;
-(void)emailBug:(UIViewController *)viewController;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error; 
-(void)pushToPlayersProfile:(NSString *)userID;
-(void)processAchievementsQueue;
-(void)showAchievement:(NSMutableDictionary *)achievement;
-(void)goToWebViewControllerWithURL:(NSString *)url withTitle:(NSString *)title;

@end
