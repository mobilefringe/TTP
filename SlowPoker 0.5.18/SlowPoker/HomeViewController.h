//
//  HomeViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFButton;
@class GamesViewController;
@class HandEvaluatorViewController;
@class MyFriendsViewController;
@class SettingsViewController;
@class ProChipsViewController;

@interface HomeViewController : UIViewController{
    MFButton *gamesButton;
    MFButton *proPointsButton;
    MFButton *myFriendsButton;
    MFButton *statsButton;
    MFButton *leaderBoardsButton;
    MFButton *profileButton;
    MFButton *twitterButton;
    MFButton *facebookButton;
    GamesViewController *gamesViewController;
    HandEvaluatorViewController *handEvaluatorViewController;
    MyFriendsViewController *myFriendsViewController;
    SettingsViewController *settingsViewController;
    ProChipsViewController *proChipsViewController;
    
    UILabel *userLabel;
}

@property(nonatomic,retain)MFButton *gamesButton;
@property(nonatomic,retain)MFButton *proPointsButton;
@property(nonatomic,retain)MFButton *statsButton;
@property(nonatomic,retain)MFButton *leaderBoardsButton;
@property(nonatomic,retain)MFButton *profileButton;
@property(nonatomic,retain)MFButton *twitterButton;
@property(nonatomic,retain)MFButton *facebookButton;
@property(nonatomic,retain)GamesViewController *gamesViewController;
@property(nonatomic,retain)HandEvaluatorViewController *handEvaluatorViewController;
@property(nonatomic,retain)MyFriendsViewController *myFriendsViewController;
@property(nonatomic,retain)SettingsViewController *settingsViewController;
@property(nonatomic,retain)ProChipsViewController *proChipsViewController;
@property(nonatomic,retain)UILabel *userLabel;

@end
