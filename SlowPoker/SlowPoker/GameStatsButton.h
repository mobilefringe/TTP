//
//  GameStatsButton.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStatsButton : UIView{
    UIImageView *buttonImage;
    UIImage *regularImage;
    UIImage *selectedImage;
    UILabel *label;
    UIButton *button;
}

@property(nonatomic,retain)UIImageView *buttonImage;
@property(nonatomic,retain)UIImage *regularImage;
@property(nonatomic,retain)UIImage *selectedImage;
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)UILabel *label;

-(void)selectButton:(BOOL)animated;
-(void)unselectButton:(BOOL)animated;

@end
