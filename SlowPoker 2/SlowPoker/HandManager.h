//
//  HandManager.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandManager : NSObject{
    
}


+ (HandManager *)sharedInstance;
-(NSMutableArray *)determineWinners:(NSMutableDictionary *)game;

@end
