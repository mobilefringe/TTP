//
//  SocialManager.h
//  SlowPoker
//
//  Created by Fahad Muntaz on 12-05-08.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "AppDelegate.h"


@interface SocialManager : NSObject<FBRequestDelegate,FBDialogDelegate> {
    
    AppDelegate *appDelegate;
    NSMutableDictionary *fbookprofile;
    NSMutableDictionary *fbookfriends;
    NSMutableArray *fbookfriendsArray;

}
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) NSMutableDictionary *fbookprofile;
@property (nonatomic, retain) NSMutableDictionary *fbookfriends;
@property (nonatomic, retain)  NSMutableArray *fbookfriendsArray;

//Facebook methods
-(void)getFacebookProfile;
-(void)getFacebookFriends;
-(void)inviteFacebookFriends:(NSString *)facebookId;
-(void)shareFacebook:(NSMutableDictionary *)params;

//Twitter share
-(void)shareTwitter:(UIViewController*)usingController;
+ (SocialManager *)sharedInstance;

@end
