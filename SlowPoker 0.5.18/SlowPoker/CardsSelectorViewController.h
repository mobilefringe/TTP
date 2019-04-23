//
//  CardsSelectorViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsSelectorViewController : UIViewController{
    NSMutableArray *cards;
    NSMutableArray *deck;
    UIScrollView *scrollView;
    int numOfCards;
    int maxCards;
}

@property(nonatomic,retain)NSMutableArray *cards;
@property(nonatomic,retain)NSMutableArray *deck;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(readwrite)int numOfCards;
@property(readwrite)int maxCards;
-(void)resetCards;

@end
