//
//  Settings.m
//  MallMap
//
//  Created by Jamie Simpson on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

static NSString *FAVORITE_PLAYERS_KEY = @"FAVORITE_PLAYERS_KEY";
static NSString *deviceKey = @"iPhone";

@implementation Settings

@synthesize settings;
@synthesize updateAppAlert;


+ (void)initialize{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	
	NSArray *favoritePlayers=[[NSArray alloc] init];
	
	
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:favoritePlayers,FAVORITE_PLAYERS_KEY,nil];
								  
								  
	[defaults registerDefaults:appDefaults];
	
	//[appDefaults release];
	//[favoriteVendors release];
	
}


-(void)loadRemoteSettings{
    dispatch_async(kBgQueue, ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@/settings.json",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];

        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:180.0];
        [request setHTTPMethod:@"POST"];

        
        NSURLResponse *response;
        NSError *error;
        
        //NSLog(@"request data from %@: %@:",postUrl,json);
        
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response error:&error];
        
        
        
        if(error == nil) {
            
            NSMutableDictionary *results =  [NSJSONSerialization 
                    JSONObjectWithData:jsonData
                    options:NSJSONReadingMutableContainers 
                    error:&error];
            
            [self performSelectorOnMainThread:@selector(processSettings:) 
                                   withObject:results waitUntilDone:YES];
        }else{
            NSLog(@"requestAPIData error:%@",error);
        }
    });
}


-(void)processSettings:(NSMutableDictionary *)results{
    self.settings = results;
    
    
    
    
    float thisAppVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
	float forceVersion = [[[[settings valueForKey:@"versions"] valueForKey:deviceKey] valueForKey:@"forceVersion"] floatValue];
    if(forceVersion != 0 && forceVersion > thisAppVersion){
        if(!updateAppAlert){
            self.updateAppAlert = [[UIAlertView alloc] initWithTitle:@"App Update Required" message:@"There is a new version of the app available. Please update the app first to continue playing. Thank you." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Update", nil];
        }
        [updateAppAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == updateAppAlert){
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[[[settings valueForKey:@"versions"] valueForKey:deviceKey] valueForKey:@"appDownloadURL"]]];
    }
    
    
    
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

+(int)maxHandsCash{
    return 50;
}

+(int)maxHandsTournament{
    return 15;
}

+ (Settings *)sharedInstance {
    
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
