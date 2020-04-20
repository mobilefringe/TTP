//
//  SocialManager.m
//  SlowPoker
//
//  Created by Fahad Muntaz on 12-05-08.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import "APIDataManager.h"
#import "DataManager.h"

@implementation SocialManager

-(id)init {
//    self = [super init];
//	if (self != nil) {
//        //do custom init here
//        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    }
    
//    return self;
}

#pragma mark Facebook Request/Post Methods

// getFacebookProfile
// retrieves Facebook Profile of Logged in User
-(void)getFacebookProfile
{
    
}

// getFacebookFriends
// retrieves json list of Facebook friend's
// data only has Facebook Id's
-(void)getFacebookFriends
{
    
}

// inviteFacebookFriends
// Dialog to invite Facebook Friends to Slow Poker
-(void)inviteFacebookFriends
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"You need to play Slow Poker with me!",  @"message",
                                   nil];
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


+ (SocialManager *)sharedInstance {
    
//    static dispatch_once_t pred = 0;
//    __strong static id _sharedObject = nil;
//    dispatch_once(&pred, ^{
//        _sharedObject = [[self alloc] init];// or some other init method
//    });
//    return _sharedObject;

}

@end
