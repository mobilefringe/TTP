//
//  GameTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTableViewCell.h"
#import "DataManager.h"

@implementation GameTableViewCell

@synthesize card1;
@synthesize card2;
@synthesize vsLabel;
@synthesize userStackLabel;
@synthesize gameTypeLabel;
@synthesize playersTurn;
@synthesize gameIDLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.card1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 41, 58)];
        [self.contentView addSubview:card1];
        
        self.card2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+44, 8, 41, 58)];
        [self.contentView addSubview:card2];
        
        self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 160, 20)];
        userStackLabel.adjustsFontSizeToFitWidth = YES;
        userStackLabel.minimumFontSize = 10;
        userStackLabel.font = [UIFont boldSystemFontOfSize:18];
        userStackLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        [self.contentView addSubview:userStackLabel];
        userStackLabel.backgroundColor = [UIColor clearColor];
        
        self.gameTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 29, 170, 17)];
        gameTypeLabel.backgroundColor = [UIColor clearColor];
        gameTypeLabel.adjustsFontSizeToFitWidth = YES;
        gameTypeLabel.font = [UIFont systemFontOfSize:15];
        gameTypeLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        gameTypeLabel.minimumFontSize = 10;
        [self.contentView addSubview:gameTypeLabel];
        
        self.vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 170, 30)];
        vsLabel.backgroundColor = [UIColor clearColor];
        vsLabel.adjustsFontSizeToFitWidth = YES;
        vsLabel.font = [UIFont systemFontOfSize:15];
        vsLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        vsLabel.minimumFontSize = 10;
        [self.contentView addSubview:vsLabel];
        
        self.playersTurn = [[UILabel alloc] initWithFrame:CGRectMake(20, 66, 255, 18)];
        playersTurn.backgroundColor = [UIColor clearColor];
        playersTurn.adjustsFontSizeToFitWidth = YES;
        playersTurn.font = [UIFont systemFontOfSize:13];
        playersTurn.textAlignment = UITextAlignmentCenter;
        playersTurn.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        playersTurn.minimumFontSize = 10;
        [self.contentView addSubview:playersTurn];
        
        self.gameIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 295, 18)];
        gameIDLabel.backgroundColor = [UIColor clearColor];
        gameIDLabel.adjustsFontSizeToFitWidth = YES;
        gameIDLabel.font = [UIFont systemFontOfSize:13];
        gameIDLabel.textAlignment = UITextAlignmentRight;
        gameIDLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        gameIDLabel.minimumFontSize = 10;
        [self.contentView addSubview:gameIDLabel];
        
    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)game{
    gameIDLabel.text = [NSString stringWithFormat:@"id:%@",[game valueForKey:@"gameID"]];
    NSMutableDictionary *playerMe;
    NSMutableArray *players;
    
    playerMe = [[DataManager sharedInstance] getPlayerMeForGame:game];
    players = [[DataManager sharedInstance] getTurnStatePlayersForGame:game];
    
    
    //cell.detailTextLabel.text = [[DataManager sharedInstance] getGameActivityMessageForGame:game];
    if([@"pending" isEqualToString:[game objectForKey:@"status"]]){
        if([@"pending" isEqualToString:[playerMe objectForKey:@"status"]]){
            playersTurn.text = @"-- Waiting for you to buyin --";
        }else{
            int numOfPendingPlayers = 0;
            NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
            for (NSMutableDictionary *player in players) {
                if([[player objectForKey:@"status"] isEqualToString:@"pending"]){
                    numOfPendingPlayers++;
                }
            }
            if(numOfPendingPlayers > 0){
                playersTurn.text = [NSString stringWithFormat:@"-- Waiting for %d player(s) to buyin --",numOfPendingPlayers];
            }else{
                if([[game valueForKey:@"gameOwnerID"] isEqualToString:[DataManager sharedInstance].myUserID]){
                    playersTurn.text = @"-- Waiting for you to start game --";
                }else{
                    playersTurn.text = @"-- Waiting for game to start --";
                }
            }
        }
    }else{
        playersTurn.text = [NSString stringWithFormat:@"-- %@ Turn --",[[DataManager sharedInstance] getPlayersTurnForGame:game]];
    }
    
    /*
    if(indexPath.section == 2){
        cell.textLabel.text = @"Somebody won!";
        playersTurn.text = @"Game Over";
    }*/
    
    
    NSString *playersString = @"vs ";
    for (int i = 0; i < [players count]; i++) {
        NSMutableDictionary *player = [players objectAtIndex:i];
        if(playerMe != player && ![[player valueForKey:@"status"] isEqualToString:@"leave"]){
            playersString = [playersString stringByAppendingFormat:@"%@",[player objectForKey:@"userName"]];
            if(i+1 < [players count]){
                playersString = [playersString stringByAppendingString:@", "];
            }
        }
        
    }
    
    //playersString = @"djashdjkas, hjdahsd, hdjasd";
    /*
    for (NSMutableDictionary *player in players) {
        if(playerMe != player && ![[player valueForKey:@"status"] isEqualToString:@"leave"]){
            playersString = [playersString stringByAppendingFormat:@"%@",[player objectForKey:@"userName"]];
        }
    }*/
    vsLabel.text = playersString;
    
    if(playerMe){
        if([[playerMe objectForKey:@"playerState"] valueForKey:@"userStack"]){
            userStackLabel.textColor = [UIColor blackColor];
            userStackLabel.text = [NSString stringWithFormat:@"$%@",[[playerMe objectForKey:@"playerState"] valueForKey:@"userStack"]];
        }else {
            userStackLabel.textColor = [UIColor colorWithRed:0.7 green:.5 blue:0 alpha:1];
            userStackLabel.text = [NSString stringWithFormat:@"$%.2f - $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
        }
        
        gameTypeLabel.text = NSLocalizedString([[game objectForKey:@"gameSettings"] objectForKey:@"type"],nil);
        ////NSLog(@"playerMe turns State%@",[playerMe objectForKey:@"playerState"]);
        if([[playerMe objectForKey:@"playerState"] objectForKey:@"cardOne"] && [[playerMe objectForKey:@"playerState"] objectForKey:@"cardTwo"]){
            [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:[[playerMe objectForKey:@"playerState"] objectForKey:@"cardOne"] ]];
            [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:[[playerMe objectForKey:@"playerState"] objectForKey:@"cardTwo"] ]];
        }else{
            [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:@"?" ]];
            [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:@"?" ]];
        }
        
        // cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[playerMe objectForKey:@"cardOne"],[playerMe objectForKey:@"cardTwo"],playersString];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
