//
//  CalcResult.h
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-02.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcUtil.h"

@interface CalcResult : NSObject

@property (strong, nonatomic) NSString *billTotal;
@property (strong, nonatomic) NSString *tax;
@property (strong, nonatomic) NSString *tip;
@property (strong, nonatomic) NSString *totalPay;
@property (strong, nonatomic) NSString *eachPay;


- (instancetype)initWithTotal:(float)total forTaxRate:(float)taxRate andTipRate:(float)tipRate splitedBy:(int)count;

@end
