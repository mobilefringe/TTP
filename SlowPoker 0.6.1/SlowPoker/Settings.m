//
//  Settings.m
//  MallMap
//
//  Created by Jamie Simpson on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

static NSString *FAVORITE_PLAYERS_KEY = @"FAVORITE_PLAYERS_KEY";


@implementation Settings

+ (void)initialize{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	
	NSArray *favoritePlayers=[[NSArray alloc] init];
	
	
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:favoritePlayers,FAVORITE_PLAYERS_KEY,nil];
								  
								  
	[defaults registerDefaults:appDefaults];
	
	//[appDefaults release];
	//[favoriteVendors release];
	
}

+(NSArray *)getValuesForKey:(NSString *)key{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+(int)addFavoritePlayerID:(NSString *)vendorID{
	[[NSUserDefaults standardUserDefaults] setObject:[[Settings getFavoritePlayers] arrayByAddingObject:vendorID] forKey:FAVORITE_PLAYERS_KEY];
	return [Settings getFavoritePlayers].count-1;
}

+(int)removeFavoritePlayerID:(NSString *)userID{
	NSMutableArray *favs = [NSMutableArray arrayWithArray:[self getFavoritePlayers]];
	[favs removeObject:userID];
	[[NSUserDefaults standardUserDefaults] setObject:favs forKey:FAVORITE_PLAYERS_KEY];
	return [Settings getFavoritePlayers].count-1;
}

+(NSArray *)getFavoritePlayers{
	return [Settings getValuesForKey:FAVORITE_PLAYERS_KEY];
}

+(BOOL)isFavoritePlayer:(NSString *)userID{

	NSArray *favoritePlayers = [Settings getFavoritePlayers];
	for(int i = 0; i < favoritePlayers.count;i++){
		NSString *favUserID = (NSString *)[favoritePlayers objectAtIndex:i];
		if([favUserID isEqualToString:userID]){
			return YES;
		}
		
	}
	return NO;
	
}

@end
