//
//  InputCell.h
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-07.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end
