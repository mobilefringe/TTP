//
//  StoreViewControllerViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreViewControllerViewController.h"
#import "MFButton.h"
#import "StoreTableCell.h"
#import "StoreFront.h"
#import "DataManager.h"
#import "AppDelegate.h"

@interface StoreViewControllerViewController ()

@end

@implementation StoreViewControllerViewController

@synthesize cancelButton;
@synthesize cancelLabel;
@synthesize _tableView;
@synthesize learnMoreButton;
@synthesize titleLabel;
@synthesize subTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    UIView *blackbackground = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-320)/2, (self.view.bounds.size.height-490)/2, self.view.bounds.size.width, self.view.bounds.size.height)];
    blackbackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    [self.view addSubview:blackbackground];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_background.png"]];
    background.frame = CGRectMake(20, 50, 280, 393);
    [blackbackground addSubview:background];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 11, 254, 33)];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = 12;
    titleLabel.text = @"TTP Store";
    [background addSubview:titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 35, 254, 40)];
    subTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    subTitleLabel.numberOfLines = 2;
    subTitleLabel.textAlignment = UITextAlignmentCenter;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    //subTitleLabel.adjustsFontSizeToFitWidth = YES;
    //subTitleLabel.minimumFontSize = 12;
    subTitleLabel.text = @"Not enough Pro-Chips, please buy more to purchase your item";
    [background addSubview:subTitleLabel];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 47;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.frame = CGRectMake(32.5, 143, 255, 242);
    _tableView.backgroundColor = [UIColor clearColor];
    [blackbackground addSubview:_tableView];
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-40, 25, 25);
	loadingIndicator.hidesWhenStopped = YES;
	[loadingIndicator startAnimating];
	[blackbackground addSubview:loadingIndicator];
    
    
    self.cancelButton = [MFButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(160,385, 120, 40);
    [cancelButton setImage:[UIImage imageNamed:@"gray_button.png"] forState:UIControlStateNormal];
    //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
    //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
    [cancelButton addTarget:self action:@selector(closeStoreAnimated) forControlEvents:UIControlEventTouchUpInside];
    [blackbackground addSubview:cancelButton];
    
    self.cancelLabel = [[UILabel alloc] initWithFrame:cancelButton.bounds];
    cancelLabel.font = [UIFont boldSystemFontOfSize:18];
    cancelLabel.textAlignment = UITextAlignmentCenter;
    cancelLabel.backgroundColor = [UIColor clearColor];
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.adjustsFontSizeToFitWidth = YES;
    cancelLabel.minimumFontSize = 12;
    cancelLabel.text = @"Done";
    [cancelButton addSubview:cancelLabel];
    
    
    self.learnMoreButton = [MFButton buttonWithType:UIButtonTypeCustom];
    learnMoreButton.frame = CGRectMake(38,385, 120, 40);
    [learnMoreButton setImage:[UIImage imageNamed:@"gray_button.png"] forState:UIControlStateNormal];
    //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
    //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
    [learnMoreButton addTarget:self action:@selector(learnMore) forControlEvents:UIControlEventTouchUpInside];
    [blackbackground addSubview:learnMoreButton];
    
    UILabel *learnMoreLabel = [[UILabel alloc] initWithFrame:cancelButton.bounds];
    learnMoreLabel.font = [UIFont boldSystemFontOfSize:18];
    learnMoreLabel.textAlignment = UITextAlignmentCenter;
    learnMoreLabel.backgroundColor = [UIColor clearColor];
    learnMoreLabel.textColor = [UIColor whiteColor];
    learnMoreLabel.adjustsFontSizeToFitWidth = YES;
    learnMoreLabel.minimumFontSize = 12;
    learnMoreLabel.text = @"About";
    [learnMoreButton addSubview:learnMoreLabel];
    
    [StoreFront sharedStore].delegate = self;

}

- (void)didRetrieveProducts:(NSMutableArray*)products{
    [loadingIndicator stopAnimating];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    _tableView.alpha = 1;
    [UIView commitAnimations];
    [_tableView reloadData];
}

-(void)isLoadingProducts{
    [loadingIndicator startAnimating];
    _tableView.alpha = 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	StoreTableCell *cell = (StoreTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[StoreTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
	}
    NSMutableDictionary *product = [[DataManager sharedInstance].products objectAtIndex:indexPath.row];
    [cell setProduct:product];
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[DataManager sharedInstance].products count];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreTableCell *cell = (StoreTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    [[StoreFront sharedStore] addPayment:(SKProduct*)[cell.thisProduct objectForKey:@"SKProduct"]];
    
    return nil;
}

-(void)closeStore:(BOOL)animated{
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationDelegate:self];
    }
    self.view.alpha = 0;
    if(animated){
        [UIView commitAnimations];
    }
}

-(void)closeStoreAnimated{
    [self closeStore:YES];
}

-(void)showStore{
    subTitleLabel.hidden = YES;
    titleLabel.frame = CGRectMake(40, 150, 254, 33);
    [_tableView reloadData];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    self.view.alpha = 1;
    [UIView commitAnimations];
    if([[DataManager sharedInstance].products count] > 0){
        [self didRetrieveProducts:nil];
    }
}

-(void)showStoreNotEnoughChips{
    [self showStore];
    subTitleLabel.hidden = NO;
    titleLabel.frame = CGRectMake(13, 11, 254, 33);
}

-(void)learnMore{
    
    [self closeStore:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@/faq/proChips",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    NSString* escapedUrlString =[urlString stringByAddingPercentEscapesUsingEncoding:
                                 NSUTF8StringEncoding];
    [appDelegate goToWebViewControllerWithURL:escapedUrlString withTitle:@"Pro Chips"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
