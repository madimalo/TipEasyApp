//
//  CalcUtil.m
//  TipSmart
//
//  Created by Leon Qi on 2015-07-03.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "CalcUtil.h"

@implementation CalcUtil

#pragma mark -
#pragma mark Formatters

+ (float)stringToNumber:(NSString *)string {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *returnNumber = [numberFormatter numberFromString:string];
    return returnNumber.floatValue;
}

+ (NSString *)numberToString:(float)floatNumber {
    NSNumber *number = [NSNumber numberWithFloat:floatNumber];
    NSString *returnString = [number stringValue];
    return returnString;
}

+ (NSString *)numberToPercentStyle:(float)floatNumber {
    
    //assume floatNumber < 1.0, because max tax/tip rate set to 0.3
    if (floatNumber >= 1.0) {
        return [self numberToString:floatNumber];
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    //[formatter setMinimumFractionDigits:2];  //optional
    
    NSNumber *number = [NSNumber numberWithFloat:floatNumber];
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)numberToCurrencyFormat:(float)floatNumber {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatNumber]];
    
}

#pragma mark -
#pragma mark Calculations
+ (float)calcGrandTotal:(float)amount withTaxRate:(float)taxRate andTipRate:(float)tipRate {
    float tipAmount = [CalcUtil calcTipAmount:amount withTaxRate:taxRate andTipRate:tipRate];
    return (amount+tipAmount);
}

+ (float)calcTaxAmount:(float)amount withTaxRate:(float)taxRate {
    return (amount - amount / (1.0+taxRate));
}

+ (float)calcTipAmount:(float)amount withTaxRate:(float)taxRate andTipRate:(float)tipRate {
    return ((amount / (1.0+taxRate)) * tipRate);
}

@end
