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

@implementation RegisterLoginViewController

@synthesize emailAddress;
@synthesize userName;
@synthesize password;
@synthesize registerButton;
@synthesize loginButton;



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
    int y = -30;
    self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(20, 40+y, 280, 30)];
    emailAddress.borderStyle = UITextBorderStyleRoundedRect;
    emailAddress.placeholder = @"email";
    emailAddress.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    emailAddress.spellCheckingType = UITextSpellCheckingTypeNo;
    emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:emailAddress];
    
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 80+y, 280, 30)];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.placeholder = @"userName";
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userName.autocorrectionType = UITextAutocorrectionTypeNo;
    userName.spellCheckingType = UITextSpellCheckingTypeNo;
    [self.view addSubview:userName];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 120+y, 280, 30)];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.placeholder = @"password";
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.spellCheckingType = UITextSpellCheckingTypeNo;
    password.secureTextEntry = YES;
    [self.view addSubview:password];
    
    self.registerButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(20, 160+y, 135, 40);
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.loginButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(160, 160+y, 135, 40);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    switchUser = [[UIActionSheet alloc] initWithTitle:@"Login As:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Jamie",@"Bob",@"Stan",@"Rick",@"Alex",@"Haad",@"Mike",@"Tod", nil];
                         
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    userName.text = [prefs valueForKey:@"userName"];
    password.text = [prefs valueForKey:@"password"];
    [switchUser showInView:self.view];
}

-(void)registerUser{
    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    [registerDict setValue:userName.text forKey:@"userName"];
    [registerDict setValue:emailAddress.text forKey:@"email"];
    [registerDict setValue:password.text forKey:@"password"];
    NSMutableDictionary *results = [[DataManager sharedInstance] registerPlayer:registerDict];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
    }else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet == switchUser){
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
        
        if(buttonIndex == 0){
            [loginDict setValue:@"Jamie" forKey:@"login"];
            [loginDict setValue:@"password11" forKey:@"password"];
        }else if(buttonIndex == 1){
            [loginDict setValue:@"Bob" forKey:@"login"];
            [loginDict setValue:@"password" forKey:@"password"];
        }else if(buttonIndex == 2){
            [loginDict setValue:@"Stan" forKey:@"login"];
            [loginDict setValue:@"password" forKey:@"password"];
        }else if(buttonIndex == 3){
            [loginDict setValue:@"Rick" forKey:@"login"];
            [loginDict setValue:@"password" forKey:@"password"];
        }else if(buttonIndex == 4){
            [loginDict setValue:@"Alex" forKey:@"login"];
            [loginDict setValue:@"password99" forKey:@"password"];
        }else if(buttonIndex == 3){
            [loginDict setValue:@"TheHaad" forKey:@"login"];
            [loginDict setValue:@"password99" forKey:@"password"];
        }else if(buttonIndex == 4){
            [loginDict setValue:@"Mike" forKey:@"login"];
            [loginDict setValue:@"password33" forKey:@"password"];
        }else if(buttonIndex == 7){
            [loginDict setValue:@"Tod" forKey:@"login"];
            [loginDict setValue:@"password" forKey:@"password"];
        }
        NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:loginDict];
        //NSLog(@"sucess:%@",[results objectForKey:@"success"]);
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        }else{
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [errorMessage show];
        }
    }
    
}

-(void)loginUser{
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    [loginDict setValue:userName.text forKey:@"login"];
    //[registerDict setValue:emailAddress.text forKey:@"login"];
    [loginDict setValue:password.text forKey:@"password"];
    NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:loginDict];
    //NSLog(@"sucess:%@",[results objectForKey:@"success"]);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
    }else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
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
