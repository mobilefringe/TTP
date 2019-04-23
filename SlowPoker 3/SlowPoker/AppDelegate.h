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

@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMailComposeViewControllerDelegate>{
    UINavigationController *navController;
    HomeViewController *homeViewController;
    RegisterLoginViewController *registerLoginViewController;
    UIViewController *tmpViewController;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) HomeViewController *homeViewController;
@property (nonatomic, retain) RegisterLoginViewController *registerLoginViewController;
@property (nonatomic, retain) UIViewController *tmpViewController;

-(void)goToHomViewController:(BOOL)animated;
-(void)emailBug:(UIViewController *)viewController;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error; 


@end
