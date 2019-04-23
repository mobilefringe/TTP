//
//  UpdatingPopUp.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatingPopUp : UIView{
    UILabel *message;
}

@property(nonatomic,retain)UILabel *message;
-(void)showWithMessage:(NSString *)messageText;
-(void)hide;

@end
