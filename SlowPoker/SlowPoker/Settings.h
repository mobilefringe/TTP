//
//  Settings.h
//  MallMap
//
//  Created by Jamie Simpson on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
    NSMutableDictionary *settings;
    UIAlertView *updateAppAlert;
    NSString *header1Font;
    NSString *header2Font;
    NSString *textFont1;
}

@property(nonatomic,retain)NSMutableDictionary *settings;
@property(nonatomic,retain)UIAlertView *updateAppAlert;
@property(nonatomic,retain)NSString *header1Font;
@property(nonatomic,retain)NSString *header2Font;
@property(nonatomic,retain)NSString *textFont1;
+(int)addFavoritePlayerID:(NSString *)userID;
+(int)removeFavoritePlayerID:(NSString *)userID;
+(NSArray *)getFavoritePlayers;
+(BOOL)isFavoritePlayer:(NSString *)userID;
+(NSArray *)getValuesForKey:(NSString *)key;
+(int)maxHandsCash;
+(int)maxHandsTournament;

+(Settings *)sharedInstance;
-(void)loadRemoteSettings;


@end
