//
//  TurnsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlowPokerViewController.h"



@class TurnSectionHeader;
@class BetViewController;
@class MessageBubblesViewController;
@class ChatButton;
@class PokerTableView;
@class HandSummaryPopUp;
@class GameStatsViewController;
@class BetTableViewButton;
@class GameStatsButton;


@interface TurnsViewController : SlowPokerViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    UIActivityIndicatorView *activityIndicatorView;
    UILabel *updatingMessage;
    UIActionSheet *betOptions;
    TurnSectionHeader *sectionHeader;
    BetViewController *betViewController;
    UIAlertView *buyInAlert;
    UIAlertView *leaveGameAlert;
    UILabel *buyInAmountLabel;
    double buyIn;
    UILabel *buyInRange;
    UIAlertView *cashGameStartAlert;
    UIAlertView *notEnoughPlayersAlert;
    UIAlertView *winnerLoserAlert;
    UIAlertView *winnerLoserAlertWithBuyin;
    UIAlertView *gameOverAlert;
    UIAlertView *nudgeAlert;
    UIAlertView *viewOrNudge;
    UIAlertView *joinTournamentAlert;
    UIAlertView *buyGameAlert;
    UIAlertView *noOneLeftAlert;
    HandSummaryPopUp *handSummaryPopUp;
    NSTimer *refreshTimer;
    int recurranceIndex;
    UIImageView *chatFieldBackground;
    UITextField *chatField;
    ChatButton *chatButton;
    MessageBubblesViewController *messageBubblesViewController;
    UIBarButtonItem *closeChatButton;
    UIBarButtonItem *bugButton;
    UIBarButtonItem *betViewButton;
    UIBarButtonItem *tableViewButton;
    UIAlertView *waitNextHandAlert;
    BOOL showAlerts;
    BOOL showGameOver;
    BOOL showhandOver;
    BOOL isGameComplete;
    UIAlertView *waitingForGameOwner;
    UIButton *listTableButton;
    PokerTableView *pokerTableView;
    UIImageView *background;
    UIView *flipView;
    UIView *navHeader;
    UILabel *navLabel1;
    UILabel *navLabel2;
    NSMutableDictionary *pressedPlayer;
    GameStatsViewController *gameStatsViewController;
    BetTableViewButton *betOrTableViewButton;
    GameStatsButton *gameStatsButton;
    UIImageView *woodBackground;
    double bigStack;
    double lowStack;
    UIAlertView *gameOverAlertWithRematch;
    UIActivityIndicatorView *loadingIndicator;
    BOOL userWantsToDelete;
    UIAlertView *cantDeleletGame;
}

@property(nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain)UILabel *updatingMessage;
@property (nonatomic,retain)BetTableViewButton *betOrTableViewButton;
@property (nonatomic,retain)GameStatsButton *gameStatsButton;
@property (nonatomic,retain)UIActionSheet *betOptions;
@property (nonatomic,retain)TurnSectionHeader *sectionHeader;
@property (nonatomic,retain)BetViewController *betViewController;
@property (nonatomic,retain)UIAlertView *buyInAlert;
@property (nonatomic,retain)UIAlertView *leaveGameAlert;
@property (nonatomic,retain)UIAlertView *winnerLoserAlert;
@property (nonatomic,retain)UIAlertView *winnerLoserAlertWithBuyin;
@property (nonatomic,retain)UIAlertView *gameOverAlert;
@property (nonatomic,retain)UIAlertView *nudgeAlert;
@property (nonatomic,retain)UIAlertView *buyGameAlert;
@property (nonatomic,retain)UILabel *buyInAmountLabel;
@property (nonatomic,retain)UILabel *buyInRange;
@property (readwrite)double buyIn;
@property (nonatomic,retain)UIAlertView *cashGameStartAlert;
@property (nonatomic,retain)UIAlertView *notEnoughPlayersAlert;
@property (nonatomic,retain)UIAlertView *joinTournamentAlert;
@property (nonatomic,retain)UIAlertView *noOneLeftAlert;
@property (nonatomic,retain)NSTimer *refreshTimer;
@property (nonatomic,retain)UITextField *chatField;
@property (nonatomic,retain)UIImageView *chatFieldBackground;
@property (nonatomic,retain)ChatButton *chatButton;
@property (nonatomic,retain)UIBarButtonItem *closeChatButton;
@property (nonatomic,retain)UIBarButtonItem *bugButton;
@property (nonatomic,retain)UIAlertView *waitNextHandAlert;
@property (nonatomic,retain)MessageBubblesViewController *messageBubblesViewController;
@property (nonatomic,retain)UIAlertView *waitingForGameOwner;
@property (nonatomic,retain)UIButton *listTableButton;
@property (nonatomic,retain)UIView *seatView;
@property (nonatomic,retain)UIImageView *background;
@property (nonatomic,retain)UIView *flipView;
@property (nonatomic,retain)PokerTableView *pokerTableView;
@property (nonatomic,retain)UIView *navHeader;
@property (nonatomic,retain)UILabel *navLabel1;
@property (nonatomic,retain)UILabel *navLabel2;
@property (nonatomic,retain)UIAlertView *viewOrNudge;
@property (nonatomic,retain)NSMutableDictionary *pressedPlayer;
@property (readwrite)int recurranceIndex;
@property (nonatomic,retain)HandSummaryPopUp *handSummaryPopUp;
@property (nonatomic,retain)GameStatsViewController *gameStatsViewController;
@property (nonatomic,retain)UIImageView *woodBackground;
@property (nonatomic,retain)UIAlertView *gameOverAlertWithRematch;
@property (nonatomic,retain)UIAlertView *cantDeleletGame;
@property (readwrite)BOOL userWantsToDelete;




-(void)updateGameData;
-(void)showBuyInAlertIfNeeded;
-(void)showStartGameAlertIfNeeded;
-(void)showWinnerLoserIfNeeded;
-(void)showGameOverIfNeeded;
-(void)loadGame;
-(void)hideChat;
-(void)showChatFull;
-(void)showChatWithKeyboard;
-(void)pressChat;
-(void)showWaitNextHandIfNeeded;
-(void)pressPlayer:(NSMutableDictionary *)player isPlayersTurn:(BOOL)isPlayersTurn;
-(void)pressNudge;
-(void)pressNewHand;
-(void)pressViewHand;
-(void)pressBet;
-(void)showHandSummaryForHand:(NSMutableDictionary *)hand;
-(void)resetGameStats;
-(void)joinCashGame;
-(void)joinTournament;
-(void)showDeleteGameIfNeeded;
@end
