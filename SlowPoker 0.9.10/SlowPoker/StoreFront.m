//
//  TransactionManager.m
//  SlowPokerServer
//
//  Created by Fahad Muntaz on 12-04-09.
//  Copyright (c) 2012 MobileFringe. All rights reserved.
//  

#import "StoreFront.h"
#import "DataManager.h"
#import "APIDataManager.h"
#import "AppDelegate.h"
#import "UpdatingPopUp.h"

@implementation StoreFront
static StoreFront *store = nil;
static NSString *proChipdentifier1 = @"com.mobilefringe.SlowPoker.prochip.10x";
static NSString *proChipdentifier2 = @"com.mobilefringe.SlowPoker.prochip.20x";
static NSString *proChipdentifier3 = @"com.mobilefringe.SlowPoker.prochip.65x";
static NSString *proChipdentifier4 = @"com.mobilefringe.SlowPoker.prochip.145x";
static NSString *proChipdentifier5 = @"com.mobilefringe.SlowPoker.prochip.270x";


static NSString *consumableIndentifier = @"proChip";

@synthesize delegate, theProducts, productSet,formatter;
@synthesize notEnoughProChips;

/*
   StoreFront
   Manages and Handles In App Purchases
   ** In App Purchases are specified by identifiers
   To add additional identifiers do the following:
    1) Create a New Static String that holds the identifier
    2) In the init method of StoreFront, add your new product identifer to productSet
    3) Add handling for the new product identifier to the updateContent method
 
   ** Custom UI
   To implement a custom UI to display all products available, do the following:
    1) set the delegate for StoreFront
    2) implement the (void)didRetrieveProducts:(NSMutableArray*)products;
       - this method returns the in app purchase products (SKProduct) available from apple
    3) When a user selects a product to purchase, it should call the addPayment method

    Note: When user completes login to app, StoreFront should be initialized, in case
    there are transactions that are still pending.
   
*/


/* openStore
 
   optional: delegate
   optional implemented delegate method: didRetrieveProducts
   This opens a the StoreFront to make in app purchases.
   If the user has disabled in app purchased, an alert dialog is presented informing the user.

   The StoreFront provides a quick table for in app purchases.  If you want to implement your own
   UI, please make sure a delegate is set and didRetrieveProducts: delegate method is implemented.
 
*/
-(void)openStore
{
    if ([SKPaymentQueue canMakePayments]) {
        if(productsAlert == nil)
        {
            productsAlert = [SBTableAlert alertWithTitle:@"ProChip Store" cancelButtonTitle:@"Cancel" messageFormat:@"Please select a package of Pro Chips to Purchase"];
            
            [productsAlert setStyle:SBTableAlertStyleApple];
            [productsAlert setDataSource:self];
            [productsAlert setDelegate:self];
        }
        if(theProducts == nil)
        {
            [self requestProductData];
        }
        else
        {
            if(delegate != nil && [delegate respondsToSelector:@selector(didRetrieveProducts:)]){
                
                [delegate didRetrieveProducts:theProducts];
            }
            else
            {
                [self displayStoreFront];        
                
            }
        }
        
    } else {
        
        // Warn the user that purchases are disabled.
        UIAlertView *purchaseDisabled = [[UIAlertView alloc] initWithTitle:@"Store Closed" message:@"Sorry, it looks like you disabled purchases. Please change your settings and try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [purchaseDisabled show];
    }
}

/* requestProductData
   
    Used by OpenStore to get In App Purchase Data
 
*/
- (void)requestProductData
{
    [delegate isLoadingProducts];
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 productSet];
    request.delegate = self;
    [request start];
}

