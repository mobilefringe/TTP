//
//  CardView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-08-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView{
    UIImageView *frontImageView;
    UIImageView *backImageView;
    
}

@property(nonatomic,retain) UIImageView *frontImageView;
@property(nonatomic,retain) UIImageView *backImageView;


-(void)loadCard:(NSString *)cardValue animated:(BOOL)animated delay:(double)delay;

@end
