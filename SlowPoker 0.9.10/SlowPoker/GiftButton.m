//
//  GiftButton.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GiftButton.h"

@implementation GiftButton

@synthesize backgroundImageView;
@synthesize regularImage;
@synthesize selectedImage;

@synthesize giftButton;
@synthesize giftData;
@synthesize pressed;
@synthesize giftImage;
@synthesize selected;

- (id)initWithFrame:(CGRect)frame data:(NSMutableDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.frame = self.bounds;
        [self addSubview:backgroundImageView];
        
        self.regularImage = [UIImage imageNamed:@"gift_button_background_regular.png"];
        self.selectedImage = [UIImage imageNamed:@"gift_button_background_selected.png"];
        
        backgroundImageView.image = regularImage;
        
        self.giftData = data;
        

        [self addSubview:giftButton];
        
        self.giftImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 57, 55)];
        giftImage.image = [UIImage imageNamed:[data valueForKey:@"image"]];
        giftImage.userInteractionEnabled = YES;
        [self addSubview:giftImage];
        
        self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        giftButton.frame = self.bounds;
        [giftButton addTarget:self action:@selector(selectGift) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:giftButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 61, 85, 17)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 10;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"Gift Shop";
        [self addSubview:titleLabel];
        
        NSString *titleKey = [NSString stringWithFormat:@"gift.%@.title",[giftData valueForKey:@"code"]];
        titleLabel.text = NSLocalizedString(titleKey,nil);

        UIImage *proChipImage = [UIImage imageNamed:@"pro_chip_back.png"];
        UIImageView *proChipImageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1,0,30,30)];
        proChipImageImageView.image = proChipImage;
        [self addSubview:proChipImageImageView];
        
        UILabel *proChipValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 20, 15)];
        proChipValueLabel.textAlignment = UITextAlignmentCenter;
        proChipValueLabel.font = [UIFont boldSystemFontOfSize:14];
        proChipValueLabel.backgroundColor = [UIColor clearColor];
        proChipValueLabel.adjustsFontSizeToFitWidth = YES;
        proChipValueLabel.minimumFontSize = 10;
        proChipValueLabel.textColor = [UIColor blackColor];
        proChipValueLabel.text = [giftData valueForKey:@"purchaseValue"];
        [proChipImageImageView addSubview:proChipValueLabel];

    }
    return self;
}

-(void)selectGift{
    
    self.pressed = YES;
    selected = YES;
    //NSLog(@"code:%@",[giftData valueForKey:@"code"]);
    backgroundImageView.image = selectedImage;
}

-(void)unselectGift{
    selected = NO;
    backgroundImageView.image = regularImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
