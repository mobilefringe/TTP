//
//  PlayerProfileViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import "DataManager.h"
#import "APIDataManager.h"
#import "Avatar.h"
#import "PlayerProfileTableViewCell.h"
#import "PlayerStatsTableViewCell.h"
#import "PlayerBraceletsTableViewCell.h"
#import "PlayerStatsViewController.h"
#import "Utils.h"
#import "AchievementsViewController.h"
#import "Settings.h"
#import "AppDelegate.h"
#import "CellHeaderGeneral.h"
#import "CellFooterGeneral.h"



@implementation PlayerProfileViewController

@synthesize userID;
@synthesize activityIndicatorView;
@synthesize avatar;
@synthesize userNameLabel;
@synthesize changeAvatarButton;
@synthesize tapToUpload;
@synthesize _tableView;
@synthesize playerStatsViewController;
@synthesize needsReload;
@synthesize achievementsViewController;
@synthesize footerView1;
@synthesize footerView2;
@synthesize footerView3;
@synthesize favoritesButton;
@synthesize favoritesImageSelected;
@synthesize favoritesImageUnSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Profile";
       [[DataManager sharedInstance] addObserver:self forKeyPath:@"playerProfileLoaded" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    
    int marginLeft = 20;
    int buttonWidth = self.view.bounds.size.width - (marginLeft*2);
    int bottomPadding = 64;
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.height, self.view.bounds.size.height-bottomPadding);
    [self.view addSubview:_tableView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicatorView.frame = CGRectMake((self.view.bounds.size.width-20)/2, (self.view.bounds.size.height-20)/2, 20, 20);
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self.view addSubview:activityIndicatorView];
    
   imagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload a photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    
    self.footerView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 15)];
    footerView1.textAlignment = UITextAlignmentCenter;
    footerView1.textColor = [UIColor darkGrayColor];
    footerView1.font = [UIFont systemFontOfSize:12];
    footerView1.backgroundColor = [UIColor clearColor];
    
    self.footerView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 15)];
    footerView2.textAlignment = UITextAlignmentCenter;
    footerView2.textColor = [UIColor darkGrayColor];
    footerView2.font = [UIFont systemFontOfSize:12];
    footerView2.backgroundColor = [UIColor clearColor];
    
    self.footerView3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 15)];
    footerView3.textAlignment = UITextAlignmentCenter;
    footerView3.textColor = [UIColor darkGrayColor];
    footerView3.font = [UIFont systemFontOfSize:12];
    footerView3.backgroundColor = [UIColor clearColor];
    
    favouritesMessageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favourites_message.png"]];
	favouritesMessageImage.frame = CGRectMake(0, -50, self.view.bounds.size.width, 50);
	favouritesMessageImage.alpha = 0.95;
	favouritesMessageLabel = [[UILabel alloc] initWithFrame:favouritesMessageImage.bounds];
	favouritesMessageLabel.textColor = [UIColor whiteColor];
	favouritesMessageLabel.backgroundColor = [UIColor clearColor];
	favouritesMessageLabel.textAlignment = UITextAlignmentCenter;
	favouritesMessageLabel.font = [UIFont boldSystemFontOfSize:18];
	[favouritesMessageImage addSubview:favouritesMessageLabel];
	[self.view addSubview:favouritesMessageImage];
    
    self.favoritesImageSelected = [UIImage imageNamed:@"heart_store.png"];
	self.favoritesImageUnSelected = [UIImage imageNamed:@"heart_unselected.png"];
    
    self.favoritesButton = [[UIBarButtonItem alloc] initWithImage:favoritesImageUnSelected style:UIBarButtonItemStylePlain target:self action:@selector(pressFavorites)];
	self.navigationItem.rightBarButtonItem = favoritesButton;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(needsReload){
        [activityIndicatorView startAnimating];
        _tableView.alpha = 0;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"Player Profile"];
    
    if([Settings isFavoritePlayer:userID]){
        self.favoritesButton.image = self.favoritesImageSelected;
    }else{
        self.favoritesButton.image = self.favoritesImageUnSelected;
    }
    
    if([userID isEqualToString:[DataManager sharedInstance].myUserID]){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = favoritesButton;
    }
    if(needsReload){
        [[DataManager sharedInstance] loadPlayerProfile:userID];
        [_tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeImage];
}

-(void)pressFavorites{
	if([Settings isFavoritePlayer:userID]){
		[Settings removeFavoritePlayerID:userID];
		favouritesMessageLabel.text =@"Removed as Friend";
		self.favoritesButton.image = self.favoritesImageUnSelected;
	}else{
		favouritesMessageLabel.text =@"Added As Friend";
		self.favoritesButton.image = self.favoritesImageSelected;
		[Settings addFavoritePlayerID:userID];
	}
	[[DataManager sharedInstance] arrangeFavsAndRecents];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate: self ];
	[UIView setAnimationDidStopSelector:@selector(hideFavouritesMessage)];
	[UIView setAnimationDuration:0.2];
	favouritesMessageImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
	[UIView commitAnimations];
	
	
}

