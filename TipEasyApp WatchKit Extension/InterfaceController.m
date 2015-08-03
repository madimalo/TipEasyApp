//
//  InterfaceController.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-02.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController ()

@property (strong, nonatomic) NSMutableArray *sliderAmountArray;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.madimalo.TipEasyApp.watch.defaults"];
    self.sliderAmountArray = [[defaults objectForKey:@"sliderAmountArray"] mutableCopy];
    
    if (!self.sliderAmountArray) {
        self.sliderAmountArray = [@[@"0.05", @"0.15", @"1"] mutableCopy];
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

- (IBAction)SettingsPressed {
    [self presentControllerWithName:@"Settings" context:self.sliderAmountArray];
}

- (IBAction)CalculatePressed {
    [self pushControllerWithName:@"Calculate" context:self.sliderAmountArray];
}

@end



