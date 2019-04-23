//
//  HandEvaluator.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandEvaluator : NSObject{
    int value;
    NSString *type;
}

@property(readwrite)int value;
@property(nonatomic,retain)NSString *type;

@end
