//
//  InviteFacebookFriendsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 13-01-02.
//
//

#import <UIKit/UIKit.h>

@interface InviteFacebookFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *_tableView;
   
    
}

@property (nonatomic,retain)UITableView *_tableView;


@end
