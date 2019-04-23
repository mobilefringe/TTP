//
//  PlayerProfileViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Avatar;
@class PlayerStatsViewController;
@class AchievementsViewController;

@interface PlayerProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *userID;
    UIActivityIndicatorView *activityIndicatorView;
    Avatar *avatar;
    UILabel *userNameLabel;
    UIButton *changeAvatarButton;
    UIActionSheet *imagePickerType;
    UILabel *tapToUpload;
    UITableView *_tableView;
    PlayerStatsViewController *playerStatsViewController;
    AchievementsViewController *achievementsViewController;
    BOOL needsReload;
    UILabel *footerView1;
    UILabel *footerView2;
    UILabel *footerView3;
    UIBarButtonItem *favoritesButton;
	UIImage *favoritesImageSelected;
	UIImage *favoritesImageUnSelected;
	UIImageView *favouritesMessageImage;
	UILabel *favouritesMessageLabel;
}

@property(nonatomic,retain)NSString *userID;
@property (nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UIButton *changeAvatarButton;
@property (nonatomic,retain)UILabel *tapToUpload;
@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)PlayerStatsViewController *playerStatsViewController;
@property(nonatomic,retain)AchievementsViewController *achievementsViewController;
@property(readwrite)BOOL needsReload;
@property(nonatomic,retain)UILabel *footerView1;
@property(nonatomic,retain)UILabel *footerView2;
@property(nonatomic,retain)UILabel *footerView3;
@property (nonatomic,retain)UIBarButtonItem *favoritesButton;
@property (nonatomic,retain)UIImage *favoritesImageSelected;
@property (nonatomic,retain)UIImage *favoritesImageUnSelected;


@end
