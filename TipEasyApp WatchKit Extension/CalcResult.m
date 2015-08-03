//
//  CalcResult.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-02.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "CalcResult.h"

@implementation CalcResult

- (instancetype)initWithTotal:(float)total forTaxRate:(float)taxRate andTipRate:(float)tipRate splitedBy:(int)count {
    self = [super init];
    if (self) {
        _billTotal = [CalcUtil numberToCurrencyFormat:total];
        _tax = [CalcUtil numberToCurrencyFormat:[CalcUtil calcTaxAmount:total withTaxRate:taxRate]];
        _tip = [CalcUtil numberToCurrencyFormat:[CalcUtil calcTipAmount:total withTaxRate:taxRate andTipRate:tipRate]];
        float grandTotal = [CalcUtil calcGrandTotal:total withTaxRate:taxRate andTipRate:tipRate];
        _totalPay = [CalcUtil numberToCurrencyFormat:grandTotal];
        _eachPay = [CalcUtil numberToCurrencyFormat:(grandTotal / count)];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithTotal:0 forTaxRate:0 andTipRate:0 splitedBy:1];
    return self;
}

@end
