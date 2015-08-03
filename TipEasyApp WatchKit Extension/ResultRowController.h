//
//  ResultRowController.h
//  TipEasyApp
//
//  Created by Leon Qi on 2015-08-02.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface ResultRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *billTotalLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *taxLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *tipLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *eachPayLabel;



@end
