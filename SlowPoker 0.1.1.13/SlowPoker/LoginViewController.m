//
//  LoginViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "MFButton.h"
#import "APIDataManager.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "OAuth.h"
#import "OAuth+DEExtensions.h"
#import "OAuthConsumerCredentials.h"
#import "SocialManager.h"
#import "TwitterDialog.h"

@implementation LoginViewController

@synthesize emailAddress;
@synthesize userName;
@synthesize password;
@synthesize retypePassword;
@synthesize registerButton;
@synthesize loginButton;
@synthesize segmentControl;
@synthesize twitterButton;
@synthesize facebookButton;
@synthesize twitterFacebookInstructions;
@synthesize emailBackground;
@synthesize userNameBackground;
@synthesize passwordBackground;
@synthesize retypepasswordBackground;
@synthesize resetPasswordAlert;



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
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    background.userInteractionEnabled = YES;
    background.frame = CGRectMake(0, -20, 320, [UIImage imageNamed:@"home_background.png"].size.height/2);
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        background.frame = CGRectMake(0, 0, 320, [UIImage imageNamed:@"register_login_background.png"].size.height/2+25);
    }
    [self.view addSubview:background];
    
    

    
    
    int y = +80;

    
    self.emailBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 190+y, 280, 30)];
    emailBackground.image = [UIImage imageNamed:@"text_background.png"];
    emailBackground.userInteractionEnabled = YES;
    [background addSubview:emailBackground];
    
    
    self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(8,3, 266, 23)];
    emailAddress.delegate = self;
    emailAddress.returnKeyType = UIReturnKeyDone;
    emailAddress.borderStyle = UITextBorderStyleNone;
    emailAddress.placeholder = @"Email";
    emailAddress.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    emailAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailAddress.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    emailAddress.spellCheckingType = UITextSpellCheckingTypeNo;
    emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [emailBackground addSubview:emailAddress];
    
    /*
    UILabel *or1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 171, 280, 22)];
    or1.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    or1.backgroundColor = [UIColor clearColor];
    or1.adjustsFontSizeToFitWidth = YES;
    or1.textAlignment = UITextAlignmentCenter;
    or1.minimumFontSize = 8;
    or1.text = @"OR";
    or1.font = [UIFont boldSystemFontOfSize:18];
    [background addSubview:or1];*/
    
    
    
    /*
    self.userNameBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 190+y, 280, 30)];
    userNameBackground.image = [UIImage imageNamed:@"text_background.png"];
    userNameBackground.userInteractionEnabled = YES;
    [background addSubview:userNameBackground];
    
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(8,3, 266, 23)];
    userName.delegate = self;
    userName.returnKeyType = UIReturnKeyDone;
    userName.borderStyle = UITextBorderStyleNone;
    userName.placeholder = @"User Name";
    userName.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userName.autocorrectionType = UITextAutocorrectionTypeNo;
    userName.spellCheckingType = UITextSpellCheckingTypeNo;
    userName.keyboardType = UIKeyboardTypeEmailAddress;
    [userNameBackground addSubview:userName];*/
    
    
    
    
    self.passwordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 240+y-5, 280, 30)];
    passwordBackground.image = [UIImage imageNamed:@"text_background.png"];
    passwordBackground.userInteractionEnabled = YES;
    [background addSubview:passwordBackground];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(8,3, 266, 23)];
    password.secureTextEntry = YES;
    password.delegate = self;
    password.returnKeyType = UIReturnKeyDone;
    password.borderStyle = UITextBorderStyleNone;
    password.placeholder = @"Password";
    password.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.spellCheckingType = UITextSpellCheckingTypeNo;
    password.keyboardType = UIKeyboardTypeEmailAddress;
    [passwordBackground addSubview:password];
    
    /*
    self.retypepasswordBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 275+y, 280, 30)];
    retypepasswordBackground.image = [UIImage imageNamed:@"text_background.png"];
    retypepasswordBackground.userInteractionEnabled = YES;
    [background addSubview:retypepasswordBackground];
    
    self.retypePassword = [[UITextField alloc] initWithFrame:CGRectMake(8,3, 266, 23)];
    retypePassword.borderStyle = UITextBorderStyleNone;
    retypePassword.placeholder = @"Re-type Password";
    retypePassword.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    retypePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    retypePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    retypePassword.autocorrectionType = UITextAutocorrectionTypeNo;
    retypePassword.spellCheckingType = UITextSpellCheckingTypeNo;
    retypePassword.keyboardType = UIKeyboardTypeEmailAddress;
    [retypepasswordBackground addSubview:retypePassword];
    */
    
    MFButton *forgotPasswordButton = [MFButton buttonWithType:UIButtonTypeCustom];
    forgotPasswordButton.frame = CGRectMake(17, 275+90, 135, 40);
    [forgotPasswordButton setImage:[UIImage imageNamed:@"gray_button.png"] forState:UIControlStateNormal];
    //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
    //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
    [forgotPasswordButton addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:forgotPasswordButton];
    
    UILabel *frogotPasswordLabel = [[UILabel alloc] initWithFrame:forgotPasswordButton.bounds];
    frogotPasswordLabel.font = [UIFont boldSystemFontOfSize:13];
    frogotPasswordLabel.textAlignment = UITextAlignmentCenter;
    frogotPasswordLabel.backgroundColor = [UIColor clearColor];
    frogotPasswordLabel.textColor = [UIColor whiteColor];
    frogotPasswordLabel.adjustsFontSizeToFitWidth = YES;
    frogotPasswordLabel.numberOfLines = 2;
    frogotPasswordLabel.minimumFontSize = 12;
    frogotPasswordLabel.text = @"Forgot Password";
    [forgotPasswordButton addSubview:frogotPasswordLabel];
    
       
    
    MFButton *buyGiftMFButton = [MFButton buttonWithType:UIButtonTypeCustom];
    buyGiftMFButton.frame = CGRectMake(165, 275+90, 135, 40);
    [buyGiftMFButton setImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
    //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
    //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
    [buyGiftMFButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:buyGiftMFButton];
    
    buyGiftLabel = [[UILabel alloc] initWithFrame:buyGiftMFButton.bounds];
    buyGiftLabel.font = [UIFont boldSystemFontOfSize:18];
    buyGiftLabel.textAlignment = UITextAlignmentCenter;
    buyGiftLabel.backgroundColor = [UIColor clearColor];
    buyGiftLabel.textColor = [UIColor whiteColor];
    buyGiftLabel.adjustsFontSizeToFitWidth = YES;
    buyGiftLabel.minimumFontSize = 12;
    buyGiftLabel.text = @"Login";
    [buyGiftMFButton addSubview:buyGiftLabel];
    
    
    switchUser = [[UIActionSheet alloc] initWithTitle:@"Login As:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Jamie",@"Bob",@"Stan",@"Rick",@"Alex",@"Haad",@"Mike",@"Tod", nil];
    
    
    
    UILabel *or = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 280, 22)];
    or.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    or.backgroundColor = [UIColor clearColor];
    or.adjustsFontSizeToFitWidth = YES;
    or.textAlignment = UITextAlignmentCenter;
    or.minimumFontSize = 8;
    or.text = @"OR";
    or.font = [UIFont boldSystemFontOfSize:18];
    [background addSubview:or];
    
    
    
    self.twitterFacebookInstructions = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 280, 20)];
    twitterFacebookInstructions.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    twitterFacebookInstructions.backgroundColor = [UIColor clearColor];
    twitterFacebookInstructions.adjustsFontSizeToFitWidth = YES;
    twitterFacebookInstructions.textAlignment = UITextAlignmentCenter;
    twitterFacebookInstructions.minimumFontSize = 8;
    twitterFacebookInstructions.text = @"Login using your Twitter or Facebook accounts";
    twitterFacebookInstructions.font = [UIFont boldSystemFontOfSize:13];
    [background addSubview:twitterFacebookInstructions];
    
    
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterButton.frame = CGRectMake(9, 165, [UIImage imageNamed:@"twitter_button.png"].size.width/2, [UIImage imageNamed:@"twitter_button.png"].size.height/2);
    [twitterButton setImage:[UIImage imageNamed:@"twitter_button.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(twitterLogin) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:twitterButton];
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    facebookButton.frame = CGRectMake(170, 165, [UIImage imageNamed:@"facebook_button.png"].size.width/2, [UIImage imageNamed:@"facebook_button.png"].size.height/2);
    [facebookButton setImage:[UIImage imageNamed:@"facebook_button.png"] forState:UIControlStateNormal];
    [background addSubview:facebookButton];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        background.frame = CGRectMake(0, 0, 320, [UIImage imageNamed:@"register_login_background.png"].size.height/2+25);
    }else{
        background.frame = CGRectMake(0, -20, 320, [UIImage imageNamed:@"home_background.png"].size.height/2);
    }
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [emailAddress resignFirstResponder];
    [userName resignFirstResponder];
    [password resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        background.frame = CGRectMake(0, -200, 320, [UIImage imageNamed:@"register_login_background.png"].size.height/2+25);
    }else{
        background.frame = CGRectMake(0, -230, 320, [UIImage imageNamed:@"home_background.png"].size.height/2);
    }
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [FlurryAnalytics logEvent:@"PAGE_VIEW_LOGIN" timed:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"Login" showLeft:YES showRight:NO];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    emailAddress.text = [prefs valueForKey:@"email"];
    password.text = [prefs valueForKey:@"password"];
    //[switchUser showInView:self.view];
}

