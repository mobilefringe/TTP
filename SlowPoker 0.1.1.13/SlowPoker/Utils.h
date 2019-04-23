//
//  Utils.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject{
    
    
}

+ (Utils *)sharedInstance;
- (UIColor *) colorWithHexString: (NSString *) hex alpha:(double)alpha;

@end
