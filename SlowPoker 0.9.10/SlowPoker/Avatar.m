//
//  Avatar.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Avatar.h"
#import "DataManager.h"

@implementation Avatar

@synthesize imageView;
@synthesize radius;
@synthesize avatar;
@synthesize userID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.center = CGPointMake(frame.size.width/2, frame.size.width/3);
        //[self.view addSubview:activityIndicatorView];
        activityIndicatorView.hidesWhenStopped = YES;
        [activityIndicatorView stopAnimating];
        [self addSubview:activityIndicatorView];
        
    }
    return self;
}

-(void)loadAvatar:(NSString *)userIDParam{
    if(isLoading){
        return;
    }
    self.userID = userIDParam;
    /*
    if(![userIDParam isEqualToString:userID]){
        if(connection){
            [connection cancel];
        }
    }*/
    imageView.alpha = 0;
    if([[DataManager sharedInstance] getAvatar:[NSString stringWithFormat:@"%@_%d",userID,radius]]){
        UIImage *avatarImage = [[DataManager sharedInstance] getAvatar:[NSString stringWithFormat:@"%@_%d",userID,radius]];
        //imageView.frame = self.bounds;
        imageView.alpha = 1;
        [imageView setImage:avatarImage];
        return;

    }
    isLoading = YES;
    imageView.alpha = 0;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getPlayerAvatar/%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"],userID]];
    [self loadImageFromURL:url]; 
}

- (void)loadImageFromURL:(NSURL*)url {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    self.avatar = [UIImage imageWithData:data];
    if(!avatar || avatar.size.width == 0){
        //return;
        self.avatar = [UIImage imageNamed:@"empty_avatar.png"];
    }
    UIImage *avatarImage = [self makeRoundCornerImage:avatar:radius:radius];
    [[DataManager sharedInstance] setAvatar:avatarImage userID:[NSString stringWithFormat:@"%@_%d",userID,radius]];
    
    imageView.frame = self.bounds;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    imageView.alpha = 1;
    [imageView setImage:avatarImage];        
    
    [UIView commitAnimations];
   
    connection=nil;
    
    data=nil;
    isLoading = NO;
    [activityIndicatorView stopAnimating];
}



static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
	
	//CGContextMoveToPoint(context, 0, fh/2);
	//CGContextAddArcToPoint(context, 0, fh, fw/2, fh, 1);
	//CGContextAddLineToPoint(context, 0, 0);
	//CGContextAddLineToPoint(context, fw, fh);
    // CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    //CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    //CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
	//CGContextAddLineToPoint(context, fw, 0);
	//CGContextAddLineToPoint(context, 0, 0);
    //CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	
	
     CGContextMoveToPoint(context, fw, fh/2);
     CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
     CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
     CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
     CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

-(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight
{
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		//[img release];
		
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
		
		
	}
	
    return newImage;
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
