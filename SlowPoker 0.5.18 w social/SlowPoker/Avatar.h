//
//  Avatar.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Avatar : UIView{
    UIImageView *imageView;
    UIActivityIndicatorView *activityIndicatorView;
    NSURLConnection* connection;
    NSMutableData* data;
}

@property(nonatomic,retain)UIImageView *imageView;
-(void)loadAvatar:(NSString *)userID;
- (void)loadImageFromURL:(NSURL*)url;

@end
