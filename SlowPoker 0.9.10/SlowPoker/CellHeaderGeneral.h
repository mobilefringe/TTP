//
//  CellHeaderGeneral.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHeaderGeneral : UIView{
    UILabel *titleLabel;
}

@property(nonatomic,retain)UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
