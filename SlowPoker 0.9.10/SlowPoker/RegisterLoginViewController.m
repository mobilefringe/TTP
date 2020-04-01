//
//  RegisterLoginViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterLoginViewController.h"
#import "MFButton.h"
#import "APIDataManager.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@implementation RegisterLoginViewController

@synthesize loginViewController;
@synthesize registerViewController;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Register/Login";
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
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_login_background.png"]];
    background.userInteractionEnabled = YES;
    background.frame = CGRectMake(0, -20, 320, [UIImage imageNamed:@"register_login_background.png"].size.height/2);
    [self.view addSubview:background];
    
    UIButton *loginUser = [UIButton buttonWithType:UIButtonTypeCustom];
    loginUser.frame = CGRectMake(140, 200, [UIImage imageNamed:@"login_button.png"].size.width/2, [UIImage imageNamed:@"login_button.png"].size.height/2);
    [loginUser setImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    [loginUser addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginUser];
    
    UIButton *newUser = [UIButton buttonWithType:UIButtonTypeCustom];
    newUser.frame = CGRectMake(-40, 120, [UIImage imageNamed:@"new_user_button.png"].size.width/2, [UIImage imageNamed:@"new_user_button.png"].size.height/2);
    [newUser addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [newUser setImage:[UIImage imageNamed:@"new_user_button.png"] forState:UIControlStateNormal];
    [self.view addSubview:newUser];
    
        
                         
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"Welcome" showLeft:NO showRight:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
}

-(void)registerUser{
    if(!registerViewController){
        self.registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:registerViewController animated:YES];
}


-(void)loginUser{
    if(!loginViewController){
        self.loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:loginViewController animated:YES];
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
