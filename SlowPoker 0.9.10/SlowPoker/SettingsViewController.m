//
//  SettingsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "HandEvaluatorViewController.h"
#import "CellHeaderGeneral.h"
#import "CellFooterGeneral.h"
#import "SettingsTableCell.h"
#import "Facebook.h"

@implementation SettingsViewController
@synthesize handEvaluatorViewController;
@synthesize confirmLogout;
@synthesize resetProChips;


;
@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game Settings";
        
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
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, topbarHeight,self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 50;
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
    [self.view addSubview:_tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView flashScrollIndicators];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"Settings"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	SettingsTableCell *cell = (SettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[SettingsTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
	}
	
	cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumFontSize = 10;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Version";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"FAQ";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Feedback";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }
    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row == 0){
            cell.textLabel.text = @"Logout";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }if(indexPath.row == 1){
            cell.textLabel.text = @"User Name";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [DataManager sharedInstance].myUserName;
        }if(indexPath.row == 2){
            cell.textLabel.text = @"Email";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [DataManager sharedInstance].myEmail;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"Reset Pro Chips";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"Vibrate";
            cell.detailTextLabel.text = @"On";
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Hand Evaluator";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Report Bug";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }
    }
    
   
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"About";
    }else if(section == 1){
        return @"Account";
    }else if(section == 2){
        return @"Test";
    }
    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        return 2;
    }
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString* escapedUrlString =[@"http://www.texasturnpoker.com/faq" stringByAddingPercentEscapesUsingEncoding:
                                         NSUTF8StringEncoding];
            [appDelegate goToWebViewControllerWithURL:escapedUrlString withTitle:@"FAQ"];
        }else if(indexPath.row == 2){
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] emailBug:self];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            if(!confirmLogout){
                self.confirmLogout = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
            }
            confirmLogout.message = [NSString stringWithFormat:@"Would you like to logout user %@?",[DataManager sharedInstance].myUserName];
            [confirmLogout show];
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            if(!handEvaluatorViewController){
                self.handEvaluatorViewController = [[HandEvaluatorViewController alloc] initWithNibName:nil bundle:nil];
            }
            [handEvaluatorViewController resetHands];
            [self.navigationController pushViewController:handEvaluatorViewController animated:YES];
        }else if(indexPath.row == 1){
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] emailBug:self];
        }
    }
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == confirmLogout && buttonIndex == 1){
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([appDel.facebook isSessionValid]) {
            [appDel.facebook logout];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(alertView == resetProChips && buttonIndex == 1){
        [[DataManager sharedInstance] resetProChips];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"About TTP"];
        return header;
    }else if(section == 1){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Account"];
        return header;
    }else if(section == 2){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Test"];
        return header;
    }
    return nil;
    
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 if(section == 0){
 return @"Base Stats";
 }else if(section == 1){
 return @"Pro Stats";
 }else if(section == 2){
 return @"Win/Loss";
 }
 return nil;
 
 }*/

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) title:@""];
        return footer;
    }else if(section == 1){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 40) title:@""];
        return footer;
    }else if(section == 2){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 40) title:@""];
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
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
