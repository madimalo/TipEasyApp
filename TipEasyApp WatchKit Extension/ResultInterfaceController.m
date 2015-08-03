//
//  ResultInterfaceController.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-01.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "ResultInterfaceController.h"
#import "CalcResult.h"
#import "ResultRowController.h"

@interface ResultInterfaceController ()

@property (strong, nonatomic) CalcResult *result;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *resultTable;

@end

@implementation ResultInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if (context) {
        self.result = (CalcResult *)context;
    }
    [self reloadTable];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)reloadTable {
    [self.resultTable setNumberOfRows:1 withRowType:@"ResultRow"];
    
    ResultRowController *row = [self.resultTable rowControllerAtIndex:0];
    
    row.billTotalLabel.text = self.result.billTotal;
    row.taxLabel.text = self.result.tax;
    row.tipLabel.text = self.result.tip;
    row.totalPayLabel.text = self.result.totalPay;
    row.eachPayLabel.text = self.result.eachPay;
}

@end



