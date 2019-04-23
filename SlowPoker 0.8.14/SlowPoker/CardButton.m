//
//  CardButton.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardButton.h"

@implementation CardButton
    
@synthesize cardValue;
@synthesize cardSelected;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
	if (self != nil) {
        [self addTarget:self action:@selector(cardPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)cardPressed{
    self.cardSelected = YES;
}

@end
