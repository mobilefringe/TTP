//
//  GameTypeCellCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTypeCellCell.h"

@implementation GameTypeCellCell

@synthesize description;
@synthesize title;
@synthesize cashImage;
@synthesize tournamentImage;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 100);
        [self.contentView addSubview:background];
        
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(83, 20, 210, 25)];
        title.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        title.font = [UIFont boldSystemFontOfSize:22];
        title.tag = 10;
        title.adjustsFontSizeToFitWidth = YES;
        title.minimumFontSize = 10;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:title];
        
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(83, 40, 195, 60)];
        description.textColor = [UIColor whiteColor];
        description.font = [UIFont boldSystemFontOfSize:11];
        description.numberOfLines = 4;
        description.adjustsFontSizeToFitWidth = YES;
        description.minimumFontSize = 10;
        description.backgroundColor = [UIColor clearColor];
        description.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:description];
        
        self.cashImage = [UIImage imageNamed:@"icon_cashgame.png"];
        self.tournamentImage = [UIImage imageNamed:@"icon_tournament.png"];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 70, 70)];
        
        [self.contentView addSubview:imageView];
    }
    return self;
}

-(void)setData:(BOOL)isCash{
    if(isCash){
        imageView.image = cashImage;
        title.text = @"Cash Game";
        description.text = @"Players can buy into an active game. Players can re-buy if they lose their $";
    }else{
        imageView.image = tournamentImage;
        title.text = @"Tournament Game";
        description.text = @"All players must join the game when it starts. Once a player loses all their $ they are out of the tournament";
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
