//
//  InterfaceController.m
//  TipEasyApp WatchKit Extension
//
//  Created by Leon Qi on 2015-07-31.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "CalcInterfaceController.h"
#import "CalcResult.h"
#import "CalcUtil.h"


@interface CalcInterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *displayLabel;
@property (strong, nonatomic) NSString *currentValue;

@property (strong, nonatomic) NSMutableArray *sliderAmountArray;

@property (nonatomic) float taxRate;
@property (nonatomic) float tipRate;
@property (nonatomic) int splitCount;

@property (strong, nonatomic) CalcResult *calcResult;

@end


@implementation CalcInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    self.currentValue = @"0";
    
    if (context) {
        self.sliderAmountArray = (NSMutableArray *)context;
        
        self.taxRate = [CalcUtil stringToNumber:self.sliderAmountArray[0]];
        self.tipRate = [CalcUtil stringToNumber:self.sliderAmountArray[1]];
        self.splitCount = [CalcUtil stringToNumber:self.sliderAmountArray[2]];
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)numberPressed:(int)value {
    NSString *stringValue = [@(value) stringValue];
    //NSLog(@"%@", stringValue);
    if ([self.currentValue isEqualToString: @"0"]) {
        self.currentValue = stringValue;
    } else {
        self.currentValue = [self.currentValue stringByAppendingString:stringValue];
    }
    //NSLog(@"%@", self.currentValue);
    self.displayLabel.text = self.currentValue;
    //NSLog(@"%@", self.displayLabel.text);
}


- (IBAction)number1Pressed {
    [self numberPressed:1];
}

- (IBAction)number2Pressed {
    [self numberPressed:2];
}

- (IBAction)number3Pressed {
    [self numberPressed:3];
}

- (IBAction)number4Pressed {
    [self numberPressed:4];
}

- (IBAction)number5Pressed {
    [self numberPressed:5];
}

- (IBAction)number6Pressed {
    [self numberPressed:6];
}

- (IBAction)number7Pressed {
    [self numberPressed:7];
}

- (IBAction)number8Pressed {
    [self numberPressed:8];
}

- (IBAction)number9Pressed {
    [self numberPressed:9];
}

- (IBAction)number0Pressed {
    [self numberPressed:0];
}

- (IBAction)decimalPressed {
    if ([self.currentValue rangeOfString:@"."].location == NSNotFound) {
        self.currentValue = [self.currentValue stringByAppendingString:@"."];
        self.displayLabel.text = self.currentValue;
    }
}

- (IBAction)deletePressed {
    if (self.currentValue.length <= 1) {
        self.currentValue = @"0";
    } else {
        self.currentValue = [self.currentValue substringToIndex:self.currentValue.length - 1];
    }
    self.displayLabel.text = self.currentValue;
}

- (IBAction)clearPressed {
    self.currentValue = @"0";
    self.displayLabel.text = self.currentValue;
}

- (IBAction)donePressed {
    
    NSLog(@"Done Pressed");
    
    self.calcResult = [[CalcResult alloc] initWithTotal:[CalcUtil stringToNumber:self.currentValue] forTaxRate:self.taxRate andTipRate:self.tipRate splitedBy:self.splitCount];
    NSLog(@"%@", self.calcResult);
    
    [self pushControllerWithName:@"Result" context:self.calcResult];
}

@end



