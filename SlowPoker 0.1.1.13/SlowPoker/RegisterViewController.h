//
//  RegisterViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterDialog.h"

@class MFButton;

@interface RegisterViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,TwitterDialogDelegate,TwitterLoginDialogDelegate>{
    UIImageView *background;
    UITextField *emailAddress;
    UITextField *userName;
    UITextField *password;
    UITextField *retypePassword;
    
    UIImageView *emailBackground;
    UIImageView *userNameBackground;
    UIImageView *passwordBackground;
    UIImageView *retypepasswordBackground;
    
    MFButton *registerButton;
    MFButton *loginButton;
    UIActionSheet *switchUser;
    UISegmentedControl *segmentControl;
    
    UIButton *twitterButton;
    UIButton *facebookButton;
    UILabel *twitterFacebookInstructions;
    UILabel *buyGiftLabel;
    UIAlertView *validation;
}

@property (nonatomic,retain)UITextField *emailAddress;
@property (nonatomic,retain)UITextField *userName;
@property (nonatomic,retain)UITextField *password;
@property (nonatomic,retain)UITextField *retypePassword;

@property (nonatomic,retain)UIImageView *emailBackground;
@property (nonatomic,retain)UIImageView *userNameBackground;
@property (nonatomic,retain)UIImageView *passwordBackground;
@property (nonatomic,retain)UIImageView *retypepasswordBackground;
@property (nonatomic,retain)UIAlertView *validation;


@property(nonatomic,retain)MFButton *registerButton;
@property(nonatomic,retain)MFButton *loginButton;
@property(nonatomic,retain)UISegmentedControl *segmentControl;
@property(nonatomic,retain)UIButton *twitterButton;
@property(nonatomic,retain)UIButton *facebookButton;
@property(nonatomic,retain)UILabel *twitterFacebookInstructions;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@end

