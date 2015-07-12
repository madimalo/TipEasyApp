//
//  ExpendingCell.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-07.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "ExpandingCell.h"
#import "UIImage+FontAwesome.h"
#import "AppDelegate.h"

@implementation ExpandingCell

- (void)awakeFromNib {
    // Initialization code
    self.slider.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider {
    
    [self.superview bringSubviewToFront:self];
}

//- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider {
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (!appDelegate.isAppActive) {
//        [self removeFromSuperview];
//    }
//
//    
//}

@end
