//
//  Button.m
//  Mileage
//
//  Created by Jamie Simpson on 02/09/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NudgeButton.h"


@implementation NudgeButton

@synthesize button,style,curve,buttonIcon;


- (id)initWithFrame:(CGRect)frame title:(NSString *)title red:(float)redParam green:(float)greenParam blue:(float)blueParam alpha:(float)alphaParam{
	
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,self.frame.size.width-10,self.frame.size.height-10)];
		titleLabel.font = [UIFont boldSystemFontOfSize:14];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = title;
		[self addSubview:titleLabel]; 
		
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0,self.frame.size.width,self.frame.size.height);
		//button.showsTouchWhenHighlighted=YES;
		[button setBackgroundColor:[UIColor clearColor]];
		//style = styleParam;
		[self addSubview:button];
        
        red = redParam;
        green = greenParam;
        blue = blueParam;
        alpha = alphaParam;
		
		curve = 5;
	}
	return self;
}

-(void)setTitle:(NSString *)aTitle{
	titleLabel.text = aTitle;
}


- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	CGContextSetLineWidth(context, 0);
	
	int cellPadding = 3;
	
	//draw bottom gray line
	CGRect innerRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	CGContextSetRGBFillColor(context, .7, .7, .7, .4);
	CGFloat innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	CGFloat innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	CGContextMoveToPoint(context, innerMinx, innerMidy);
	CGContextAddArcToPoint(context, innerMinx, innerMiny+10, innerMidx, innerMiny, curve+2);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny+10, innerMaxx, innerMidy, curve+2);
	CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve+2);
	CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve+2);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	//draw outter black area
	innerRect = CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2);
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	CGContextMoveToPoint(context, innerMinx, innerMidy);
	CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, curve+2);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, curve+2);
	CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve+2);
	CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve+2);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	//draw inner button
	innerRect = CGRectMake(cellPadding, cellPadding, self.frame.size.width-(2*cellPadding), self.frame.size.height-(2*cellPadding));
	//CGContextSetRGBFillColor(context, 0, .28, 1, .7);
	button.enabled = YES;
	
	BOOL multiColour = YES;
	CGContextSetRGBFillColor(context, red, green, blue, alpha);
    innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	CGContextMoveToPoint(context, innerMinx, innerMidy);
	CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, curve);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, curve);
	CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve);
	CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	/*
     CGGradientRef myGradient;
     
     CGColorSpaceRef myColorspace;
     
     size_t num_locations = 2;
     
     CGFloat locations[2] = { 0.0, 1 };
     
     CGFloat components[8] = { 1.0, 1, 1, 0,  // Start color
     .2, 1, 1, 1 }; // End color
     
     myColorspace = CGColorSpaceCreateDeviceGray();
     myGradient = CGGradientCreateWithColorComponents (myColorspace, components,locations, num_locations);
     
     
     CGPoint myStartPoint, myEndPoint;
     myStartPoint.x = self.frame.size.width/2;
     myStartPoint.y = 0.0;
     myEndPoint.x = self.frame.size.width/2;
     myEndPoint.y = self.frame.size.height/2;
     CGContextDrawLinearGradient (context, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsBeforeStartLocation);
     */
	
	
	
	//from RIButton
	int height = 12;
	int sideShadowWidth = 5;
	int shadowCurve = 10;
	innerRect = CGRectMake(sideShadowWidth, 4, self.frame.size.width-2*sideShadowWidth, height);
	
	
	CGContextSetRGBFillColor(context, 0, 0, 0, .3);
	//CGContextFillRect(context, CGRectMake(0, 0,self.frame.size.width,self.frame.size.height));
	
	CGContextSetLineWidth(context, 0);
	//CGContextSetRGBFillColor(context, 1, 1, 1, .05);
	CGContextSetRGBFillColor(context, 1, 1, 1, 0.1);
	
	innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	CGContextMoveToPoint(context, innerMinx, innerMiny);
	//CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, shadowCurve);
	//CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, shadowCurve);
	CGContextAddLineToPoint(context,innerMaxx ,innerMiny );
	CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, shadowCurve);
	CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMiny, shadowCurve);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	
	//white line
	innerRect = CGRectMake(cellPadding+1, cellPadding+1, self.frame.size.width-(2*cellPadding)-2, self.frame.size.height-(2*cellPadding));
	
	
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .3);
	
	innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
    
	CGContextMoveToPoint(context, innerMinx, innerMidy-6);
	CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, curve);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, curve);
	CGContextAddLineToPoint(context, innerMaxx, innerMidy-6);
	//CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve);
	//CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve);
	//CGContextClosePath(context);
	CGContextStrokePath(context);
	
	innerRect = CGRectMake(cellPadding+2, cellPadding+2, self.frame.size.width-(2*cellPadding)-4, self.frame.size.height-(2*cellPadding));
	
	
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .1);
	
	innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	
	CGContextMoveToPoint(context, innerMinx, innerMidy-6);
	CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, curve);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, curve);
	CGContextAddLineToPoint(context, innerMaxx, innerMidy-6);
	//CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve);
	//CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve);
	//CGContextClosePath(context);
	CGContextStrokePath(context);
	
	innerRect = CGRectMake(cellPadding+3, cellPadding+3, self.frame.size.width-(2*cellPadding)-6, self.frame.size.height-(2*cellPadding));
	
	
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, .1);
	
	innerMinx = CGRectGetMinX(innerRect), innerMidx = CGRectGetMidX(innerRect), innerMaxx = CGRectGetMaxX(innerRect);
	innerMiny = CGRectGetMinY(innerRect), innerMidy = CGRectGetMidY(innerRect), innerMaxy = CGRectGetMaxY(innerRect);
	
	CGContextMoveToPoint(context, innerMinx, innerMidy-6);
	CGContextAddArcToPoint(context, innerMinx, innerMiny, innerMidx, innerMiny, curve);
	CGContextAddArcToPoint(context, innerMaxx, innerMiny, innerMaxx, innerMidy, curve);
	CGContextAddLineToPoint(context, innerMaxx, innerMidy-6);
	//CGContextAddArcToPoint(context, innerMaxx, innerMaxy, innerMidx, innerMaxy, curve);
	//CGContextAddArcToPoint(context, innerMinx, innerMaxy, innerMinx, innerMidy, curve);
	//CGContextClosePath(context);
	CGContextStrokePath(context);
	
	
	
	
	
	
}

+(int)redStyle{
	return 1;
}

+(int)blackStyle{
	return 2;
}




@end
