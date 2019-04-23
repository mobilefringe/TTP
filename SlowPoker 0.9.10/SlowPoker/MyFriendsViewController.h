//
//  MyFriendsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *_tableView;
    UIActivityIndicatorView *activityIndicatorView;
    BOOL needsReload;
}

@property (nonatomic,retain)UITableView *_tableView;
@property (readwrite)BOOL needsReload;


@end
