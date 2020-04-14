//
//  AchievementsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementsViewController.h"
#import "DataManager.h"
#import "AchievementsTableViewCell.h"
#import "AchievementHeaderView.h"
#import "CellFooterGeneral.h"

@interface AchievementsViewController ()

@end

@implementation AchievementsViewController

@synthesize _tableView;
@synthesize  scrollToSection;

@synthesize achievementPlatinumHeaderView;
@synthesize achievementGoldView;
@synthesize achievementSilverHeaderView;
@synthesize achievementBronzeHeaderView;
@synthesize achievementBlackHeaderView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bracelets";
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"addAchievement" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    float widthScreen = self.view.bounds.size.width;
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    float achievementWidth = widthScreen;
    self.achievementPlatinumHeaderView = [[AchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, achievementWidth, 106)];
    self.achievementGoldView = [[AchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, achievementWidth, 106)];
    self.achievementSilverHeaderView = [[AchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, achievementWidth, 106)];
    self.achievementBronzeHeaderView = [[AchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, achievementWidth, 106)];
    self.achievementBlackHeaderView = [[AchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, achievementWidth, 106)];
}

-(void)viewWillAppear:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:scrollToSection ];
    [_tableView reloadData];
    [self._tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView flashScrollIndicators];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"addAchievement"]){
        [_tableView reloadData];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
    static NSString *MyIdentifier = @"PlayerProfileTableViewCell";
    AchievementsTableViewCell *cell = (AchievementsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    // If no cell is available, create a new one using the given identifier
    if (cell == nil) {
        cell = [[AchievementsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    NSMutableArray *gameAchievements;
    NSMutableArray *rowAchievements = [[NSMutableArray alloc] init];
    if(indexPath.section == 0){
        gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"PLATINUM"];
    }else if(indexPath.section == 1){
        gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"GOLD"];
    }else if(indexPath.section == 2){
        gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"SILVER"];
    }else if(indexPath.section == 3){
        gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"BRONZE"];
    }else if(indexPath.section == 4){
        gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"BLACK"];
    }
    
    int startingIndex = indexPath.row*4 + 1;
    int endingIndex = startingIndex;
    
    for(int i = 0; i < 4;i++){
        
        if(([gameAchievements count] - 1) >= startingIndex+i){
            endingIndex++;
        }
    }
    
    for (int i=startingIndex; i < endingIndex; i++) {
        [rowAchievements addObject:[gameAchievements objectAtIndex:i]];
    }
    [cell setAchievementData:rowAchievements];
    //cell.textLabel.text = @"Stat Name";
    //cell.detailTextLabel.text = @"Stat Type";
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"PLATINUM_BRACELET" category:@"PLATINUM"];
        [achievementPlatinumHeaderView setGameAchievement:gameAchievement];
        return achievementPlatinumHeaderView;
    }else if(section == 1){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GOLD_BRACELET" category:@"GOLD"];
        [achievementGoldView setGameAchievement:gameAchievement];
        return achievementGoldView;
    }else if(section == 2){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"SILVER_BRACELET" category:@"SILVER"];
        [achievementSilverHeaderView setGameAchievement:gameAchievement];
        return achievementSilverHeaderView;
    }else if(section == 3){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BRONZE_BRACELET" category:@"BRONZE"];
        [achievementBronzeHeaderView setGameAchievement:gameAchievement];
        return achievementBronzeHeaderView;
    }else if(section == 4){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BLACK_BRACELET" category:@"BLACK"];
        [achievementBlackHeaderView setGameAchievement:gameAchievement];
        return achievementBlackHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int achievementsPerRow = 4;
    if(section == 0){
        NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"PLATINUM"];
        int rowCount = ([gameAchievements count]-1)/achievementsPerRow;
        if(([gameAchievements count]-1)%achievementsPerRow > 0){
            rowCount++;
        }
        return rowCount;
    }else if(section == 1){
        NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"GOLD"];
        int rowCount = ([gameAchievements count]-1)/achievementsPerRow;
        if(([gameAchievements count]-1)%achievementsPerRow > 0){
            rowCount++;
        }
        return rowCount;
    }else if(section == 2){
        NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"SILVER"];
        int rowCount = ([gameAchievements count]-1)/achievementsPerRow;
        if(([gameAchievements count]-1)%achievementsPerRow > 0){
            rowCount++;
        }
        return rowCount;
    }else if(section == 3){
        NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"BRONZE"];
        int rowCount = ([gameAchievements count]-1)/achievementsPerRow;
        if(([gameAchievements count]-1)%achievementsPerRow > 0){
            rowCount++;
        }
        return rowCount;
    }else if(section == 4){
        NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:@"BLACK"];
        int rowCount = ([gameAchievements count]-1)/achievementsPerRow;
        if(([gameAchievements count]-1)%achievementsPerRow > 0){
            rowCount++;
        }
        return rowCount;
    }
    return 1;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    float widthScreen = self.view.bounds.size.width;
    if(section == 0){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 40) title:@"Collect each to unlock the Platinum bracelet"];
        return footer;
    }else if(section == 1){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 40) title:@"Collect each to unlock the Gold bracelet"];
        return footer;        
        
    }else if(section == 2){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 40) title:@"Collect each to unlock the Silver bracelet"];
        return footer;        
        
    }else if(section == 3){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 40) title:@"Collect each to unlock the Bronze bracelet"];
        return footer;        
        
    }else if(section == 4){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 40) title:@"Collect each to unlock the Black bracelet"];
        return footer;        
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
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
