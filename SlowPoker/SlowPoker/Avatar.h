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
    int radius;
    UIImage *avatar;
    NSString *userID;
    BOOL isLoading;
}

@property(nonatomic,retain)UIImageView *imageView;
@property(readwrite)int radius;
@property(readwrite)UIImage *avatar;
@property(readwrite)NSString *userID;
-(void)loadAvatar:(NSString *)userIDParam;
- (void)loadImageFromURL:(NSURL*)url;

@end
