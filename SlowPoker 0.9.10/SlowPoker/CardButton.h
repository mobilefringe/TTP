//
//  CardButton.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardButton : UIButton{
    NSString *cardValue;
    BOOL cardSelected;
}
@property(nonatomic,retain)NSString *cardValue;
@property(readwrite)BOOL cardSelected;

@end
