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
#import "OAuth.h"
#import "OAuth+DEExtensions.h"
#import "OAuthConsumerCredentials.h"
#import "SocialManager.h"
#import "TwitterDialog.h"

@implementation RegisterLoginViewController

@synthesize emailAddress;
@synthesize userName;
@synthesize password;
@synthesize registerButton;
@synthesize loginButton;
@synthesize facebookButton;
@synthesize twitterButton;


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
    
    self.facebookButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    facebookButton.frame = CGRectMake(20, 210+y, 135, 40);
    [facebookButton setTitle:@"SignUp Facebook" forState:UIControlStateNormal];
    [self.view addSubview:facebookButton];
    [facebookButton addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    
    self.twitterButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    twitterButton.frame = CGRectMake(160, 210+y, 135, 40);
    [twitterButton setTitle:@"SignUp Twitter" forState:UIControlStateNormal];
    [self.view addSubview:twitterButton];
    [twitterButton addTarget:self action:@selector(twitterLogin) forControlEvents:UIControlEventTouchUpInside];

    
    
    switchUser = [[UIActionSheet alloc] initWithTitle:@"Login As:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Jamie",@"Bob",@"Stan",@"Rick",@"Alex",@"Haad",@"Mike",@"Tod", nil];
                         
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    userName.text = [prefs valueForKey:@"userName"];
    password.text = [prefs valueForKey:@"password"];
    //[switchUser showInView:self.view];
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

-(void)facebookLogin
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (![appDel.facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_about_me", 
                                @"email",
                                nil];
        [appDel.facebook authorize:permissions];
    }
    
}

-(void)getFacebookUser
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    [registerDict setValue:appDel.facebook.accessToken forKey:@"token"];
    
    NSMutableDictionary *results = [[DataManager sharedInstance] registerFacebookPlayer:registerDict];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
    }else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
    
}

#pragma twitter login/registration methods

-(void)twitterLogin
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (![OAuth isTwitterAuthorized])
    {
        
        appDel.twitter = [[OAuth alloc] initWithConsumerKey:kDEConsumerKey andConsumerSecret:kDEConsumerSecret];
        TwitterDialog *td = [[TwitterDialog alloc] init] ;
        td.twitterOAuth = appDel.twitter;
        td.delegate = self;
        td.logindelegate = self;
        [td show];
        
    }
    else
    {
         appDel.twitter = [[OAuth alloc] initWithConsumerKey:kDEConsumerKey andConsumerSecret:kDEConsumerSecret];
        [appDel.twitter loadOAuthContext];
        [self getTwitterUser];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (alertView == emailAlert)
    {
        NSMutableDictionary *emailDict = [[NSMutableDictionary alloc] init];
        [emailDict setValue: [alertView textFieldAtIndex:0].text forKey:@"email"];
        [emailDict setValue: [DataManager sharedInstance].myUserID forKey:@"userID"];
        [emailDict setValue:appDel.twitter.user_id forKey:@"twitter_id"];
        NSMutableDictionary *results = [[DataManager sharedInstance] registerTwitterPlayer:emailDict];
        
        if([@"1" isEqualToString:[results objectForKey:@"success"]]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:appDel.twitter.user_id forKey:@"twitter_id"];
            [defaults synchronize];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        }
        else
        {
            [self askForEmail:[results objectForKey:@"error"]];
        }
    }
    
}

-(void)askForEmail:(NSString *)msg
{
    emailAlert = [[UIAlertView alloc] initWithTitle:@"Email Address" message:msg delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    emailAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [emailAlert show];
}

-(void)getTwitterUser
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
    NSString *twitterID = [NSString stringWithFormat:@"%@",appDel.twitter.user_id];
    [registerDict setValue:twitterID forKey:@"twitter_id"];
    
    NSMutableDictionary *results = [[DataManager sharedInstance] doesTwitterPlayerExist:registerDict];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:appDel.twitter.user_id forKey:@"twitter_id"];
        [defaults synchronize];
    }
    else if([@"2" isEqualToString:[results objectForKey:@"success"]]){
        [self askForEmail:@"Please Enter Your Email Address"];
    }
    else
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
}



#pragma mark TwitterDialog Delegate Methods
- (void)twitterDidLogin
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDel.twitter saveOAuthContext];
    [self getTwitterUser];
    
}

- (void)twitterDidNotLogin:(BOOL)cancelled
{
    
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
