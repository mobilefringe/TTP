//
//  APIDataManager.m
//  
//
//  Created by Fahad Muntaz on 12-03-26.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import "APIDataManager.h"
#import "Base64.h"
#import "Reachability.h"

@implementation APIDataManager

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#pragma mark Instructions
/* --- Required Information for use of API ---
   # apiURL - Info.plist must have a value called "apiURL", which has the address of the API Server
*/
 
#pragma mark PlayerAPI

/* registerPlayer - registers a new Player on the Server
   required: username, email, password
   sample data:{\"username\":\"User\",\"email\":\"user@mail.com\",\"password\":\"1234567\"}" */

-(id)registerPlayer:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/registerPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}


/* resetPlayerPassword - resets a player's password
 required: email
 */
-(id)resetPlayerPassword:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/resetPlayerPassword",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* checkUsername - determines if a username is unique
   required: username
   sample: {\"username\":\"TheHaad\"} */

-(id)checkUsername:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/checkUsername",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
        
    return [self requestAPIData:jsonData url:urlAddress];
}

/* checkEmail - determines if an email is unique
 required: email
 sample: {\"email\":\"TheHaad@mail.com\"} */

-(id)checkEmail:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/checkEmail",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* loginPlayer - validates Player Credentials
 required: login, password
 sample: {\"login\":\"TheHaad@mail.com\",\"password\":\"1234567\"}  or 
         {\"login\":\"TheHaad\",\"password\":\"1234567\"} */

-(id)loginPlayer:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/loginPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}


/*loginGamePlayer
 requires facebook_id or twitter_id or email && password
 */
-(id)loginGamePlayer:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/loginGamePlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* searchForUser - determines if user exists
 required: login, password
 sample: {\"login\":\"TheHaad@mail.com\"}  or 
 {\"login\":\"TheHaad\"} */

-(id)searchForUser:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/searchForUser",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}
#pragma mark Game API

/* createGame - creates a new game on the server 
   required: nextActionForUserID, lastActionMessage, status, gameOwnerID, 
             gameSetting, gameState, idleTime
   optional: turnState */

-(id)createGame:(NSString*)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/createGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    //NSLog(@"createGame:%@",jsonData);
    return [self requestAPIData:jsonData url:urlAddress];

}

/* updateGame - updates a game on the server 
   required: gameID, nextActionForUserID, lastActionMessage, status, gameOwnerID, 
   gameSetting, gameState, idleTime, turnState */

-(id)updateGame:(NSString*)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updateGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}

/* joinGame - invites/creates a new game of poker for Player
 required: userID, category
 category can be one of the following values: cash, tournament, either
 returns playerGames json
 */

-(id)joinGame:(NSString *)jsonData
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/joinGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}

/* getPlayerGames - retrieve all games belonging to Player
   required: userID */

-(id)getPlayerGames:(NSString*)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getPlayerGames",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}

/* getGame - get specific data for specific game
   required: gameID */

-(id)getGame:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* addPlayerToGame - add a Player to a Game
   required: userID, gameID, status, order, playerState */

-(id)addPlayerToGame:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/addPlayerToGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* updatePlayerToGame - update player status in a game
   required: userID, gameID, status, order, playerState */

-(id)updatePlayerToGame:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updatePlayerToGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];

}

-(id)updatePlayerFriends:(NSString*)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updatePlayerFriends",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    return [self requestAPIData:jsonData url:urlAddress];
}

/* registeriDevice - registers iPhone Device Token for Push Notifications 
 required: userID, deviceToken */

-(id)registeriDevice:(NSString*)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/registeriDevice",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* sendNotification - sends notifications to list of players
 required: players (array of players with userID}, message, payload
 example:"{\"players\":[{\"userID\":\"2\"}],\"message\":\"Hello Kin!!!\",\"payLoad\":{\"TestValue\":\"TestValue\"}}" */

-(id)sendNotification:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/sendNotification",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* postMessage - add's a Players Message to the Messaging Server
 required: userID, recipients,gameID,message 
 example: "{\"userID\":\"1\",\"gameID\":\"1\",\"message\":\"Yo Yo Yo\",\"recipients\" : [{\"userID\":\"2\"},{\"userID\":\"3\"}]}"*/

-(id)postMessge:(NSString*)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/postMessage",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* getLastMessage - retrieves undelieverd messages for a specific Player & Game
 required: userID,gameID */

-(id)getLastMessage:(NSString*)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getLastMessage",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* getPlayerProfile - retrieve profile belonging to Player
 required: userID */
-(id)getPlayerProfile:(NSString*)jsonData
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getPlayerProfile",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* getPlayerStatuses
 required: array of user ids
 ex. @"[10,6]"
 */
-(NSDictionary*)getPlayerStatuses:(NSString *)jsonData
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getPlayerStatuses",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}

/* updatePlayerInventory - update Player's Inventory json
 required: userID, inventory */
-(id)updatePlayerInventory:(NSString*)jsonData
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updatePlayerInventory",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}

/* postAchievements - post achievements for specific Player
 required: userID, achievements array 
 sample: "{\"userID\":\"10\",\"achievements\" : [{\"code\":\"G_C_1\",\"category\":\"Gold\",\"countInc\":\"1\",\"currencyInc\":\"2\"},{\"code\":\"G_C_2\",\"category\":\"Gold\",\"countInc\":\"2\",\"currencyInc\":\"3\"}]}
 */

