//
//  TurnsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TurnSectionHeader;
@class BetViewController;
@class MessageBubblesViewController;
@class ChatButton;



@interface TurnsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>{
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
    UIAlertView *joinTournamentAlert;
    NSTimer *refreshTimer;
    int recurranceIndex;
    UIView *chatFieldBackground;
    UITextField *chatField;
    ChatButton *chatButton;
    MessageBubblesViewController *messageBubblesViewController;
    UIBarButtonItem *closeChatButton;
    UIBarButtonItem *bugButton;
    UIAlertView *waitNextHandAlert;
    BOOL showAlerts;
    BOOL isGameComplete;
    UIAlertView *waitingForGameOwner;
}

@property(nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain)UILabel *updatingMessage;
@property (nonatomic,retain)UIActionSheet *betOptions;
@property (nonatomic,retain)TurnSectionHeader *sectionHeader;
@property (nonatomic,retain)BetViewController *betViewController;
@property (nonatomic,retain)UIAlertView *buyInAlert;
@property (nonatomic,retain)UIAlertView *leaveGameAlert;
@property (nonatomic,retain)UIAlertView *winnerLoserAlert;
@property (nonatomic,retain)UIAlertView *winnerLoserAlertWithBuyin;
@property (nonatomic,retain)UIAlertView *gameOverAlert;
@property (nonatomic,retain)UIAlertView *nudgeAlert;
@property (nonatomic,retain)UILabel *buyInAmountLabel;
@property (nonatomic,retain)UILabel *buyInRange;
@property (readwrite)double buyIn;
@property (nonatomic,retain)UIAlertView *cashGameStartAlert;
@property (nonatomic,retain)UIAlertView *notEnoughPlayersAlert;
@property (nonatomic,retain)UIAlertView *joinTournamentAlert;
@property (nonatomic,retain)NSTimer *refreshTimer;
@property (nonatomic,retain)UITextField *chatField;
@property (nonatomic,retain)UIView *chatFieldBackground;
@property (nonatomic,retain)ChatButton *chatButton;
@property (nonatomic,retain)UIBarButtonItem *closeChatButton;
@property (nonatomic,retain)UIBarButtonItem *bugButton;
@property (nonatomic,retain)UIAlertView *waitNextHandAlert;
@property (nonatomic,retain)MessageBubblesViewController *messageBubblesViewController;
@property (nonatomic,retain)UIAlertView *waitingForGameOwner;
@property (readwrite)int recurranceIndex;


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

@end
