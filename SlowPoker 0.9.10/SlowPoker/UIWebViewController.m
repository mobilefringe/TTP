//
//  UIWebViewController.m
//  MobileFringe Framework
//
//  Created by Jamie Simpson on 7/20/09.
//  Copyright 2009 Mobile Fringe. All rights reserved.
//

#import "UIWebViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"

@implementation UIWebViewController

@synthesize urlRequest;
@synthesize appDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];		
		
				
		
	}
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    background.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
	backgroundImage = [UIImage imageNamed:@"loading.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	//imageView.frame = CGRectMake(0, 50, 320, 350);
	[self.view addSubview:imageView];
	
	
	
    float bottomBar = 40;
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topbarHeight+10, self.view.bounds.size.width, self.view.bounds.size.height-([[DataManager sharedInstance] getBottomPadding] + 50 + 10+bottomBar))];
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	webView.hidden = YES;
	[self.view addSubview:webView];
	
	
	toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-50,self.view.bounds.size.width,50)];
	toolBar.barStyle = UIBarStyleBlackTranslucent;
	//toolBar.tintColor = [UIColor colorWithRed:.5 green:0 blue:0.071 alpha:1];
	[self.view addSubview:toolBar];
	
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loadingIndicator.frame = CGRectMake(150, 15, 20, 20);
	loadingIndicator.hidesWhenStopped = YES;
	[loadingIndicator stopAnimating];
	[toolBar addSubview:loadingIndicator];
	
	
	backDisabled = [UIImage imageNamed:@"back_enabled.png"];
	backEnabled = [UIImage imageNamed:@"back_enabled.png"];
	forwardDisabled = [UIImage imageNamed:@"forward_disabled.png"];
	forwardEnabled = [UIImage imageNamed:@"forward_enabled.png"];
	
	
	
	
	backButton = [[UIBarButtonItem alloc] initWithImage:backDisabled style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	backButton.enabled = NO;
	forwardButton = [[UIBarButtonItem alloc] initWithImage:forwardDisabled style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
	forwardButton.enabled = NO;
	//UIButton *homeButton = [[UIButton alloc] initWithImage:[UIImage imageNamed:@"home_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
	UIBarButtonItem *widthButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	widthButton.width = 180;
	UIBarButtonItem *widthButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	widthButton2.width = 30;
	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareContent)];
	
	
	
	NSArray *barItems = [NSArray arrayWithObjects:backButton,widthButton2,forwardButton,widthButton,nil];
	//homeButton.frame = CGRectMake(280, 0, homeButton.frame.size.width, homeButton.frame.size.height);
	[toolBar setItems:barItems animated:NO];
	//[toolBar addSubview:homeButton];
	
}



-(void)loadURL:(NSString *)urlStr{
	self.urlRequest = urlStr;
    //NSLog(@"urlStr:%@",urlStr);
}

-(void)viewWillAppear:(BOOL)animated{
	//[appDelegate checkInternet];
	webView.hidden = YES;
    //NSLog(@"%@",self.urlRequest);
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:self.urlRequest,
     @"url",
     nil];
    self.urlRequest = [self.urlRequest stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *urlObj = [NSURL URLWithString:[self.urlRequest stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	//NSURL *urlObj = [NSURL URLWithString:self.urlRequest];
	//URL Requst Object
	requestObj = [NSURLRequest requestWithURL:urlObj];
    NSLog(@"urlObj:%@",urlObj);
	[webView loadRequest:requestObj];
    [appDelegate updateHeaderWithTitle:self.title];
}

-(void)loadPDF:(NSString *)fileName{
	if(![fileName isEqualToString:self.urlRequest]){
		webView.hidden = YES;
		NSString *urlAddress = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
		NSURL *url = [NSURL fileURLWithPath:urlAddress];
		requestObj = [NSURLRequest requestWithURL:url];
		[webView loadRequest:requestObj];
	}
	self.urlRequest = fileName;
}




- (void)webViewDidStartLoad:(UIWebView *)webView2{
	[loadingIndicator startAnimating];
	
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView2{
	webView.hidden = NO;
	[loadingIndicator stopAnimating];
	if([webView canGoBack]){
		backButton.image = backEnabled;
		backButton.enabled = YES;
	}else{
		backButton.image = backDisabled;
		backButton.enabled = NO;
		
	}
	
	if([webView canGoForward]){
		forwardButton.image = forwardEnabled;
		forwardButton.enabled = YES;
	}else{
		forwardButton.image = forwardDisabled;
		forwardButton.enabled = NO;
	}
	
	
}




-(void)shareContent{
    
	UIActionSheet *fashionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Link",@"Open in Safari",nil];
	fashionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[fashionSheet showFromTabBar:toolBar];
	
}


//handle actionSheet button presses

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
	if (buttonIndex == 0) {
		[appDelegate email:[appDelegate.currentDeal objectForKey:@"title"] body:[appDelegate.currentDeal objectForKey:@"link"]];
		
	}
	else if (buttonIndex == 1) {
		[appDelegate openWebpageInSafari:[appDelegate.currentDeal objectForKey:@"link"]];
	}*/
	
}

-(void)goBack{
	[webView goBack];
	
}

-(void)goForward{
	[webView goForward];
	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}





@end
