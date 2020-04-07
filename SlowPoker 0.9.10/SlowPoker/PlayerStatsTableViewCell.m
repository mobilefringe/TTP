//
//  PlayerStatsTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerStatsTableViewCell.h"
#import "DataManager.h"

@implementation PlayerStatsTableViewCell

@synthesize gamesLabel;
@synthesize handsLabel;
@synthesize cashEarningsLabel;
@synthesize tournamentsLabel;

@synthesize gamesValueLabel;
@synthesize handsValueLabel;
@synthesize cashValueEarningsLabel;
@synthesize tournamentsValueLabel;

@synthesize subtextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width, 90);
        [self.contentView addSubview:background];
        
        self.handsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 230, 18)];
        handsLabel.backgroundColor = [UIColor clearColor];
        handsLabel.textColor = [UIColor whiteColor];
        handsLabel.adjustsFontSizeToFitWidth = YES;
        handsLabel.minimumFontSize = 12;
        handsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:handsLabel];
        
        self.gamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 230, 18)];
        gamesLabel.backgroundColor = [UIColor clearColor];
        gamesLabel.textColor = [UIColor whiteColor];
        gamesLabel.adjustsFontSizeToFitWidth = YES;
        gamesLabel.minimumFontSize = 12;
        gamesLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:gamesLabel];
        
        self.cashEarningsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+18, 230, 18)];
        cashEarningsLabel.backgroundColor = [UIColor clearColor];
        cashEarningsLabel.textColor = [UIColor whiteColor];
        cashEarningsLabel.adjustsFontSizeToFitWidth = YES;
        cashEarningsLabel.minimumFontSize = 12;
        cashEarningsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:cashEarningsLabel];
        
        self.tournamentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+18+18, 230, 18)];
        tournamentsLabel.backgroundColor = [UIColor clearColor];
        tournamentsLabel.textColor = [UIColor whiteColor];
        tournamentsLabel.adjustsFontSizeToFitWidth = YES;
        tournamentsLabel.minimumFontSize = 12;
        tournamentsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:tournamentsLabel];
        
        
        self.gamesValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(193, 25, 75, 18)];
        gamesValueLabel.backgroundColor = [UIColor clearColor];
        gamesValueLabel.textAlignment = UITextAlignmentRight;
        gamesValueLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        gamesValueLabel.adjustsFontSizeToFitWidth = YES;
        gamesValueLabel.minimumFontSize = 12;
        gamesValueLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:gamesValueLabel];
        
        self.handsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(193, 7, 75, 18)];
        handsValueLabel.backgroundColor = [UIColor clearColor];
        handsValueLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        handsValueLabel.textAlignment = UITextAlignmentRight;
        handsValueLabel.adjustsFontSizeToFitWidth = YES;
        handsValueLabel.minimumFontSize = 12;
        handsValueLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:handsValueLabel];
        
        self.cashValueEarningsLabel = [[UILabel alloc] initWithFrame:CGRectMake(193, 25+18, 75, 18)];
        cashValueEarningsLabel.backgroundColor = [UIColor clearColor];
        cashValueEarningsLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        cashValueEarningsLabel.textAlignment = UITextAlignmentRight;
        cashValueEarningsLabel.adjustsFontSizeToFitWidth = YES;
        cashValueEarningsLabel.minimumFontSize = 12;
        cashValueEarningsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:cashValueEarningsLabel];
        
        self.tournamentsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(193, 25+18+18, 75, 18)];
        tournamentsValueLabel.backgroundColor = [UIColor clearColor];
        tournamentsValueLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        tournamentsValueLabel.textAlignment = UITextAlignmentRight;
        tournamentsValueLabel.adjustsFontSizeToFitWidth = YES;
        tournamentsValueLabel.minimumFontSize = 12;
        tournamentsValueLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:tournamentsValueLabel];
        
        /*
        self.subtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+18+18+16, 280, 16)];
        subtextLabel.backgroundColor = [UIColor clearColor];
        subtextLabel.textColor = [UIColor lightGrayColor];
        subtextLabel.textAlignment = UITextAlignmentCenter;
        subtextLabel.adjustsFontSizeToFitWidth = YES;
        subtextLabel.minimumFontSize = 10;
        subtextLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:subtextLabel];
        
        subtextLabel.text = @"--- More Pro Stats ---";
         */
        
    }
    return self;
}

-(void)setStatData:(NSMutableDictionary *)playerProfieDict{
    NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",@"GAMES_PLAYED"];
    gamesLabel.text = NSLocalizedString(titleKey,nil); 
    gamesValueLabel.text = [NSString stringWithFormat:@"%d",[self statDouble:@"GAMES_PLAYED"]];
    
    titleKey = [NSString stringWithFormat:@"profile.%@.title",@"HANDS_PLAYED"];
    handsLabel.text = NSLocalizedString(titleKey,nil); 
    handsValueLabel.text = [NSString stringWithFormat:@"%d",[self statDouble:@"HANDS_PLAYED"]];
    
    titleKey = [NSString stringWithFormat:@"profile.%@.title",@"CASH_GAMES_PLAYED"];
    cashEarningsLabel.text = NSLocalizedString(titleKey,nil); 
    cashValueEarningsLabel.text = [NSString stringWithFormat:@"%d",[self statDouble:@"CASH_GAMES_PLAYED"]];
    
    titleKey = [NSString stringWithFormat:@"profile.%@.title",@"TOURNAMENT_GAMES_PLAYED"];
    tournamentsLabel.text = NSLocalizedString(titleKey,nil); 
    tournamentsValueLabel.text = [NSString stringWithFormat:@"%d",[self statDouble:@"TOURNAMENT_GAMES_PLAYED"]];
}

-(int)statDouble:(NSString *)statCode{
    return [[DataManager sharedInstance] getCountForUserAchievement:statCode category:@"PROFILE"];
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
