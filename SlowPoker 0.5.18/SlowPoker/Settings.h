//
//  Settings.h
//  MallMap
//
//  Created by Jamie Simpson on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {

}

+(int)addFavoritePlayerID:(NSString *)userID;
+(int)removeFavoritePlayerID:(NSString *)userID;
+(NSArray *)getFavoritePlayers;
+(BOOL)isFavoritePlayer:(NSString *)userID;
+(NSArray *)getValuesForKey:(NSString *)key;


@end
