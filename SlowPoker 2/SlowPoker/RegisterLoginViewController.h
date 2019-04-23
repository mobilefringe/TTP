//
//  RegisterLoginViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFButton;

@interface RegisterLoginViewController : UIViewController<UIActionSheetDelegate>{
    UITextField *emailAddress;
    UITextField *userName;
    UITextField *password;
    MFButton *registerButton;
    MFButton *loginButton;
    UIActionSheet *switchUser;
}

@property (nonatomic,retain)UITextField *emailAddress;
@property (nonatomic,retain)UITextField *userName;
@property (nonatomic,retain)UITextField *password;
@property(nonatomic,retain)MFButton *registerButton;
@property(nonatomic,retain)MFButton *loginButton;

@end
