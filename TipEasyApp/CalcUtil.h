//
//  CalcUtil.h
//  TipSmart
//
//  Created by Leon Qi on 2015-07-03.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcUtil : NSObject

//formatters
+ (float)stringToNumber:(NSString *)string;
+ (NSString *)numberToString:(float)floatNumber;
+ (NSString *)numberToPercentStyle:(float)floatNumber;
+ (NSString *)numberToCurrencyFormat:(float)floatNumber;

//calculations
+ (float)calcGrandTotal:(float)amount withTaxRate:(float)taxRate andTipRate:(float)tipRate;
+ (float)calcTaxAmount:(float)amount withTaxRate:(float)taxRate;
+ (float)calcTipAmount:(float)amount withTaxRate:(float)taxRate andTipRate:(float)tipRate;

@end
