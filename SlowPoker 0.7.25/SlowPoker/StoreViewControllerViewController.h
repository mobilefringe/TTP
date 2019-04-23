//
//  StoreViewControllerViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreFront.h"

@class MFButton;

@interface StoreViewControllerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,StoreFrontDelegate>{
    MFButton *cancelButton;
    MFButton *learnMoreButton;
    UILabel *cancelLabel;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UITableView *_tableView;
    UIActivityIndicatorView *loadingIndicator;
}

@property(nonatomic,retain)MFButton *cancelButton;
@property(nonatomic,retain)MFButton *learnMoreButton;
@property(nonatomic,retain)UILabel *cancelLabel;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *subTitleLabel;
@property(nonatomic,retain)UITableView *_tableView;
-(void)showStore;
-(void)showStoreNotEnoughChips;
-(void)closeStore:(BOOL)animated;
-(void)isLoadingProducts;


@end
