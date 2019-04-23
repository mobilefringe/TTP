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

//Connection Method
-(id)requestAPIData:(NSString *)json url:(NSString*)postUrl;
@end
