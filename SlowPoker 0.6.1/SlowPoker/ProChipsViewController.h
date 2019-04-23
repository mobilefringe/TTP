//
//  ProChipsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProChipsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@property(nonatomic,retain)UITableView *_tableView;


@end
