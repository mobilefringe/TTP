//
//  ProChipsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProChipsViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "ProChipsTableCellCell.h"
#import "CellFooterGeneral.h"
#import "CellHeaderGeneral.h"


@implementation ProChipsViewController



@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pro Chips";
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_bg2_ip5.png"]];
    background.frame = CGRectMake(0, -50, 320, [UIImage imageNamed:@"general_bg2_ip5.png"].size.height/2);
    [self.view addSubview:background];

    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundView:nil];
    _tableView.rowHeight = 130;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        _tableView.frame = CGRectMake(0, 0, 320, 505);
    }
    [self.view addSubview:_tableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView flashScrollIndicators];
}

-(void)viewWillAppear:(BOOL)animated{
    [FlurryAnalytics logEvent:@"PAGE_VIEW_MY_PRO_CHIPS" timed:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"Pro Chips"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_MY_PRO_CHIPS" withParameters:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	ProChipsTableCellCell *cell = (ProChipsTableCellCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[ProChipsTableCellCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
	}
	
	
    if(indexPath.row == 0){
        [cell setData:indexPath.row];
        //cell.textLabel.text = @"My Pro Chip";
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getMyProChips]];
    }else if(indexPath.row == 1){
        [cell setData:indexPath.row];
        //cell.textLabel.text = @"Buy Pro Chips";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.detailTextLabel.text = @"TBD";
    }else if(indexPath.row == 2){
        [cell setData:indexPath.row];
        //cell.textLabel.text = @"About Pro Chips";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.detailTextLabel.text = @"TBD";
    }
    
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showStore];
    }else if(indexPath.row == 2){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString* escapedUrlString =[@"http://www.texasturnpoker.com/faq/proChips" stringByAddingPercentEscapesUsingEncoding:
                                     NSUTF8StringEncoding];

        [appDelegate goToWebViewControllerWithURL:escapedUrlString withTitle:@"Pro Chips"];
    }
    return  nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@""];
    return header;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 40) title:@"Press for more details"];
    return footer;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1 || section == 2){
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}







/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