-(id)postAchievements:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/postAchievements",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}


/* getAchievements - get achivements for different players
 required: userID
 example json: ["10,"6"]
 */
-(id)getAchievements:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getAchievements",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* getFacbeookFriends- gets a list of registered players that are associated with specific facebook id's
 required: facebook id arra
 ex.[{\"id\":\"628280507\",\"name\":\"Vince Polsinelli\"},{\"id\":\"100003617059448\",\"name\":\"Alex Tang\"}]
 */
-(id)getFacebookFriends:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getFacebookFriends",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* postPlayerAvatar - upload avatar image for Player
 required: userID, UIImageView
 */
-(id)postPlayerAvatar:(NSString*)userID img:(UIImage*)imgToUpload
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/postPlayerAvatar",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    UIImage *uploadImage;
    
    if(imgToUpload.size.width < imgToUpload.size.height)
        uploadImage = [self rotate:UIImageOrientationRight img:imgToUpload];
    else
        uploadImage = imgToUpload;
    
    NSData *imageData   = UIImageJPEGRepresentation(uploadImage, 0.01);
    
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:userID forKey:@"userID"];
    [userDict setValue:[Base64 encode:imageData] forKey:@"avatardata"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [self requestAPIData:jsonString url:urlAddress];
}

//Image Rotation Code Found Here:
//http://www.platinumball.net/blog/2010/01/31/iphone-uiimage-rotation-and-scaling/

static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}

-(UIImage*)rotate:(UIImageOrientation)orient img:(UIImage*)imgToUpload
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = imgToUpload.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
	
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
			// would get you an exact copy of the original
			assert(false);
			return nil;
			
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
			
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
        case UIImageOrientationLeft:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationRight:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        case UIImageOrientationRightMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

-(id)uploadImage:(UIImageView*)imgToUpload
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/uploadImage",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    UIImage *uploadImage;
    
    if(imgToUpload.image.size.width < imgToUpload.image.size.height)
        uploadImage = [self rotate:UIImageOrientationRight img:imgToUpload];
    else
        uploadImage = imgToUpload.image;
    
    NSData *imageData   = UIImageJPEGRepresentation(uploadImage, 0.01);
    
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:[Base64 encode:imageData] forKey:@"imagedata"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [self requestAPIData:jsonString url:urlAddress];
}

/* getImage - get image data for specified imageIDs
 required:imageID
 */
-(id)getImage:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getImage",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* postInventory - post Inventory for Player
 required: userID, inventory array
 example:"{\"userID\":\"10\",\"inventory\" : [{\"category\":\"Gold\",\"value\":\"1\"},{\"category\":\"Gold\",\"value\":\"2\"}]}"
 */
-(id)postInventory:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/postInventory",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* getInventory - get Inventory for Player
 required: userID
 */
-(id)getInventory:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/getInventory",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

/* postGiftForUser - update A Player's Gift for a specific Game
 required: userID, gameID, gift json blob
 example: @"[{\"userID\":\"10\",\"gameID\":\"139\",\"gift\":{\"agift\":\"teddybear\"}}]"
 */
-(id)postGiftForUser:(NSString *)jsonData
{
    NSString *urlAddress = [NSString stringWithFormat:@"%@/postGiftForUser",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
    
}


#pragma mark Connection

-(id)requestAPIData:(NSString *)json url:(NSString*)postUrl
{
    
    
    if(![self reachable]){
        UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"Please make sure you are connected to the internet to access TTP" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [noInternet show];
        return nil;
    }
    
    NSData *postData = [json dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSURL *url = [NSURL URLWithString:postUrl];    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:180.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%d", [postData length]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    
    NSURLResponse *response;
    NSError *error;
    
    //NSLog(@"request data from %@: %@:",postUrl,json);
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request 
                                            returningResponse:&response error:&error];
    
    
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"response data from: %@:%@",postUrl,jsonString);
    
    //NSMutableDictionary *jsonDictionary;
    if(error == nil) {
        
        return [NSJSONSerialization 
                          JSONObjectWithData:jsonData
                          options:NSJSONReadingMutableContainers 
                          error:&error];
    }else{
//        NSLog(@"requestAPIData error:%@",error);
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"There is a network error" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alertView show];
        return nil;
        
    }
}

-(id)registerFacebookPlayer:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/registerFacebookPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

-(id)registerTwitterPlayer:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/registerTwitterPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

-(id)doesTwitterPlayerExist:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/doesTwitterPlayerExist",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

-(id)loginTwitterPlayer:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/loginTwitterPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

-(id)loginFacebookPlayer:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/loginFacebookPlayer",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}

-(id)updatePlayerPassword:(NSString *)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updatePlayerPassword",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [self requestAPIData:jsonData url:urlAddress];
}


-(BOOL)reachable {
    return YES;
    Reachability *r = [Reachability reachabilityWithHostName:(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}


#pragma mark - initialization
- (id) init {
	self = [super init];
	if (self != nil) {
		//custom initialization
	}
	return self;
}

#pragma mark ---- singleton object methods ----



+ (APIDataManager *)sharedInstance {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];// or some other init method
    });
    return _sharedObject;
    /*
     @synchronized(self) {
     if (myDataManager == nil) {
     [[self alloc] init]; // assignment not done here
     }
     }
     return myDataManager;*/
}


@end
