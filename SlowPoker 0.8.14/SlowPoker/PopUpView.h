//
//  PopUpView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView{
    UIImageView *popupBackgroundImage;
}

@property(nonatomic,retain) UIImageView *popupBackgroundImage;
-(void)show;
-(void)hide;

@end
