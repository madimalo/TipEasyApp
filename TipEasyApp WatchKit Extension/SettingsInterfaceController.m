//
//  SettingsInterfaceController.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-02.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "SettingsInterfaceController.h"
#import "CalcUtil.h"

@interface SettingsInterfaceController ()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *taxSliderLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *taxSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *tipSliderLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *tipSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *billSplitLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *billSplitSlider;

@property (strong, nonatomic) NSMutableArray *sliderAmountArray;


@end

@implementation SettingsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if (context) {
        self.sliderAmountArray = (NSMutableArray *)context;
        
        float taxRate = [CalcUtil stringToNumber:self.sliderAmountArray[0]];
        self.taxSliderLabel.text = [CalcUtil numberToPercentStyle:taxRate withFractionDigits:2];
        self.taxSlider.value = taxRate;
        
        float tipRate = [CalcUtil stringToNumber:self.sliderAmountArray[1]];
        self.tipSliderLabel.text = [CalcUtil numberToPercentStyle:tipRate];
        self.tipSlider.value = tipRate;
        
        float splitCount = [CalcUtil stringToNumber:self.sliderAmountArray[2]];
        self.billSplitLabel.text = [CalcUtil numberToString:splitCount];
        self.billSplitSlider.value = splitCount;
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

- (IBAction)taxSliderValueDidChange:(float)value {
    self.taxSliderLabel.text = [CalcUtil numberToPercentStyle:value withFractionDigits:2];
    self.sliderAmountArray[0] = [CalcUtil numberToString:value];
}


- (IBAction)tipSliderValueDidChange:(float)value {
    self.tipSliderLabel.text = [CalcUtil numberToPercentStyle:value];
    self.sliderAmountArray[1] = [CalcUtil numberToString:value];
}

- (IBAction)splitSliderValueDidChange:(float)value {
    self.billSplitLabel.text = [CalcUtil numberToString:value];
    self.sliderAmountArray[2] = [CalcUtil numberToString:value];
}

- (IBAction)savePressed {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.madimalo.TipEasyApp.watch.defaults"];
    [defaults setObject:self.sliderAmountArray forKey:@"sliderAmountArray"];
    [defaults synchronize];
    
    [self dismissController];
}


@end



