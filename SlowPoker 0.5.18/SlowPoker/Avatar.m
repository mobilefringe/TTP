//
//  Avatar.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Avatar.h"

@implementation Avatar

@synthesize imageView;

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

-(void)loadAvatar:(NSString *)userID{
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
    
   
    connection=nil;
    UIImage *avatarImage = [UIImage imageWithData:data];
    if(avatarImage && avatarImage.size.width > 0){
        imageView.frame = self.bounds;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationDelegate:self];
        
        [imageView setImage:[UIImage imageWithData:data]];        
        
        [UIView commitAnimations];

        
       // [imageView setNeedsLayout];
       // [self setNeedsLayout];

    }else{
        imageView.frame = self.bounds;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationDelegate:self];
        
        [imageView setImage:[UIImage imageNamed:@"empty_avatar.jpg.gif"]];
        [UIView commitAnimations];
    }
    data=nil;
    [activityIndicatorView stopAnimating];
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
