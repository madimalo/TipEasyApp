//
//  TEATableViewController.h
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-07.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEATableViewController : UITableViewController

typedef enum {
    TEATableViewSectionSliders = 0,
    TEATableViewSectionInputField = 1,
    TEATableViewSectionResults = 2
} TEATableViewSection;

typedef enum {
    TEASlidersSectionTaxRateRow = 0,
    TEASlidersSectionTipRateRow = 1,
    TEASlidersSectionBillSplitRow = 2
} TEASlidersSection;

typedef enum {
    TEAResultsSectionTotalBillRow = 0,
    TEAResultsSectionTaxPaidRow = 1,
    TEAResultsSectionTipPaidRow = 2,
    TEAResultsSectionGrandTotalRow = 3,
    TEAResultsSectionEachPayRow = 4
} TEAResultsSection;



@end
