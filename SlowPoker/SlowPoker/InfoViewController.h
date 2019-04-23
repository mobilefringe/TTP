//
//  InfoViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-09-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;

@end
