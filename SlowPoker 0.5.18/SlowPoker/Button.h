//
//  Button.h
//  Mileage
//
//  Created by Jamie Simpson on 02/09/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Button : UIView {
	UIButton *button;
	int style;
	int curve;
	UIView *buttonIcon;
	UILabel *titleLabel;
    float red;
    float green;
    float blue;
    float alpha;
}
- (id)initWithFrame:(CGRect)frame title:(NSString *)title red:(float)redParam green:(float)greenParam blue:(float)blueParam alpha:(float)alphaParam;
@property (nonatomic,retain) UIButton *button;
@property (nonatomic,retain) UIView *buttonIcon;
@property (readwrite) int style;
@property (readwrite) int curve;
+(int)redStyle;
+(int)blackStyle;
-(void)setTitle:(NSString *)aTitle;

@end