-(void)hideFavouritesMessage{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:1];
	[UIView setAnimationDuration:0.2];
	favouritesMessageImage.frame = CGRectMake(0, -50, self.view.bounds.size.width, 50);
	[UIView commitAnimations];
	
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"playerProfileLoaded"]){
        //NSLog(@"playerProfile:%@",[DataManager sharedInstance].playerProfile);
        [activityIndicatorView stopAnimating];
        //NSLog(@"playerProfile:%@",[DataManager sharedInstance].playerProfile);
        if([[[DataManager sharedInstance].playerProfile valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            self.title = @"My Profile";
        }else{
            self.title = @"Profile";
        }
        [_tableView reloadData];
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        _tableView.alpha = 1;
        [UIView commitAnimations];
        needsReload = NO;
    }
}


-(void)showImagePicker{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
		[imagePickerType showInView:self.view];
	}
	else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];

    }else if(buttonIndex == 1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];

    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Code here to work with media
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [[APIDataManager sharedInstance] postPlayerAvatar:userID img:image];
    NSMutableDictionary *earnedAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"UPLOAD_AVATAR" category:@"BLACK"];
    if(![[DataManager sharedInstance] currentUserHasAchievement:earnedAchievement]){
        [[DataManager sharedInstance] incrementAchievement:earnedAchievement forUser:[DataManager sharedInstance] .myUserID];
    }
    [[DataManager sharedInstance].avatars removeAllObjects];
    [self._tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
    
    if(indexPath.section == 0){
        static NSString *MyIdentifier = @"PlayerProfileTableViewCell";
        PlayerProfileTableViewCell *cell = (PlayerProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[PlayerProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        }
        [cell setProfileData:[DataManager sharedInstance].playerProfile isFriend:[Settings isFavoritePlayer:userID]];
        if([[[DataManager sharedInstance].playerProfile valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else if(indexPath.section == 1){
        static NSString *MyIdentifier = @"PlayerBraceletsTableViewCell";
        PlayerBraceletsTableViewCell *cell = (PlayerBraceletsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[PlayerBraceletsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        }
        
        
        //double cellAlpha = 0.8;
        //cell.categoryLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        if(indexPath.row == 0){
            
            [cell setBraceletData:[DataManager sharedInstance].playerProfile category:@"PLATINUM"];
            //cell.categoryLabel.backgroundColor = [[Utils sharedInstance] colorWithHexString:@"E5E4E2" alpha:cellAlpha];
        }else if(indexPath.row == 1){
            //cell.categoryLabel.backgroundColor = [[Utils sharedInstance] colorWithHexString:@"FFD700" alpha:cellAlpha];
            [cell setBraceletData:[DataManager sharedInstance].playerProfile category:@"GOLD"];
        }else if(indexPath.row == 2){
            //cell.categoryLabel.textColor = [UIColor whiteColor];
            [cell setBraceletData:[DataManager sharedInstance].playerProfile category:@"SILVER"];
            //cell.categoryLabel.backgroundColor = [[Utils sharedInstance] colorWithHexString:@"C0C0C0" alpha:cellAlpha];
        }else if(indexPath.row == 3){
            //cell.categoryLabel.textColor = [UIColor whiteColor];
            [cell setBraceletData:[DataManager sharedInstance].playerProfile category:@"BRONZE"];
            //cell.categoryLabel.backgroundColor = [[Utils sharedInstance] colorWithHexString:@"CD7F32" alpha:cellAlpha];
        }else if(indexPath.row == 4){
            //cell.categoryLabel.textColor = [UIColor whiteColor];
            [cell setBraceletData:[DataManager sharedInstance].playerProfile category:@"BLACK"];
            //cell.categoryLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:cellAlpha];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 85;
    }else if(indexPath.section == 1){
        return 85;
    }
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 30;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Poker Bracelets"];
        return header;
    }
    return nil;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 40) title:@"Press for all bracelets"];
        return header;
    }
    return nil;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 40;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Player Stats";
    }else if(section == 2){
        return @"Poker Bracelets";
    }
    return nil;
}*/





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }if(section == 1){
        return 5;
    }
    return 0;
    
}

-(void)removeImage {
    
    UIImageView *imgView = (UIImageView*)[self.view viewWithTag:100];
    UIButton *btnClose = (UIButton*)[self.view viewWithTag:101];
    if (imgView){
        [UIView animateWithDuration:0.25 animations:^{
            imgView.alpha = 0;
            [imgView removeFromSuperview];
            [btnClose removeFromSuperview];
        }];
        self.navigationController.navigationBar.hidden = NO;
    }
}

-(void)addImageViewWithImage:(UIImage*)image {
    self.navigationController.navigationBar.hidden = YES;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor blackColor];
    imgView.image = image;
    imgView.tag = 100;
    imgView.alpha = 0;
    [imgView setUserInteractionEnabled:YES];

    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnClose.frame = CGRectMake(self.view.bounds.size.width - 60, 20, 50, 50 );
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.tag = 101;
    [btnClose setTitle:@"x" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont boldSystemFontOfSize:35];

    [btnClose addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imgView];
    [self.view addSubview: btnClose];
    
    [UIView animateWithDuration:0.25 animations:^{
        imgView.alpha = 1;
    }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if([[[DataManager sharedInstance].playerProfile valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            [self showImagePicker];
        }else{
            PlayerProfileTableViewCell *cell = (PlayerProfileTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self addImageViewWithImage:cell.avatarWithoutRadius.imageView.image];
        }
        
        
    }else if(indexPath.section == 1){
        if(!achievementsViewController){
            self.achievementsViewController = [[AchievementsViewController alloc] initWithNibName:nil bundle:nil];
        }
        achievementsViewController.scrollToSection = indexPath.row;
        [self.navigationController pushViewController:achievementsViewController animated:YES];
    }
    
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
