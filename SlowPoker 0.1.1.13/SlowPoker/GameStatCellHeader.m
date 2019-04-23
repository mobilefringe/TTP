//
//  GameStatCellHeader.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatCellHeader.h"

@implementation GameStatCellHeader

@synthesize statCode;
@synthesize subTitleLabel;
@synthesize questionButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

    }
    return self;
}


-(void)setHeaderCode:(NSString *)code{
    self.statCode = code;
    NSString *key = [NSString stringWithFormat:@"profile.%@.title",code];
    titleLabel.text = NSLocalizedString(key,nil);
    titleLabel.frame = CGRectMake(18, 12, 250, 30);
    
    
    if(!subTitleLabel){
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 30, 250, 22)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        subTitleLabel.textAlignment = UITextAlignmentLeft;
        subTitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:subTitleLabel];
    }
    
    if(!questionButton){
        self.questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        questionButton.frame = CGRectMake(270,16, 35, 35);
        [questionButton setImage:[UIImage imageNamed:@"blue_question_mark.png"] forState:UIControlStateNormal];
        [questionButton addTarget:self action:@selector(showDescription) forControlEvents:UIControlEventTouchUpInside];
        questionButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [self addSubview:questionButton];

    }
    key = [NSString stringWithFormat:@"profile.%@.subTitle",code];
    subTitleLabel.text = NSLocalizedString(key,nil); 
    
}

-(void)showDescription{
    UIAlertView *descAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    NSString *key = [NSString stringWithFormat:@"profile.%@.title",statCode];
    descAlert.title = NSLocalizedString(key,nil);
    key = [NSString stringWithFormat:@"profile.%@.description",statCode];
    descAlert.message = NSLocalizedString(key,nil);
    
    [descAlert show];
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
