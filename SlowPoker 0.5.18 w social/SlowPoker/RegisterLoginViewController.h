//
//  RegisterLoginViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterDialog.h"

@class MFButton;

@interface RegisterLoginViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,TwitterDialogDelegate,TwitterLoginDialogDelegate>{
    UITextField *emailAddress;
    UITextField *userName;
    UITextField *password;
    MFButton *registerButton;
    MFButton *loginButton;
    UIActionSheet *switchUser;
    
    MFButton *facebookButton;
    MFButton *twitterButton;
    
    UIAlertView *emailAlert;
}

@property (nonatomic,retain)UITextField *emailAddress;
@property (nonatomic,retain)UITextField *userName;
@property (nonatomic,retain)UITextField *password;
@property(nonatomic,retain)MFButton *registerButton;
@property(nonatomic,retain)MFButton *loginButton;
@property(nonatomic,retain)MFButton *facebookButton;
@property(nonatomic,retain)MFButton *twitterButton;

-(void)getTwitterUser;
-(void)facebookLogin;
-(void)getFacebookUser;
-(void)askForEmail:(NSString *)msg;

@end
