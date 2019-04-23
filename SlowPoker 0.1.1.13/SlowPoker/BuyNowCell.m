//
//  BuyNowCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuyNowCell.h"
#import "DataManager.h"
#import "Settings.h"

@implementation BuyNowCell

@synthesize buyNowImage;
@synthesize thankYouImage;
@synthesize chipImageView;
@synthesize proChip;
@synthesize chipLabel;
@synthesize proChipsTitle;
@synthesize buyDescription;
@synthesize lockedImage;
@synthesize unlockedImage;
@synthesize isLockedImageView;
@synthesize isLockedLabel;
@synthesize chipImageView2;
@synthesize flipView;
@synthesize cellData;
@synthesize isPurchasedBOOL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"buy_cell_background.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,backgroundImage.size.width/2 , backgroundImage.size.height/2)];
        backgroundImageView.image = backgroundImage;
        self.backgroundView = backgroundImageView;
        
        self.buyNowImage = [UIImage imageNamed:@"button_buy-now.png"];
        self.thankYouImage = [UIImage imageNamed:@"button_thank_you.png"];
        
        
        self.flipView = [[UIView alloc] initWithFrame:CGRectMake(-2,-2,buyNowImage.size.width/2,buyNowImage.size.height/2)];
        [self.contentView addSubview:flipView];
        
        self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,buyNowImage.size.width/2,buyNowImage.size.height/2)];
        chipImageView.image = buyNowImage;
        [flipView addSubview:chipImageView];
        
        self.chipImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,buyNowImage.size.width/2,buyNowImage.size.height/2)];
        chipImageView2.image = thankYouImage;
        [flipView addSubview:chipImageView2];
        chipImageView2.hidden = YES;
        
        
        
        
        self.proChip = [[UIImageView alloc] initWithFrame:CGRectMake(130, 15, 35, 35)];
        proChip.image = [UIImage imageNamed:@"pro_chip_back.png"];
        [self.contentView addSubview:proChip];
        
        self.chipLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 7.5, 30, 18)];
        chipLabel.backgroundColor = [UIColor clearColor];
        chipLabel.textColor = [UIColor blackColor];
        chipLabel.textAlignment = UITextAlignmentCenter;
        chipLabel.adjustsFontSizeToFitWidth = YES;
        chipLabel.minimumFontSize = 10;
        chipLabel.font = [UIFont boldSystemFontOfSize:14];
        [proChip addSubview:chipLabel];
        
        self.proChipsTitle = [[UILabel alloc] initWithFrame:CGRectMake(167, 19, 100, 30)];
        proChipsTitle.backgroundColor = [UIColor clearColor];
        proChipsTitle.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        proChipsTitle.textAlignment = UITextAlignmentLeft;
        proChipsTitle.adjustsFontSizeToFitWidth = YES;
        proChipsTitle.minimumFontSize = 10;
        proChipsTitle.text = @"Pro Chips";
        proChipsTitle.font = [UIFont  fontWithName:[Settings sharedInstance].header1Font size:24];
        [self.contentView addSubview:proChipsTitle];
        
        self.buyDescription = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 170, 60)];
        buyDescription.textColor = [UIColor whiteColor];
        buyDescription.backgroundColor = [UIColor clearColor];
        buyDescription.textAlignment = UITextAlignmentCenter;
        buyDescription.adjustsFontSizeToFitWidth = YES;
        buyDescription.minimumFontSize = 10;
        buyDescription.font = [UIFont  fontWithName:[Settings sharedInstance].header1Font size:12];
        buyDescription.numberOfLines = 4;
        [self.contentView addSubview:buyDescription];
        
        lockedImage = [UIImage imageNamed:@"lock.png"];
        unlockedImage = [UIImage imageNamed:@"unlock.png"];
        self.isLockedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 100, 15, 17)];
        [self.contentView addSubview:isLockedImageView];
        
        
        self.isLockedLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 102, 120, 14)];
        isLockedLabel.textColor = [UIColor darkGrayColor];
        isLockedLabel.backgroundColor = [UIColor clearColor];
        isLockedLabel.textAlignment = UITextAlignmentCenter;
        isLockedLabel.adjustsFontSizeToFitWidth = YES;
        isLockedLabel.minimumFontSize = 10;
        isLockedLabel.font = [UIFont boldSystemFontOfSize:10];
        isLockedLabel.numberOfLines = 1;
        [self.contentView addSubview:isLockedLabel];
    }
    return self;
}


-(void)setCellData:(NSMutableDictionary *)data isPurchased:(BOOL)isPurchased{
    self.cellData = data;
    isPurchasedBOOL = isPurchased;
    chipLabel.text = [data valueForKey:@"price"];
    [self updateData:NO];
    
    
}

-(void)updateData:(BOOL)animated{
    

    if(isPurchasedBOOL){
        chipImageView.image = lockedImage;
        isLockedImageView.image = unlockedImage;
        isLockedLabel.text = @"Pro Stats Unlocked!";
        buyDescription.text = [cellData valueForKey:@"description2"];
        proChip.image = [UIImage imageNamed:@"yellow_checkmark.png"];
        chipLabel.hidden = YES;
        isLockedImageView.frame = CGRectMake(140, 101, 15, 15);
        proChipsTitle.text = @"Pro Stats Active";
        if(animated){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipView
                                     cache:YES]; 
        }
        chipImageView2.hidden = NO;
        chipImageView.hidden = YES;
        if(animated){
            [UIView setAnimationDelegate:self];
            //[UIView setAnimationDidStopSelector:@selector(animateToTotal)];
            [UIView commitAnimations];
        }
    }else{
        isLockedImageView.frame = CGRectMake(150, 101, 13, 15);
        chipImageView.image = buyNowImage;
        chipLabel.hidden = NO;
        isLockedImageView.image = lockedImage;
        isLockedLabel.text = @"Pro Stats locked";
        proChip.image = [UIImage imageNamed:@"pro_chip_back.png"];
        buyDescription.text = [cellData valueForKey:@"description"];
        proChipsTitle.text = @"Pro Chips";
        if(animated){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipView
                                     cache:YES]; 
        }
        chipImageView2.hidden = YES;
        chipImageView.hidden = NO;
        if(animated){
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animateToTotal)];
            [UIView commitAnimations];
        }
    }

    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
