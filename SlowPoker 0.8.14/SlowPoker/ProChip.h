//
//  ProChip.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProChip : UIView{
    UIImageView *imageViewFront;
    UIImageView *imageViewBack;
    UIImage *front;
    UIImage *back;
    UILabel *amountLabel;
    UILabel *incrementLabel;
    UIButton *button;

    
}

@property(nonatomic,retain)UIImageView *imageViewFront;
@property(nonatomic,retain)UIImageView *imageViewBack;
@property(nonatomic,retain)UIImage *front;
@property(nonatomic,retain)UIImage *back;
@property(nonatomic,retain)UILabel *amountLabel;
@property(nonatomic,retain)UILabel *incrementLabel;
@property(nonatomic,retain)UIButton *button;

-(void)animateToIncrement;
-(void)pressProChip;

@end
