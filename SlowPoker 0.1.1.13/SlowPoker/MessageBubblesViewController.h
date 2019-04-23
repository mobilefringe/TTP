//
//  MessageBubblesViewController.h
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadCell.h"
@class TTTTimeIntervalFormatter;

@interface MessageBubblesViewController : UITableViewController {
  NSArray *messages;
    NSDateFormatter *utcFormatter;
    NSDateFormatter *localFormatter;
    TTTTimeIntervalFormatter *timeIntervalFormatter;
}

@property (nonatomic, retain) NSArray *messages;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic, retain) NSDateFormatter *localFormatter;
@property (nonatomic, retain) TTTTimeIntervalFormatter *timeIntervalFormatter;
-(void)reloadMessage;
-(void)scrollToBottom;
-(NSString *)getMessageForShowHand:(NSMutableDictionary *)showDict;

@end