-(void)viewWillDisappear:(BOOL)animated{
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_LOGIN" withParameters:nil];
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
    if([userName.text length] == 0){
        [loginDict setValue:emailAddress.text forKey:@"email"];
    }
    
    [loginDict setValue:password.text forKey:@"password"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"facebook_id"];
    //NSLog(@"loginDict:%@",loginDict);
    NSMutableDictionary *results = [[DataManager sharedInstance] loginPlayer:loginDict];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
    }else{
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:[results objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorMessage show];
    }
    
}

-(void)forgotPassword{
    
    UIAlertView *validation = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    if(![self NSStringIsValidEmail:emailAddress.text]){
        validation.title = @"Invalid Email";
        validation.message = @"Please enter a valid email address to reset your password";
        [validation show];
        return;
    }
    
    if(!resetPasswordAlert){
        self.resetPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Reset Password?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    resetPasswordAlert.message = [NSString stringWithFormat:@"Send a new password to %@?",emailAddress.text];
    [resetPasswordAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == resetPasswordAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] resetPassWord:emailAddress.text];
            
            UIAlertView *emailSent = [[UIAlertView alloc] initWithTitle:@"Password Reset Successful" message:@"Please check you email for a new password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emailSent show];
        }
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

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
        [appDel getTwitterUser];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] goToHomViewController:YES];
        
    }
    
}

- (void)twitterDidLogin
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel.twitter saveOAuthContext];
    [appDel getTwitterUser];
    
}

- (void)twitterDidNotLogin:(BOOL)cancelled
{
    
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
