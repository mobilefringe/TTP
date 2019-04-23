//
//  ThreadCell.m
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThreadCell.h"
#import "DataManager.h"
#import "Avatar.h"


@implementation ThreadCell

@synthesize msgText;
@synthesize imgName;
@synthesize dateText;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize cardThree;
@synthesize cardFour;
@synthesize cardFive;
@synthesize playerCardOne;
@synthesize playerCardTwo;
@synthesize showHand;
@synthesize userID;
@synthesize avatar;


@synthesize tipRightward = _tipRightward;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor =  [UIColor clearColor]; 
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    
  [super layoutSubviews];
    
    
    
  
 // NSLog(@"bounds: %@", NSStringFromCGRect( self.bounds));
 // NSLog(@"bounds content: %@", NSStringFromCGRect( self.contentView.bounds));
  
  CGFloat widthForText = self.bounds.size.width  - 85;
  CGSize size          = [ThreadCell calcTextHeight:self.msgText withinWidth:widthForText];
  UIImage *balloon     = [[UIImage imageNamed:self.imgName] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
  
    
  if (self.tipRightward) {
    
    balloon = [UIImage imageWithCGImage: balloon.CGImage scale:1.0 orientation:(UIImageOrientationUpMirrored)];
    balloon = [balloon stretchableImageWithLeftCapWidth:24 topCapHeight:15];
  }
  
  CGFloat xx;
    double xoffset;
  if (self.tipRightward) {
    xx = 45.0f;
      xoffset = 0;
  } else {
    xx = self.frame.size.width - size.width - 24 - 10-45 ;
      xoffset = 5;
  }
    
  UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(xx, 0.0+20, size.width + 35, size.height + 10)];
  if(showHand){
      newImage.frame = CGRectMake(xx, 0.0+20, size.width + 35, size.height + 70);
      
  }
  UIView *newView       = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    newView.backgroundColor = [UIColor clearColor];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 18)];
    dateLabel.numberOfLines   = 1;
    if(self.tipRightward){
        dateLabel.textAlignment = UITextAlignmentLeft;
    }else{
        dateLabel.textAlignment = UITextAlignmentRight;
    }
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.text            =dateText;
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font            = [UIFont boldSystemFontOfSize:12];
    dateLabel.tag             = 41;
    //[dateLabel sizeToFit];
    
  [newView addSubview:dateLabel];  
  
  UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + xx -xoffset, 2+20, size.width, size.height)];
  txtLabel.lineBreakMode   = UILineBreakModeWordWrap;
  txtLabel.numberOfLines   = 0;
  txtLabel.text            = msgText;
  txtLabel.textColor = [UIColor blackColor];
  txtLabel.backgroundColor = [UIColor clearColor];
  txtLabel.font            = [UIFont systemFontOfSize:14.0];
  txtLabel.tag             = 42;
  [txtLabel sizeToFit];
  
  [newImage setImage:balloon];
    
  [newView addSubview:newImage];

  [self setBackgroundView:newView];

  [[self.contentView viewWithTag:42] removeFromSuperview];
  
  [self.contentView addSubview:txtLabel];
    
    
    
    
    
    
    
    int xOffset = 43;
    int yOffSet = size.height+22;
    int xStart = 19+40;
   
        
    
    
    
    self.playerCardOne = [[UIImageView alloc] initWithFrame:CGRectMake(xStart, yOffSet, 40, 55)];
    playerCardOne.tag = 61;
    [[self.contentView viewWithTag:61] removeFromSuperview];
    [self.contentView addSubview:playerCardOne];
    
    self.playerCardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(xStart+xOffset, yOffSet, 40, 55)];
    playerCardTwo.tag = 62;
    [[self.contentView viewWithTag:62] removeFromSuperview];
    [self.contentView addSubview:playerCardTwo];
    
    int yoffset4 = 85;
    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(yoffset4+30*2, yOffSet+16, 40*0.7, 55*0.7)];
    cardOne.tag = 63;
    cardOne.alpha = 0.8;
    [[self.contentView viewWithTag:63] removeFromSuperview];
    [self.contentView addSubview:cardOne];
    
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(yoffset4+30*3, yOffSet+16, 40*0.7, 55*0.7)];
    cardTwo.tag = 64;
    cardTwo.alpha = 0.8;
    [[self.contentView viewWithTag:64] removeFromSuperview];
    [self.contentView addSubview:cardTwo];
    
    self.cardThree = [[UIImageView alloc] initWithFrame:CGRectMake(yoffset4+30*4, yOffSet+16, 40*0.7, 55*0.7)];
    cardThree.tag = 65;
    cardThree.alpha = 0.8;
    [[self.contentView viewWithTag:65] removeFromSuperview];
    [self.contentView addSubview:cardThree];
    
    self.cardFour = [[UIImageView alloc] initWithFrame:CGRectMake(yoffset4+30*5, yOffSet+16, 40*0.7, 55*0.7)];
    cardFour.tag = 66;
    cardFour.alpha = 0.8;
    [[self.contentView viewWithTag:66] removeFromSuperview];
    [self.contentView addSubview:cardFour];
    
    self.cardFive = [[UIImageView alloc] initWithFrame:CGRectMake(yoffset4+30*6, yOffSet+16, 40*0.7, 55*0.7)];
    cardFive.alpha = 0.8;
    cardFive.tag = 67;
    [[self.contentView viewWithTag:67] removeFromSuperview];
    [self.contentView addSubview:cardFive];
    
    if(showHand){
        [self.playerCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[showHand valueForKey:@"cardOne"]]];
        [self.playerCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[showHand valueForKey:@"cardTwo"]]];
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[[showHand valueForKey:@"communityCards"] objectAtIndex:0]]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[[showHand valueForKey:@"communityCards"] objectAtIndex:1]]];
        [self.cardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:[[showHand valueForKey:@"communityCards"] objectAtIndex:2]]];
        [self.cardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:[[showHand valueForKey:@"communityCards"] objectAtIndex:3]]];
        [self.cardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:[[showHand valueForKey:@"communityCards"] objectAtIndex:4]]];
    }
    
    int yOffset2 = 0;
    int xOffset2 = 3;
    if(showHand){
        yOffset2 = 59;
    }
    if(!self.tipRightward){
        xOffset2 = 277;
    }
    self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(xOffset2, size.height-12+yOffset2, 40, 40)];
    avatar.button.enabled = YES;
    avatar.userInteractionEnabled = YES;
    avatar.radius = 50;
    avatar.tag = 123;
    [[self.contentView viewWithTag:123] removeFromSuperview];
    [avatar loadAvatar:userID];
    [self.contentView addSubview:avatar];

  
}

+ (CGSize)calcTextHeight:(NSString *)str {
  return [self calcTextHeight:str withinWidth:260.0];
}

+ (CGSize) calcTextHeight:(NSString *)str withinWidth:(CGFloat)width {
    
  CGSize textSize = {width, 20000.0};
  CGSize size     = [str sizeWithFont:[UIFont systemFontOfSize:14.0] 
                    constrainedToSize:textSize];
  
  return size;
}



@end
