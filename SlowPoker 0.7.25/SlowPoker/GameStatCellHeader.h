//
//  GameStatCellHeader.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellHeaderGeneral.h"

@interface GameStatCellHeader : CellHeaderGeneral{
    NSString *statCode;
    UILabel *subTitleLabel;
    UIButton *questionButton;
}

@property(nonatomic,retain)NSString *statCode;
@property(nonatomic,retain)UILabel *subTitleLabel;
@property(nonatomic,retain)UIButton *questionButton;

-(void)setHeaderCode:(NSString *)code;

@end
