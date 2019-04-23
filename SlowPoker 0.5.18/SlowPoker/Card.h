//
//  Card.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface Card : NSObject{
    int rank;
    int suit;
    NSString *cardString;
    NSArray *ranks;
    NSArray *suits;
}

@property(readwrite)int rank;
@property(readwrite)int suit;
@property(nonatomic,retain)NSArray *ranks;
@property(nonatomic,retain)NSArray *suits;
@property(nonatomic,retain)NSString *cardString;
-(id)initWithCard:(NSString *)cardStr;
- (NSComparisonResult)compare:(Card *)otherObject;
-(int)cardValue;




@end
