//
//  ProChipsTableCellCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProChipsTableCellCell.h"
#import "DataManager.h"

@implementation ProChipsTableCellCell

@synthesize proChipImage;
@synthesize title;
@synthesize description;
@synthesize proChipValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width, 120);
        [self.contentView addSubview:background];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 210, 25)];
        title.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        title.font = [UIFont boldSystemFontOfSize:22];
        title.tag = 10;
        title.adjustsFontSizeToFitWidth = YES;
        title.minimumFontSize = 10;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:title];
        
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, 200, 70)];
        description.textColor = [UIColor whiteColor];
        description.font = [UIFont boldSystemFontOfSize:10];
        description.numberOfLines = 4;
        description.adjustsFontSizeToFitWidth = YES;
        description.minimumFontSize = 10;
        description.backgroundColor = [UIColor clearColor];
        description.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:description];
        

        self.proChipImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 50, 50)];
        proChipImage.image = [UIImage imageNamed:@"pro_chip_back.png"];
        [self.contentView addSubview:proChipImage];
        
        self.proChipValue = [[UILabel alloc] initWithFrame:CGRectMake(13, 16, 25, 17)];
        proChipValue.backgroundColor = [UIColor clearColor];
        proChipValue.font = [UIFont boldSystemFontOfSize:16];
        proChipValue.textAlignment = UITextAlignmentCenter;
        proChipValue.adjustsFontSizeToFitWidth = YES;
        proChipValue.minimumFontSize = 6;
        [proChipImage addSubview:proChipValue];
        
    }
    return self;
}

-(void)setData:(int)type{
    if(type == 0){
        title.text = @"My Pro Chips";
        proChipValue.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getMyProChips]];
        description.text = [NSString stringWithFormat:@"You have %d Pro Chips. Be a poker pro and use your Pro Chip to get the edge on your opponents to be the best. Learn more below.",[[DataManager sharedInstance] getMyProChips]];
    }else if(type == 1){
        title.text = @"Buying Pro Chips";
        proChipValue.text = @"+";
        description.text = @"Buying Pro Chips is easy. Anywhere you see the Pro Chips icon simply press it to access the TTP store. Press the Pro Chip icon in the top right corner.";
    }else if(type == 2){
        title.text = @"About Pro Chips";
        proChipValue.text = @"?";
        description.text = @"Pro Chips allow you to unlock pro stats, play extra games, buy gifts and much more. Earn Pro Chips with in game achievements or top up in the TTP store.";
        
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		background.image = [UIImage imageNamed:@"cell_body_general_selected.png"];
	}else{
		background.image = [UIImage imageNamed:@"cell_body_general.png"];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
