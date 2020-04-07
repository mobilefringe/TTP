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
@synthesize chatIndicator;
@synthesize chatCountLabel;
@synthesize isPlayNow;
@synthesize playNowLabel;
@synthesize playNowDescriptionLabel;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;
@synthesize isCreateGame;
@synthesize createGameImageView;
@synthesize joinGameImageView;
@synthesize cashImageView;
@synthesize tournamentImageView;
@synthesize isFreeGames;
@synthesize isDeleteGameBlurb;
@synthesize proChipImageView;
@synthesize feedbackImageView;
@synthesize swipeGestureImageView;
@synthesize isFeedback;
@synthesize blueChip;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width, 85);
        [self.contentView addSubview:background];
        
        
        self.card1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 41, 58)];
        [self.contentView addSubview:card1];
        
        self.card2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+44, 8, 41, 58)];
        [self.contentView addSubview:card2];
        
        self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 8, 120, 20)];
        userStackLabel.adjustsFontSizeToFitWidth = YES;
        userStackLabel.minimumFontSize = 10;
        userStackLabel.font = [UIFont boldSystemFontOfSize:18];
        userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self.contentView addSubview:userStackLabel];
        userStackLabel.backgroundColor = [UIColor clearColor];
        
        self.greenChip = [UIImage imageNamed:@"green_chip.png"];
        self.yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
        self.redChip = [UIImage imageNamed:@"red_chip.png"];
        self.blueChip = [UIImage imageNamed:@"blue_chip.png"];
        self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 6, greenChip.size.width/2, greenChip.size.height/2)];
        [self.contentView addSubview:chipImageView];
        
        self.gameTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 31, 170, 17)];
        gameTypeLabel.backgroundColor = [UIColor clearColor];
        gameTypeLabel.adjustsFontSizeToFitWidth = YES;
        gameTypeLabel.font = [UIFont boldSystemFontOfSize:15];
        gameTypeLabel.textColor = [UIColor whiteColor];
        gameTypeLabel.minimumFontSize = 10;
        [self.contentView addSubview:gameTypeLabel];
        
        self.vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 170, 30)];
        vsLabel.backgroundColor = [UIColor clearColor];
        vsLabel.adjustsFontSizeToFitWidth = YES;
        vsLabel.font = [UIFont systemFontOfSize:15];
        vsLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        vsLabel.minimumFontSize = 10;
        [self.contentView addSubview:vsLabel];
        
        self.playersTurn = [[UILabel alloc] initWithFrame:CGRectMake(20, 66, 255, 18)];
        playersTurn.backgroundColor = [UIColor clearColor];
        playersTurn.adjustsFontSizeToFitWidth = YES;
        playersTurn.font = [UIFont boldSystemFontOfSize:12];
        playersTurn.textAlignment = UITextAlignmentCenter;
        playersTurn.textColor = [UIColor whiteColor];
        playersTurn.minimumFontSize = 10;
        [self.contentView addSubview:playersTurn];
        
        self.gameIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 295, 18)];
        gameIDLabel.backgroundColor = [UIColor clearColor];
        gameIDLabel.adjustsFontSizeToFitWidth = YES;
        gameIDLabel.font = [UIFont systemFontOfSize:13];
        gameIDLabel.textAlignment = UITextAlignmentRight;
        gameIDLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        gameIDLabel.minimumFontSize = 10;
        [self.contentView addSubview:gameIDLabel];
        
        self.chatIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purple.png"]];
        chatIndicator.frame = CGRectMake(275, 57, 34, 27);
        [self addSubview:chatIndicator];
        
        self.chatCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 25, 20)];
        chatCountLabel.textColor = [UIColor whiteColor];
        chatCountLabel.textAlignment = UITextAlignmentCenter;
        chatCountLabel.font = [UIFont boldSystemFontOfSize:14];
        chatCountLabel.adjustsFontSizeToFitWidth = YES;
        chatCountLabel.minimumFontSize = 9;
        chatCountLabel.backgroundColor = [UIColor clearColor];
        [chatIndicator addSubview:chatCountLabel];
        
        playNowLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 7, 190, 30)];
        playNowLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        playNowLabel.textAlignment = UITextAlignmentLeft;
        playNowLabel.font = [UIFont boldSystemFontOfSize:24];
        playNowLabel.adjustsFontSizeToFitWidth = YES;
        playNowLabel.minimumFontSize = 9;
        playNowLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:playNowLabel];
        
        playNowDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 35, 180, 44)];
        playNowDescriptionLabel.textColor = [UIColor whiteColor];
        playNowDescriptionLabel.textAlignment = UITextAlignmentLeft;
        playNowDescriptionLabel.font = [UIFont systemFontOfSize:11];
        playNowDescriptionLabel.adjustsFontSizeToFitWidth = YES;
        playNowDescriptionLabel.numberOfLines = 3;
        playNowDescriptionLabel.minimumFontSize = 9;
        playNowDescriptionLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:playNowDescriptionLabel];
        
        self.createGameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 70, 70)];
        createGameImageView.image = [UIImage imageNamed:@"icon_creategame.png"];
        [self.contentView addSubview:createGameImageView];
        
        self.joinGameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 70, 70)];
        joinGameImageView.image = [UIImage imageNamed:@"icon_playnow.png"];
        [self.contentView addSubview:joinGameImageView];
        
        self.cashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 31, 17, 17)];
        cashImageView.image = [UIImage imageNamed:@"icon_cashgame.png"];
        [self.contentView addSubview:cashImageView];
        
        self.tournamentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 31, 17, 17)];
        tournamentImageView.image = [UIImage imageNamed:@"icon_tournament.png"];
        [self.contentView addSubview:tournamentImageView];
        
        self.proChipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 70, 70)];
        proChipImageView.image = [UIImage imageNamed:@"pro_chip_front.png"];
        [self.contentView addSubview:proChipImageView];
        
        self.swipeGestureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 8, 70, 70)];
        swipeGestureImageView.image = [UIImage imageNamed:@"swipe_icon.png"];
        [self.contentView addSubview:swipeGestureImageView];
        
        self.feedbackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 18, 70, 50)];
        feedbackImageView.image = [UIImage imageNamed:@"email_icon.png"];
        [self.contentView addSubview:feedbackImageView];
        
        UILabel *proChipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, 30, 25)];
        proChipLabel.backgroundColor = [UIColor clearColor];
        proChipLabel.adjustsFontSizeToFitWidth = YES;
        proChipLabel.font = [UIFont boldSystemFontOfSize:22];
        proChipLabel.textColor = [UIColor blackColor];
        proChipLabel.minimumFontSize = 10;
        proChipLabel.textAlignment = UITextAlignmentCenter;
        proChipLabel.text = @"20";
        [proChipImageView addSubview:proChipLabel];
        
        
        
    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)game{
    //NSLog(@"Game:%@",game);
    card1.hidden = NO;
    card2.hidden = NO;
    vsLabel.hidden = NO;
    userStackLabel.hidden = NO;
    gameTypeLabel.hidden = NO;
    playersTurn.hidden = NO;
    gameIDLabel.hidden = NO;
    chatIndicator.hidden = NO;
    chatCountLabel.hidden = NO;
    playNowLabel.hidden = YES;
    chipImageView.hidden = NO;
    playNowDescriptionLabel.hidden = YES;
    createGameImageView.hidden = YES;
    joinGameImageView.hidden = YES;
    swipeGestureImageView.hidden = YES;
    tournamentImageView.hidden = YES;
    proChipImageView.hidden = YES;
    cashImageView.hidden = YES;
    feedbackImageView.hidden = YES;
    
    
    
    if(isPlayNow || isCreateGame || isFreeGames || isDeleteGameBlurb || isFeedback){
        chipImageView.hidden = YES;
        card1.hidden = YES;
        card2.hidden = YES;
        vsLabel.hidden = YES;
        userStackLabel.hidden = YES;
        gameTypeLabel.hidden = YES;
        playersTurn.hidden = YES;
        gameIDLabel.hidden = YES;
        chatIndicator.hidden = YES;
        chatCountLabel.hidden = YES;
        playNowLabel.hidden = NO;
        playNowDescriptionLabel.hidden = NO;
        if(isPlayNow){
            joinGameImageView.hidden = NO;
            playNowLabel.text = @"Random Table";
            playNowDescriptionLabel.text = @"Play in a random cash or tournament game and meet new friends!";
        }else if(isCreateGame){
            createGameImageView.hidden = NO;
            playNowLabel.text = @"Play with Friends!";
            playNowDescriptionLabel.text = @"Create a private game and invite your friends with custom blinds and buy-ins!";
        }else if(isFreeGames){
            proChipImageView.hidden = NO;
            playNowLabel.text = @"3 Games Free!";
            playNowDescriptionLabel.text = @"Play in three active games at once for free! Additional games just 20 Pro Chips.";
        }else if(isDeleteGameBlurb){
            swipeGestureImageView.hidden = NO;
            playNowLabel.text = @"Leave a Game?";
            playNowDescriptionLabel.text = @"Want to leave or delete a game? Just swipe the game row to leave/delete the game.";
        }else if(isFeedback){
            feedbackImageView.hidden = NO;
            playNowLabel.text = @"Got Feedback?";
            playNowDescriptionLabel.text = @"We want to hear from you! Press here to tell us about TTP...good and bad :-)";
        }
        return;
    }
    //NSLog(@"game:%@",game);
    gameIDLabel.text = [NSString stringWithFormat:@"Game %@",[game valueForKey:@"gameID"]];
    NSMutableDictionary *playerMe;
    NSMutableArray *players;
    NSString *gameType = [[game objectForKey:@"gameSettings"] objectForKey:@"type"];
    if([@"cash" isEqualToString:gameType]){
        cashImageView.hidden = NO;
    }else if([@"tournament" isEqualToString:gameType]){
        tournamentImageView.hidden = NO;
        
    }
    
    playerMe = [[DataManager sharedInstance] getPlayerMeForGame:game];
    players = [[DataManager sharedInstance] getTurnStatePlayersForGame:game];
    
    int chipStackState = [[DataManager sharedInstance] getUserChipStackStateForPlayers:[DataManager sharedInstance].myUserID players:players];
    if(chipStackState == 1){
        chipImageView.image = greenChip;
    }else if(chipStackState == 2){
        chipImageView.image = yellowChip;
    }else if(chipStackState == 3){
        chipImageView.image = redChip;
    }else{
        chipImageView.image = nil;
    }
    
    
    //cell.detailTextLabel.text = [[DataManager sharedInstance] getGameActivityMessageForGame:game];
    if([[DataManager sharedInstance] isGamePending:game]){
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
    }else if([[DataManager sharedInstance] isGameActive:game]){
        playersTurn.text = [NSString stringWithFormat:@"-- %@ Turn --",[[DataManager sharedInstance] getPlayersTurnForGame:game]];
    }else if([[DataManager sharedInstance] isGameComplete:game]){
        playersTurn.text = [NSString stringWithFormat:@"-- Game Over --"];
    }
    
    /*
    if(indexPath.section == 2){
        cell.textLabel.text = @"Somebody won!";
        playersTurn.text = @"Game Over";
    }*/
    
    
    NSString *playersString = @"vs ";
    int playerCount = 0;
    for (int i = 0; i < [players count]; i++) {
        NSMutableDictionary *player = [players objectAtIndex:i];
        //NSLog(@"player:%@",player);
        if(playerMe != player && ![[player valueForKey:@"status"] isEqualToString:@"leave"]){
            playerCount++;
            playersString = [playersString stringByAppendingFormat:@"%@",[player objectForKey:@"userName"]];
            if(i+1 < [players count]){
                playersString = [playersString stringByAppendingString:@", "];
                
            }
        }
    }
    if(playerCount == 0){
        playersString = @"-Empty Table-";
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
            userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
            userStackLabel.text = [NSString stringWithFormat:@"%@",[[playerMe objectForKey:@"playerState"] valueForKey:@"userStack"]];
            if([[[playerMe objectForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] == 0){
                userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
                userStackLabel.text = @"-All In-";
                if([@"tournament" isEqualToString:gameType]){
                    if(![[playerMe valueForKey:@"status"] isEqualToString:@"playing"]){
                        userStackLabel.textColor = [UIColor colorWithRed:0.7 green:.1 blue:0.1 alpha:1];
                        userStackLabel.text = @"Out";                    
                    }                
                }
            }else{
                if([@"tournament" isEqualToString:gameType] && [[DataManager sharedInstance] isGameComplete:game]){
                    userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
                    userStackLabel.text = @"Winner!";
                }
            }
        }else {
            if([@"cash" isEqualToString:gameType]){
                userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
                userStackLabel.text = [NSString stringWithFormat:@"%.2f - %.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
                cashImageView.hidden = NO;
            }else if([@"tournament" isEqualToString:gameType]){
                tournamentImageView.hidden = NO;
                userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
                userStackLabel.text = [NSString stringWithFormat:@"%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
            }
        }
        
        gameTypeLabel.text = NSLocalizedString([[game objectForKey:@"gameSettings"] objectForKey:@"type"],nil);
        if(![@"YES" isEqualToString:[game valueForKey:@"cardsDidChange"]]){
            if([[playerMe objectForKey:@"playerState"] objectForKey:@"cardOne"] && [[playerMe objectForKey:@"playerState"] objectForKey:@"cardTwo"]){
                [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:[[playerMe objectForKey:@"playerState"] objectForKey:@"cardOne"] ]];
                [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:[[playerMe objectForKey:@"playerState"] objectForKey:@"cardTwo"] ]];
            }else{
                [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:@"?" ]];
                [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:@"?" ]];
            }
        }else{
            chipImageView.image = blueChip;
            userStackLabel.text = @"????";
            playersTurn.text = @"--- Hand is over, see who won!! ---";
            [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:[game valueForKey:@"oldCardOne"]]];
            [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:[game valueForKey:@"oldCardTwo"]]];
        }
        
        // cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[playerMe objectForKey:@"cardOne"],[playerMe objectForKey:@"cardTwo"],playersString];
    }
    
    
    int messageCount = [[game valueForKey:@"messageCount"] intValue];
    if(messageCount > 0){
        chatIndicator.hidden = NO;
        chatCountLabel.text = [game valueForKey:@"messageCount"];
    }else{
        chatIndicator.hidden = YES;
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
