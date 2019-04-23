//
//  CardsSelectorViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardsSelectorViewController.h"
#import "DataManager.h"
#import "CardButton.h"

@implementation CardsSelectorViewController

@synthesize cards;
@synthesize deck;
@synthesize scrollView;
@synthesize numOfCards;
@synthesize maxCards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Cards";
        
        self.deck = [[NSMutableArray alloc] initWithCapacity:52];
        [deck addObject:@"2C"];
        [deck addObject:@"2D"];
        [deck addObject:@"2H"];
        [deck addObject:@"2S"];
        [deck addObject:@"3C"];
        [deck addObject:@"3D"];
        [deck addObject:@"3H"];
        [deck addObject:@"3S"];
        [deck addObject:@"4C"];
        [deck addObject:@"4D"];
        [deck addObject:@"4H"];
        [deck addObject:@"4S"];
        [deck addObject:@"5C"];
        [deck addObject:@"5D"];
        [deck addObject:@"5H"];
        [deck addObject:@"5S"];
        [deck addObject:@"6C"];
        [deck addObject:@"6D"];
        [deck addObject:@"6H"];
        [deck addObject:@"6S"];
        [deck addObject:@"7C"];
        [deck addObject:@"7D"];
        [deck addObject:@"7H"];
        [deck addObject:@"7S"];
        [deck addObject:@"8C"];
        [deck addObject:@"8D"];
        [deck addObject:@"8H"];
        [deck addObject:@"8S"];
        [deck addObject:@"9C"];
        [deck addObject:@"9D"];
        [deck addObject:@"9H"];
        [deck addObject:@"9S"];
        [deck addObject:@"TC"];
        [deck addObject:@"TD"];
        [deck addObject:@"TH"];
        [deck addObject:@"TS"];
        [deck addObject:@"JC"];
        [deck addObject:@"JD"];
        [deck addObject:@"JH"];
        [deck addObject:@"JS"];
        [deck addObject:@"QC"];
        [deck addObject:@"QD"];
        [deck addObject:@"QH"];
        [deck addObject:@"QS"];
        [deck addObject:@"KC"];
        [deck addObject:@"KD"];
        [deck addObject:@"KH"];
        [deck addObject:@"KS"];
        [deck addObject:@"AC"];
        [deck addObject:@"AD"];
        [deck addObject:@"AH"];
        [deck addObject:@"AS"];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[deck count]];
        NSEnumerator *enumerator = [deck reverseObjectEnumerator];
        for (id element in enumerator) {
            [array addObject:element];
        }
        self.deck = array;
        
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    scrollView.contentSize = CGSizeMake(320, 1100);
    [self.view addSubview:scrollView];
    
    int x = 28;
    int y = 10;
    int index = 1;
    for(NSString *aKey in deck ){
        if(![@"?" isEqualToString:aKey]){
            CardButton *cardButton = [[CardButton alloc] initWithFrame:CGRectMake(x, y, 50, 60)];
            cardButton.cardValue = aKey;
            [cardButton setImage:[[DataManager sharedInstance].cardImages valueForKey:aKey] forState:UIControlStateNormal];
            [scrollView addSubview:cardButton];
            [cardButton addObserver:self forKeyPath:@"cardSelected" options:NSKeyValueObservingOptionOld context:nil];
            
            
            x = x + 70;
            if(index%4==0){
                x=28;
                y=y+80;
            }
            index++;
        
        }
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(resetCards)];
    self.navigationItem.rightBarButtonItem = barButton;

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(numOfCards < maxCards){
        NSString *cardStr = [(CardButton *)object cardValue];
        [(CardButton *)object setEnabled:NO];
        [self.cards addObject:cardStr];
        numOfCards++;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self resetCards];
}

-(void)resetCards{
    numOfCards = 0;
    [self.cards removeAllObjects];
    NSArray *cardButtons = scrollView.subviews;
    for (UIButton *cardButton in cardButtons) {
        [cardButton setEnabled:YES];
    }
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
