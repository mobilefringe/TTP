//
//  APIDataManager.m
//  
//
//  Created by Fahad Muntaz on 12-03-26.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import "APIDataManager.h"

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
   // NSLog(@"createGame:%@",jsonData);
    return [self requestAPIData:jsonData url:urlAddress];

}

/* updateGame - updates a game on the server 
   required: gameID, nextActionForUserID, lastActionMessage, status, gameOwnerID, 
   gameSetting, gameState, idleTime, turnState */

-(id)updateGame:(NSString*)jsonData {
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@/updateGame",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
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



#pragma mark Connection

-(id)requestAPIData:(NSString *)json url:(NSString*)postUrl
{
    
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
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request 
                                            returningResponse:&response error:&error];
    
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //////NSLog(@"response data from %@:%@",postUrl,jsonString);
    
    //NSMutableDictionary *jsonDictionary;
    if(error == nil) {
        
        return [NSJSONSerialization 
                          JSONObjectWithData:jsonData
                          options:NSJSONReadingMutableContainers 
                          error:&error];
    }else{
        NSLog(@"requestAPIData error:%@",error);
    }
    
        
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"0" forKey:@"success"];
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    return jsonDictionary;


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
