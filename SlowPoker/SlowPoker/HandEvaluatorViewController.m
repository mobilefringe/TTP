//
//  HandEvaluatorViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandEvaluatorViewController.h"
#import "CardsSelectorViewController.h"
#import "HandTableCell.h"
#import "Hand.h"

@implementation HandEvaluatorViewController

@synthesize _tableView;
@synthesize communityCards;
@synthesize hands;
@synthesize cardsSelectorViewController;
@synthesize fullHands;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Hand Eval";
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)resetHands{
    self.hands = [[NSMutableArray alloc] init];
    self.communityCards = [[NSMutableArray alloc] init];
    self.fullHands =  [[NSMutableArray alloc] init];
}



-(void)loadView{
    [super loadView];
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Hand"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(addHand)];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
    
    
    [fullHands removeAllObjects];
    highHandValue = 0;
    for (NSMutableArray *hand in hands) {
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        [cards addObjectsFromArray:hand];
        [cards addObjectsFromArray:communityCards];
        Hand *hand = [[Hand alloc] initWithCards:cards];
        if(hand.value > highHandValue){
            highHandValue = hand.value;
        }
        [fullHands addObject:hand];
        [hand logHand];
    }
    [self addHand];
}

-(void)addHand{
    [self.hands addObject:[[NSMutableArray alloc] init]];
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	HandTableCell *cell = (HandTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[HandTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
	}
    
    NSMutableArray *cards;
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.section == 0){
        cards = communityCards;
        [cell setCards:cards hand:nil];
    }else{
        cards = [hands objectAtIndex:indexPath.row];
        if(fullHands.count > indexPath.row){
            Hand *hand = (Hand *)[fullHands objectAtIndex:indexPath.row];
            if(highHandValue == hand.value){
                cell.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0.5 alpha:1];
            }
            [cell setCards:cards hand:hand];
        }else{
            [cell setCards:cards hand:nil];
        }
    }
    
   
    if([cards count] == 0){
        cell.textLabel.text = @"No Cards";
        cell.detailTextLabel.text = @"Press to select cards";
    }else{
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Community Cards";
    }
    
    return @"Hands";
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    return [hands count];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!cardsSelectorViewController){
        self.cardsSelectorViewController = [[CardsSelectorViewController alloc] initWithNibName:nil bundle:nil];
    }
    if(indexPath.section == 0){
        cardsSelectorViewController.maxCards = 5;
        cardsSelectorViewController.cards = self.communityCards;
    }else{
        if(![hands objectAtIndex:indexPath.row]){
            [hands insertObject:[[NSMutableArray alloc] init] atIndex:indexPath.row];
        }
        cardsSelectorViewController.maxCards = 2;
        cardsSelectorViewController.cards = [hands objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:cardsSelectorViewController animated:YES];
    return nil;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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
