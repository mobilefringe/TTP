//
//  RegisterLoginViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class RegisterViewController;



@interface RegisterLoginViewController : UIViewController<UIActionSheetDelegate>{
    LoginViewController *loginViewController;
    RegisterViewController *registerViewController;
    

}

@property(nonatomic,retain)LoginViewController *loginViewController;
@property(nonatomic,retain)RegisterViewController *registerViewController;



@end
