//
//  MessageBubblesViewController.m
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageBubblesViewController.h"
#import "DataManager.h"
#import "TTTTimeIntervalFormatter.h"

@implementation MessageBubblesViewController

@synthesize messages;
@synthesize utcFormatter;
@synthesize localFormatter;
@synthesize timeIntervalFormatter;




#pragma mark - View lifecycle

- (void)viewDidLoad {

  [super viewDidLoad];
  /*
  self.messages = [NSArray arrayWithObjects:@"This is the first message", 
                                            @"This is the second message", 
                   @"This is the third message which is longer than most", 
                   @"This is the fourth message that is super super super long, This is the fourth message that is super super super long",@"This is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super longThis is the fourth message that is super super super long, This is the fourth message that is super super super long", nil];
  */
    /*
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 900)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view insertSubview:backgroundView belowSubview: self.tableView];*/
    
    //self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.85];
  self.tableView.backgroundColor     = [UIColor whiteColor];
  self.tableView.autoresizesSubviews = YES;
  self.tableView.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
  self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if(!timeIntervalFormatter){
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[[DataManager sharedInstance] getMessagesForCurrentGame] count];
}

-(void)reloadMessage{
    [self.tableView reloadData];
    if([DataManager sharedInstance].newMessagesCount > 0){
        [self scrollToBottom];
    }
}

-(void)scrollToBottom{
    [self.tableView reloadData];
    if([[DataManager sharedInstance] getMessagesForCurrentGame] && [[[DataManager sharedInstance] getMessagesForCurrentGame] count] > 1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[[[DataManager sharedInstance] getMessagesForCurrentGame] count]-1 ];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    
    

  // create the parent view that will hold header Label
	UIView *customView   = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 20.0)];
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];

	customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  
  headerLabel.backgroundColor      = [UIColor clearColor];
	headerLabel.opaque               = NO;
	headerLabel.textColor            = [UIColor lightGrayColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font                 = [UIFont boldSystemFontOfSize:12];
	headerLabel.frame                = CGRectMake(115.0, 0.0, 300.0, 20.0);
	
    //NSMutableDictionary *message = [[DataManager sharedInstance].gameMessages objectAtIndex:section];
    //NSLog(@"message:%@",message);
    
	
  [customView addSubview:headerLabel];
	
	
  return nil;//customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;//20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"MsgListCell";
  
  ThreadCell *cell = (ThreadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[ThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

    NSMutableDictionary *message = [[[DataManager sharedInstance] getMessagesForCurrentGame] objectAtIndex:indexPath.section];
    //NSLog(@"message:%@",message);
    if([[message valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        cell.imgName = @"aqua.png";
        cell.tipRightward = NO;
        cell.msgText = [message valueForKey:@"message"];
    }else{
        cell.imgName = @"purple.png";
        cell.tipRightward = YES;
        cell.msgText = [NSString stringWithFormat:@"%@: %@",[message valueForKey:@"userName"], [message valueForKey:@"message"]];
    }
    
    if(!utcFormatter){
        self.utcFormatter = [[NSDateFormatter alloc] init];
        [utcFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    }
    
    NSDate *createdAt = [utcFormatter dateFromString:[message valueForKey:@"created_at"]];
  	cell.dateText = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:createdAt];
  
  
      
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *aMsg = [[[[DataManager sharedInstance] getMessagesForCurrentGame] valueForKey:@"message"] objectAtIndex:indexPath.section];
  CGFloat widthForText ;
  
  UIInterfaceOrientation orient = [self interfaceOrientation];
  
  if (UIInterfaceOrientationIsPortrait(orient)) {
    widthForText = 260.f;
  } else {
    widthForText = 400.f;
  }
    
	CGSize size = [ThreadCell calcTextHeight:aMsg withinWidth:widthForText];

	size.height += 5;
	
	CGFloat height = (size.height < 36) ? 36 : size.height;
	
	return height+28;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
}


@end

