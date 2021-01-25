
#import "CardPlayerView.h"
#import "DataManager.h"
#import "Button.h"
#import "TurnsViewController.h"
#import "Avatar.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation CardPlayerView

@synthesize cardOne;
@synthesize cardTwo;
@synthesize playerView;
@synthesize isMe;
@synthesize userNameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }

    self.playerView = [[UIView alloc] initWithFrame:self.bounds];
    playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:playerView];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"player_view_player_background.png"];
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width/2, backgroundImage.size.height/2)];
    backgroundImageView.image = backgroundImage;
    [playerView addSubview:backgroundImageView];
    
    self.backgroundBlue = [UIImage imageNamed:@"player_view_player_background_blue.png"];

    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 61, 13)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont systemFontOfSize:10];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.minimumFontSize = 8;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.text = @"";
    [playerView addSubview:userNameLabel];

    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 45)];
    [playerView addSubview:cardOne];
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(40, 15, 30, 45)];
    [playerView addSubview:cardTwo];
        
    [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];

    return self;
}


-(void)setPlayerData:(NSMutableDictionary *)playerData{
    NSLog(@"player:%@",playerData);

    [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[playerData objectForKey:@"cardOne"]]];
    [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[playerData objectForKey:@"cardTwo"]]];
    self.userNameLabel.text = [playerData objectForKey:@"userName"];
}

@end
