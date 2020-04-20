//
//  UIWebViewController.h
//  MobileFringe Framework
//
//  Created by Jamie Simpson on 7/20/09.
//  Copyright 2009 Mobile Fringe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class AppDelegate;

@interface UIWebViewController : UIViewController<WKNavigationDelegate,UIActionSheetDelegate> {
	UIImage *backgroundImage;
	WKWebView *webView;
	UIActivityIndicatorView *loadingIndicator;
	NSURLRequest *requestObj;
	NSString *urlRequest;
	
	UIImage *backDisabled;
	UIImage *backEnabled;
	UIImage *forwardDisabled;
	UIImage *forwardEnabled;
	
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
	
	UIToolbar *toolBar;
	AppDelegate *appDelegate;
	
}

@property(nonatomic,retain)NSString *urlRequest;
@property (nonatomic,retain)AppDelegate *appDelegate;

-(void)loadURL:(NSString *)urlStr;
-(void)loadPDF:(NSString *)fileName;

@end