/* productsRequest:
   
   SKProductsRequest delegate method
   Method is called when response is received after the requestProductData is called
   This method also determines if the developer implemented the delegate and delegate method to handle
   their own UI.
 
*/
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //NSLog(@"productsRequest:%@",response);
    
    NSArray *items = response.products;
    /*
    for(SKProduct *item in items)
    {
        
        NSLog(@"Product title: %@" , item.localizedTitle);
        NSLog(@"Product description: %@" , item.localizedDescription);
        NSLog(@"Product price: %@" , item.price);
        NSLog(@"Product id: %@" , item.productIdentifier);
        
        
    }
    NSLog(@"response.invalidProductIdentifiers:%@",response.invalidProductIdentifiers);
    for (SKProduct *item in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , item.productIdentifier);
        NSLog(@"Invalid Product title: %@" , item.localizedTitle);
        NSLog(@"Invalid Product description: %@" , item.localizedDescription);
        NSLog(@"Invalid Product price: %@" , item.price);
       
    }*/
    
    
   // NSLog(@"iTunes invalidProductIdentifiers:%@",response.invalidProductIdentifiers);
    theProducts = [[NSMutableArray alloc] initWithArray:response.products];
    
    
    
    
    for (NSMutableDictionary *product in [DataManager sharedInstance].products) {
        for(SKProduct *skProduct in theProducts){
            if([[product valueForKey:@"key"] isEqualToString:skProduct.productIdentifier]){
                [product setObject:skProduct forKey:@"SKProduct"];
            }
        }
    }
    
    if(delegate != nil && [delegate respondsToSelector:@selector(didRetrieveProducts:)]){
        
        [delegate didRetrieveProducts:theProducts];
    }
    else
    {
        [self displayStoreFront];        

    }
}

/* displayStoreFront
   If we received product information from apple
   display the built in basic store
*/
-(void)displayStoreFront
{
    if([theProducts count] > 0)
    {
        [productsAlert show];
    }
}

#pragma mark SBTableAlert Methods
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    //get product
    SKProduct *prod = [theProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ for %@", prod.localizedTitle,prod.price];
    return cell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return [theProducts count];
}

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SKProduct *prod = [theProducts objectAtIndex:indexPath.row];
    [self addPayment:prod];
}


#pragma mark payment for product
/* addProduct
   Called to initiate a product transaction
   Delegate should implement a call to this to handle purchasing
*/
-(void)addPayment:(SKProduct*)product
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp showWithMessage:@"Checking with iTunes"];
    [formatter setLocale:product.priceLocale];
    
    NSString *priceStr = [formatter stringFromNumber:product.price];
    
    
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:product.productIdentifier,
     @"PRODUCT_ID",priceStr,
     @"PRODUCT_PRICE",
     nil];
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment]; 
}


#pragma mark SKPaymentTransactionObserver methods
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }

}

-(void)completeTransaction:(SKPaymentTransaction*)transaction
{
    //update content
    [self updateContent:transaction.payment.productIdentifier];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:transaction.payment.productIdentifier,
     @"PRODUCT_ID",nil];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp hide];
    UIAlertView *completeTransaction = [[UIAlertView alloc] initWithTitle:@"Purchase Complete" message:@"Congratulations, Your purchase is completed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [completeTransaction show];
}

-(void)failedTransaction: (SKPaymentTransaction*)transaction
{
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:transaction.payment.productIdentifier,@"PRODUCT_ID",nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp hide];
    UIAlertView *failedTransaction = [[UIAlertView alloc] initWithTitle:@"Purchase Failure" message:@"Sorry, We were unable to complete your transaction.  Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [failedTransaction show];
    
    
    //[self updateContent:transaction.payment.productIdentifier];


}

-(void)restoreTransaction: (SKPaymentTransaction*)transaction
{
    //update prochip count
    [self updateContent:transaction.payment.productIdentifier];

    //remove the transaction from the queue
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)updateContent:(NSString*)contentIdentifier
{
    
    NSMutableDictionary *purchasedProduct;
    for (NSMutableDictionary *product in [DataManager sharedInstance].products) {
        if([[product valueForKey:@"key"] isEqualToString:contentIdentifier]){
            purchasedProduct = product;
        }
    }
    if([[purchasedProduct valueForKey:@"type"] isEqualToString:@"proChips"]){
        [self incrementUserCurrency:[[purchasedProduct valueForKey:@"value"] intValue]];
    }

}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    // save transaction to server?
    
}

