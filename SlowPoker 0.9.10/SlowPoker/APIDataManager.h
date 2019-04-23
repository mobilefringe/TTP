//
//  APIDataManager.h
//  SlowPokerServer
//
//  Created by Fahad Muntaz on 12-03-26.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIDataManager : NSObject{
    
}

+ (APIDataManager *)sharedInstance;

//API Methods
-(id)registerPlayer:(NSString *)jsonData;
-(id)checkUsername:(NSString *)jsonData;
-(id)checkEmail:(NSString *)jsonData;
-(id)loginPlayer:(NSString *)jsonData;
-(id)createGame:(NSString*)jsonData;
-(id)updateGame:(NSString*)jsonData;
-(id)getPlayerGames:(NSString*)jsonData;
-(id)getGame:(NSString *)jsonData;
-(id)updatePlayerToGame:(NSString *)jsonData;
-(id)addPlayerToGame:(NSString *)jsonData;
-(id)searchForUser:(NSString *)jsonData;
-(id)updatePlayerFriends:(NSString*)jsonData;
-(id)registeriDevice:(NSString*)jsonData;
-(id)sendNotification:(NSString *)jsonData;
-(id)postMessge:(NSString*)jsonData;
-(id)getLastMessage:(NSString*)jsonData;
-(id)postMessge:(NSString*)jsonData;
-(id)getPlayerProfile:(NSString*)jsonData;
-(id)updatePlayerInventory:(NSString*)jsonData;
-(id)postAchievements:(NSString *)jsonData;
-(id)getAchievements:(NSString *)jsonData;
-(id)postPlayerAvatar:(NSString*)userID img:(UIImage*)imgToUpload;
-(UIImage*)rotate:(UIImageOrientation)orient img:(UIImage*)imgToUpload;
-(id)postInventory:(NSString *)jsonData ;
-(id)getInventory:(NSString *)jsonData ;
-(id)postGiftForUser:(NSString *)jsonData;
-(NSDictionary*)getPlayerStatuses:(NSString *)jsonData;
-(id)joinGame:(NSString *)jsonData;
//Connection Method
-(id)requestAPIData:(NSString *)json url:(NSString*)postUrl;
-(id)registerFacebookPlayer:(NSString *)jsonData;
-(id)loginFacebookPlayer:(NSString *)jsonData;
-(id)updatePlayerPassword:(NSString *)jsonData;
-(id)registerTwitterPlayer:(NSString *)jsonData;
-(id)doesTwitterPlayerExist:(NSString *)jsonData;
-(id)loginTwitterPlayer:(NSString *)jsonData;
-(BOOL)reachable;
-(id)getFacebookFriends:(NSString *)jsonData;
-(id)loginGamePlayer:(NSString *)jsonData;
-(id)resetPlayerPassword:(NSString *)jsonData;
@end
