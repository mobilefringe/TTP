//
//  ThreadCell.h
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;

@interface ThreadCell : UITableViewCell {
  NSString *dateText;  
  NSString *msgText;
  NSString *imgName;
    NSString *userID;
    NSMutableDictionary *showHand;
    UIImageView *cardOne;
    UIImageView *cardTwo;
    UIImageView *cardThree;
    UIImageView *cardFour;
    UIImageView *cardFive;
    UIImageView *playerCardOne;
    UIImageView *playerCardTwo;
    Avatar *avatar;
}

@property (nonatomic, retain) NSString *dateText;
@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, retain) NSString *imgName;

@property (nonatomic, assign) BOOL tipRightward;
@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;
@property (nonatomic,retain)UIImageView *cardThree;
@property (nonatomic,retain)UIImageView *cardFour;
@property (nonatomic,retain)UIImageView *cardFive;
@property (nonatomic,retain)UIImageView *playerCardOne;
@property (nonatomic,retain)UIImageView *playerCardTwo;
@property (nonatomic,retain)NSString *userID;
@property (nonatomic,retain) NSMutableDictionary *showHand;
@property (nonatomic,retain) Avatar *avatar;

+ (CGSize)calcTextHeight:(NSString *)str;
+ (CGSize)calcTextHeight:(NSString *)str withinWidth:(CGFloat)width;
@end
