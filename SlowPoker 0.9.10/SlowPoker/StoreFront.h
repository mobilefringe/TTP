//
//  TransactionManager.h
//  SlowPokerServer
//
//  Created by Fahad Muntaz on 12-04-09.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SBTableAlert.h"

@protocol StoreFrontDelegate <NSObject,SBTableAlertDelegate,SBTableAlertDataSource,SKPaymentTransactionObserver>
@optional
- (void)didRetrieveProducts:(NSMutableArray*)products;
-(void)isLoadingProducts;
//- (void)completeTransaction:(SKPaymentTransaction*)transaction;
//- (void)failedTransaction:(SKPaymentTransaction *)transaction;
//- (void)restoreTransaction: (SKPaymentTransaction*)transaction;
@end

@interface StoreFront : NSObject<SKProductsRequestDelegate,UIAlertViewDelegate> {
    
    SBTableAlert *productsAlert;
    NSMutableArray *theProducts;
    id delegate;
    NSSet *productSet;
    NSNumberFormatter *formatter;
    BOOL notEnoughProChips;
}
@property (nonatomic, retain) id <StoreFrontDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *theProducts;
@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, retain) NSSet *productSet;
@property (readwrite)BOOL notEnoughProChips;

+ (StoreFront *)sharedStore;
- (void)requestProductData;
- (void)openStore;
- (void)displayStoreFront;
- (void)addPayment:(SKProduct*)product;
- (void)completeTransaction:(SKPaymentTransaction*)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction: (SKPaymentTransaction*)transaction;
- (void)updateContent:(NSString*)contentIdentifier;
- (void)incrementUserCurrency:(NSInteger) newValue;
- (BOOL)decrementUserCurrency:(NSInteger) newValue;
- (NSInteger)getUserCurrency;
- (NSDictionary*)updateCurrency:(NSString *)jsonData;
- (NSDictionary*)incrementCurrency:(NSString *)jsonData;
- (NSDictionary*)decrementCurrency:(NSString *)jsonData;
- (NSDictionary*)requestAPIData:(NSString *)json url:(NSString*)postUrl;
-(void)loadProducts;
@end
