//
//  InputTextField.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-14.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "InputTextField.h"

@implementation InputTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// override leftViewRectForBounds method:
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftBounds = CGRectMake(bounds.origin.x + 8, 7, 25, 25);
    return leftBounds;
}

@end
