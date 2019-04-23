//
//  CellFooterGeneral.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellFooterGeneral.h"

@implementation CellFooterGeneral

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_footer_general.png"]];
        background.frame = CGRectMake(0, -9, 320, frame.size.height);
        [self addSubview:background];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 280, 17)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 9;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
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
