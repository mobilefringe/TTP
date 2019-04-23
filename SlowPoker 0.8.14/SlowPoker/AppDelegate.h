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
#import "FBConnect.h"
#import "OAuth.h"
#import "TwitterDialog.h"

@class HomeViewController;
@class RegisterLoginViewController;
@class PlayerProfileViewController;
@class AchievementEarnedView;
@class UIWebViewController;
@class NavBarView;
@class StoreViewControllerViewController;
@class GiftSelectionView;
@class BuyGamePopUp;
@class UpdatingPopUp;

@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMailComposeViewControllerDelegate,TwitterDialogDelegate,TwitterLoginDialogDelegate>{
    UINavigationController *navController;
    HomeViewController *homeViewController;
    RegisterLoginViewController *registerLoginViewController;
    UIViewController *tmpViewController;
    PlayerProfileViewController *playerProfileViewController;
    AchievementEarnedView *achievementEarnedView;
    NSMutableArray *achievementsQueue;
    BOOL isQueueAnimating;
    UIWebViewController *uiWebViewController;
    NavBarView *navBar;
    StoreViewControllerViewController *storeViewControllerViewController;
    GiftSelectionView *giftSelectionView;
    BuyGamePopUp *buyGamePopUp;
    Facebook *facebook;
    OAuth *twitter;
    UIAlertView *achievementAlert;
    UIAlertView *emailAlert;
    UpdatingPopUp *updatingPopUp;
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
@property (nonatomic, retain) StoreViewControllerViewController *storeViewControllerViewController;
@property (readwrite)BOOL isQueueAnimating;
@property(nonatomic,retain)NavBarView *navBar;
@property(nonatomic,retain)GiftSelectionView *giftSelectionView;
@property(nonatomic,retain)BuyGamePopUp *buyGamePopUp;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) OAuth *twitter;
@property (nonatomic, retain)UpdatingPopUp *updatingPopUp;

-(void)goToHomViewController:(BOOL)animated;
-(void)emailBug:(UIViewController *)viewController;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error; 
-(void)pushToPlayersProfile:(NSString *)userID;
-(void)processAchievementsQueue;
-(void)showAchievement:(NSMutableDictionary *)achievement;
-(void)goToWebViewControllerWithURL:(NSString *)url withTitle:(NSString *)title;
-(void)updateHeaderWithTitle:(NSString *)title;
-(void)showStore;
-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight;
-(void)getFacebookUser;
-(void)getTwitterUser;
-(void)autoLogin:(BOOL)asynchronous;


@end
