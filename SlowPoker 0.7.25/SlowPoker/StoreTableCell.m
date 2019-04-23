//
//  StoreTableCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreTableCell.h"
#import "MFButton.h"
#import "StoreFront.h"
#import "DataManager.h"


@implementation StoreTableCell

@synthesize itemName;
@synthesize itemDesc;
@synthesize itemIcon;
@synthesize itemValue;
@synthesize buyButton;
@synthesize price;
@synthesize thisProduct;
@synthesize proChip;
@synthesize value;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.itemIcon = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
        itemIcon.image = [UIImage imageNamed:@"pro_chip_back.png"];
        [self.contentView addSubview:itemIcon];
         

        
        
        self.buyButton = [MFButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(165, 5, 80, 38);
        [buyButton setTitle:@"Raise -" forState:UIControlStateNormal];
        [buyButton setImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
        //[raiseButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:1]];
        [buyButton addTarget:self action:@selector(buyProduct) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:buyButton];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 70, buyButton.frame.size.height)];
        price.font = [UIFont boldSystemFontOfSize:18];
        price.adjustsFontSizeToFitWidth = YES;
        price.minimumFontSize = 12;
        price.textAlignment = UITextAlignmentCenter;
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [UIColor whiteColor];
        [buyButton addSubview:price];
        
        self.value = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 11.5, 22, 16)];
        value.font = [UIFont boldSystemFontOfSize:16];
        value.adjustsFontSizeToFitWidth = YES;
        value.minimumFontSize = 12;
        value.textAlignment = UITextAlignmentCenter;
        value.backgroundColor = [UIColor clearColor];
        value.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        [itemIcon addSubview:value];
        
        self.itemName = [[UILabel alloc] initWithFrame:CGRectMake(53, 12, 100,21)];
        itemName.font = [UIFont boldSystemFontOfSize:20];
        itemName.adjustsFontSizeToFitWidth = YES;
        itemName.minimumFontSize = 12;
        itemName.textAlignment = UITextAlignmentCenter;
        itemName.backgroundColor = [UIColor clearColor];
        itemName.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self addSubview:itemName];
        
        self.itemDesc = [[UILabel alloc] initWithFrame:CGRectMake(53, 25, 100,21)];
        itemDesc.font = [UIFont boldSystemFontOfSize:10];
        itemDesc.adjustsFontSizeToFitWidth = YES;
        itemDesc.minimumFontSize = 8;
        itemDesc.textAlignment = UITextAlignmentCenter;
        itemDesc.backgroundColor = [UIColor clearColor];
        itemDesc.textColor = [UIColor colorWithRed:1 green:0.65 blue:.65 alpha:1];
        [self addSubview:itemDesc];
        
        
        
    }
    return self;
}

-(void)setProduct:(NSMutableDictionary *)product{
    self.thisProduct = product;
    value.text = [product valueForKey:@"value"];
    if([[product valueForKey:@"type"] isEqualToString:@"proChips"]){
        itemIcon.image = [UIImage imageNamed:@"pro_chip_back.png"];
        itemIcon.frame = CGRectMake(8, 3, 40, 40);
        value.hidden = NO;
        itemName.text = @"Pro Chips";
        double savings = [self calculateSavings];
        if(savings == 0.00){
            itemDesc.text = @"";
        }else{
            itemDesc.text = [NSString stringWithFormat:@"Save %.0f%@",savings,@"%"];
        }
        
    }else if([[product valueForKey:@"type"] isEqualToString:@"noAds"]){
        itemIcon.image = [UIImage imageNamed:@"unlock.png"];
        itemIcon.frame = CGRectMake(8, 2, 40, 40);
        value.hidden = YES;
        itemName.text = @"Remove Ads";
        itemDesc.text = @"Permanently removes ads";
        
    }
    
    
    SKProduct *skPrduct = [product objectForKey:@"SKProduct"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:skPrduct.priceLocale];
    
    NSString *priceStr = [formatter stringFromNumber:skPrduct.price];
    price.text =  priceStr;
}



-(double)calculateSavings{
    double savings = 0.00;
    int minValue = 9999999999;
    double minPrice = 0.00;
    double unitPrice = 0.00;
    
    
    for (NSMutableDictionary *product in [DataManager sharedInstance].products) {
        if([[product valueForKey:@"value"] intValue] < minValue && [[product valueForKey:@"type"] isEqualToString:@"proChips"]){
            SKProduct *skPrduct = [product objectForKey:@"SKProduct"];
            minValue = [[product valueForKey:@"value"] intValue];
            minPrice = [skPrduct.price doubleValue];
        }
        
    }
    
    if(minValue == [[thisProduct valueForKey:@"value"] intValue]){
        return 0.00;
    }
    
    unitPrice = minPrice/minValue;
    
    double regPrice = unitPrice*[[thisProduct valueForKey:@"value"] intValue];
    SKProduct *skPrduct = [thisProduct objectForKey:@"SKProduct"];
    double savingsDelta = regPrice - [skPrduct.price doubleValue];
    if(savingsDelta < 0){
        savingsDelta = 0;
    }
    savings = savingsDelta/regPrice * 100;
    
    return savings;
    
    
}

-(void)buyProduct{
    [[StoreFront sharedStore] addPayment:(SKProduct*)[thisProduct objectForKey:@"SKProduct"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
