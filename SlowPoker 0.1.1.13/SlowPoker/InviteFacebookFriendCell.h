//
//  InviteFacebookFriendCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 13-01-02.
//
//

#import <UIKit/UIKit.h>

@class Avatar;

@interface InviteFacebookFriendCell : UITableViewCell{
    UILabel *userName;
    Avatar *avatar;
    UIImageView *checkMark;
    UIImageView *background;
    UIButton *betButton;
    UILabel *betButtonLabel;
    NSMutableDictionary *friendDict;
     UIAlertView *inviteFriendAlert;
}

@property(nonatomic,retain)UILabel *userName;
@property(nonatomic,retain)Avatar *avatar;
@property(nonatomic,retain)UIImageView *checkMark;
@property(nonatomic,retain) UIButton *betButton;
@property(nonatomic,retain) UILabel *betButtonLabel;
@property(nonatomic,retain) NSMutableDictionary *friendDict;
@property (nonatomic,retain)UIAlertView *inviteFriendAlert;
-(void)loadPlayerData:(NSMutableDictionary *)player showInvite:(BOOL)showInvite;
@end