#pragma mark user currency methods
-(void)incrementUserCurrency:(NSInteger) newValue
{
   
    
    //add value to server - as currency value
    NSNumber *newV = [NSNumber numberWithInt:newValue];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:[DataManager sharedInstance].myUserID forKey:@"userID"];
    [userDict setValue:newV forKey:@"currency"];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"");
    NSDictionary *results = [self incrementCurrency:jsonString];
    if([[results valueForKey:@"success"] intValue] == 1){
        [DataManager sharedInstance].myProChips = [[results valueForKey:@"currency"] intValue];
        [DataManager sharedInstance].proChipsIncrement = newValue;
    }
    
    //myProChips = [[results valueForKey:@"current_currency"] intValue];

}

-(BOOL)decrementUserCurrency:(NSInteger) newValue
{
    
    
    if(newValue > [[DataManager sharedInstance] getMyProChips]){
        self.notEnoughProChips = YES;
        return NO;
    }
    //add value to server - as currency value
    NSNumber *newV = [NSNumber numberWithInt:newValue];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:[DataManager sharedInstance].myUserID forKey:@"userID"];
    [userDict setValue:newV forKey:@"currency"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"");
    NSDictionary *results = [self decrementCurrency:jsonString];
    if([[results valueForKey:@"success"] intValue] == 1){
        [DataManager sharedInstance].myProChips = [[results valueForKey:@"currency"] intValue];
        [DataManager sharedInstance].proChipsIncrement = -newValue;
    }
    return YES;
}

-(NSInteger)getUserCurrency
{
     NSInteger currentCurrency =  0;
     if( [[NSUserDefaults standardUserDefaults] objectForKey:consumableIndentifier] != nil )
     {
         currentCurrency = [[NSUserDefaults standardUserDefaults] integerForKey:consumableIndentifier];

     }
    
    return currentCurrency;
}

#pragma mark post to Server Methods
-(NSDictionary*)incrementCurrency:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/incrementCurrency",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [[APIDataManager sharedInstance] requestAPIData:jsonData url:urlAddress];
}

-(NSDictionary*)decrementCurrency:(NSString *)jsonData {
    NSString *urlAddress = [NSString stringWithFormat:@"%@/decrementCurrency",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];
    
    return [[APIDataManager sharedInstance] requestAPIData:jsonData url:urlAddress];
}

#pragma mark Connection
-(NSDictionary*)requestAPIData:(NSString *)json url:(NSString*)postUrl
{
    NSData *postData = [json dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSURL *url = [NSURL URLWithString:postUrl];    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:180.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%d", [postData length]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request 
                                             returningResponse:&response error:&error];
    
    NSDictionary *jsonDictionary;
    if(error == nil) {
        
        jsonDictionary = [NSJSONSerialization 
                          JSONObjectWithData:jsonData
                          options:kNilOptions 
                          error:&error];
    }
    else {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:0 forKey:@"success"];
        jsonDictionary = [[NSDictionary alloc] initWithDictionary:dict];
    }
    return jsonDictionary;
    
    
}

-(void)loadProducts{
    //productSet = [[NSSet alloc] initWithObjects:@"com.mobilefringe.slowpoker.removeAds",@"com.mobilefringe.slowpoker.proChips20x",@"com.mobilefringe.slowpoker.proChips50x",@"com.mobilefringe.slowpoker.proChips100x",@"com.mobilefringe.slowpoker.proChips300x", nil];
    
    productSet = [[NSSet alloc] initWithObjects:proChipdentifier1,proChipdentifier2,proChipdentifier3,proChipdentifier4,proChipdentifier5, nil];
    
    
    [self requestProductData];
    //NSLog(@"productSet:%@",productSet);
}


#pragma mark - initialization
- (id) init {
	self = [super init];
	if (self != nil) {
		//custom initialization
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
	}
	return self;
}



#pragma mark ---- singleton object methods ----

+ (StoreFront *)sharedStore {
    @synchronized(self) {
        if (store == nil) {
            [[self alloc] init]; // assignment not done here
			
        }
    }
    return store;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (store == nil) {
            store = [super allocWithZone:zone];
            return store;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
