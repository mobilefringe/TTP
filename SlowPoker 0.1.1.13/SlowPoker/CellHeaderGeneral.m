//
//  CellHeaderGeneral.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellHeaderGeneral.h"

@implementation CellHeaderGeneral

@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_header_general2.png"]];
        background.frame = CGRectMake(0, 3, 320, frame.size.height);
        [self addSubview:background];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 250, 22)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
