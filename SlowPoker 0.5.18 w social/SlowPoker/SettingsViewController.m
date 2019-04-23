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

@implementation SettingsViewController
@synthesize handEvaluatorViewController;

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
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:_tableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView flashScrollIndicators];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
	}
	
	
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
            cell.textLabel.text = @"Watch Video";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }
    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row == 0){
            cell.textLabel.text = @"Sounds";
            cell.detailTextLabel.text = @"On";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Confirm Bet";
            cell.detailTextLabel.text = @"Off";
        }else if(indexPath.row == 2){
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"About";
    }else if(section == 1){
        return @"Settings";
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
            [appDelegate goToWebViewControllerWithURL:@"http://www.mobilefringe.com" withTitle:@"FAQ"];
        }else if(indexPath.row == 2){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate goToWebViewControllerWithURL:@"http://www.mobilefringe.com" withTitle:@"TTP Video"];
        }
    }else if(indexPath.section == 1){
        
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
