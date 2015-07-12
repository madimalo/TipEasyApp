//
//  ExpendingCell.h
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-07.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@interface ExpandingCell : UITableViewCell <ASValueTrackingSliderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider;

@end
