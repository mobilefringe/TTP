#import <UIKit/UIKit.h>

@class Button;
@class TurnsViewController;
@class Avatar;

@interface CardPlayerView : UIView{
    UIImageView *backgroundImageView;
    UIImage *backgroundBlue;
    UIImageView *grayBar;
    UILabel *userNameLabel;
    UILabel *userStackLabel;
    UILabel *actionLabel;
    NSMutableDictionary *player;
    
    UIImageView *dealerButton;
    UIView *playerView;
    UIImageView *cardOne;
    UIImageView *cardTwo;
    BOOL isCurrentHandTmp;
    BOOL isWinner;
    BOOL isMe;
    TurnsViewController *delegate;
    UIButton *button;
}

@property (nonatomic,retain)UIImageView *backgroundImageView;
@property (nonatomic,retain)UIImage *backgroundBlue;
@property (nonatomic,retain)UIImageView *grayBar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *userStackLabel;
@property (nonatomic,retain)NSMutableDictionary *player;

@property (nonatomic,retain)UIView *playerView;
@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;

@property (readwrite)BOOL isMe ;

-(void)setPlayerData:(NSMutableDictionary *)playerData;

@end
