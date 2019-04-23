//
//  SocialManager.m
//  SlowPoker
//
//  Created by Fahad Muntaz on 12-05-08.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import "SocialManager.h"
#import "DETweetComposeViewController.h"

@implementation SocialManager
@synthesize appDelegate;
@synthesize fbookprofile,fbookfriends;
-(id)init {
    self = [super init];
	if (self != nil) {
        //do custom init here
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

#pragma mark Facebook Request/Post Methods

// getFacebookProfile
// retrieves Facebook Profile of Logged in User
-(void)getFacebookProfile
{
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
}

// getFacebookFriends
// retrieves json list of Facebook friend's
// data only has Facebook Id's
-(void)getFacebookFriends
{
    [appDelegate.facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

// inviteFacebookFriends
// Dialog to invite Facebook Friends to Slow Poker
-(void)inviteFacebookFriends
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"You need to play Slow Poker with me!",  @"message",
                                   nil];
    
    [appDelegate.facebook dialog:@"apprequests"
           andParams:params
         andDelegate:self];
}

// shareFacebook
// required: NSMutableDictionary *params
// This method takes a set of Facebook parameters for a feed post
// and posts it to the user's facebook wall
// example dictionary:
/* NSMutableDictionary *params = 
   [NSMutableDictionary dictionaryWithObjectsAndKeys:
   @"Check Out Slow Poker", @"name",
   @"Slow Poker.", @"caption",
   @"Check out how to use Facebook Dialogs.", @"description",
   @"http://www.example.com/", @"link",
   @"http://fbrell.com/f8.jpg", @"picture",
   nil];
*/


-(void)shareFacebook:(NSMutableDictionary *)params
{
    [appDelegate.facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}

#pragma mark FBRequest Delegate Methods
- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    /* handle user request in here */
    NSError *error;
    NSData *jsonData = [request responseText];
    NSMutableDictionary *json = [NSJSONSerialization 
                                 JSONObjectWithData:jsonData
                                 options:NSJSONReadingMutableContainers 
                                 error:&error];
    if (error == nil)
    {
        //handling a user info request, for example
        if ([[request url] rangeOfString:@"/me"].location != NSNotFound)
        {
            self.fbookprofile = json;
        }
        else if ([[request url] rangeOfString:@"/me/friends"].location != NSNotFound)
        {
            self.fbookfriends = json;
        }
    }
    else
    {
        NSLog(@"Facebook Request JSON Error::: %@", error);
    }

}

#pragma mark FBDialogDelegate Methods
- (void)dialogDidComplete:(FBDialog *)dialog {
    
    //NSLog(@"dialog completed successfully");
}

#pragma mark Twitter
// shareTwitter
// required: UIViewController usingController
// Presents a Twitter form to share text to twitter
-(void)shareTwitter:(UIViewController*)usingController {
    DETweetComposeViewController *tcvc = [[DETweetComposeViewController alloc] init];
    [tcvc addURL:[NSURL URLWithString:@"http://www.mobilefringe.com/"]];
    [tcvc addURL:[NSURL URLWithString:@"http://www.apple.com/ios/features.html#twitter"]];
    
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [usingController presentModalViewController:tcvc animated:YES];
}


+ (SocialManager *)sharedInstance {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];// or some other init method
    });
    return _sharedObject;

}

@end
