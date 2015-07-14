//
//  TEATableViewController.m
//  TipEasyApp
//
//  Created by Leon Qi on 2015-07-07.
//  Copyright (c) 2015 Leon Qi. All rights reserved.
//

#import "TEATableViewController.h"
#import "InputCell.h"
#import "ExpandingCell.h"
#import "ResultCell.h"
#import "BSKeyboardControls.h"
#import "ASValueTrackingSlider.h"
#import "ASValuePopUpView.h"
#import "UIImage+FontAwesome.h"
#import "CalcUtil.h"


@interface TEATableViewController () <UITextFieldDelegate, BSKeyboardControlsDelegate>

@property (nonatomic) NSInteger selectedIndex;

//section inputTextField
//input total bill
@property (nonatomic) float totalBill;

//section sliders
@property (strong, nonatomic) NSArray *sliderTitleArray;
@property (strong, nonatomic) NSMutableArray *sliderAmountArray; //defaults of slider values
@property (strong, nonatomic) NSArray *hintArray;
//setup keyboard
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic) BOOL numeric;
@property (nonatomic) BOOL decimalNumeric;
@property (nonatomic) NSInteger maxCharacters;
//setup to reference slider
@property (nonatomic, strong) ASValueTrackingSlider *trackingSlider;
@property (nonatomic, strong) UILabel *sliderLabel;

//section results
@property (strong, nonatomic) NSArray *amountTitleArray;
@property (nonatomic) float grandTotalAmount;
@property (nonatomic) float taxAmount;
@property (nonatomic) float tipAmount;
@property (nonatomic) float eachPayAmount;

@end

@implementation TEATableViewController

//slider min, max values confiuration
const float kTEAMINRATE = 0;
const float kTEATAXMAXRATE = 0.2;
const float kTEATIPMAXRATE = 0.3;

const int kTEAMINPERSONS = 1;
const int kTEAMAXPERSONS = 12;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.selectedIndex = -1;

    //setup data
    //reload saved data first
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"hasLaunchedOnce"]) {
        self.sliderAmountArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"sliderAmountArray"]];
    } else {
        [defaults setBool:YES forKey:@"hasLaunchedOnce"];
        [defaults synchronize];
        self.sliderAmountArray = [@[@"0.05", @"0.15", @"1"] mutableCopy];
    }
    
    self.sliderTitleArray = @[@"Tax Rate", @"Tip Percentage", @"Bill Splited By"];
    self.hintArray = @[@"Hint: set the total tax rate for this payment.", @"Hint: set the tip precentage you want to give.", @"Hint: set how many bills you want to split."];
    
    self.amountTitleArray = @[@"Bill Total", @"Tax Included", @"Tip to Pay", @"Total to Pay", @"Each to Pay"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell" bundle:nil] forCellReuseIdentifier:@"InputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpandingCell" bundle:nil] forCellReuseIdentifier:@"ExpandingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];
    
    //setup keyboard filter
    self.numeric = YES;
    self.decimalNumeric = YES;
    self.maxCharacters = 8;
    
    //add different color on top bouncing area
    //FIXME: error on lanscape mode -fixed. Now only allow portrait mode.
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView *grayView = [[UIView alloc] initWithFrame:frame];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView addSubview:grayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case TEATableViewSectionInputField:
            return 1;
        case TEATableViewSectionSliders:
            return 3;
        case TEATableViewSectionResults:
            return 5;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case TEATableViewSectionInputField:
            return @"Step 2: What to Calculate?";
        case TEATableViewSectionSliders:
            return @"Step 1: How to Calculate?";
        case TEATableViewSectionResults:
            return @"Step 3: What to Pay?";
        default:
            return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case TEATableViewSectionInputField:
            return @"You should enter the final amount after any taxes.";
        case TEATableViewSectionSliders:
            return @"You may click each row to reset each value.";
        case TEATableViewSectionResults:
            return @"You may choose the amount to pay.\n\n*Note: 1. Tip is calculated on pre-tax amount. If you prefer paying on after-tax amount, simply set the tax rate to 0%. 2. If the full percentage points tax rate do not apply to your province or state, please set to the nearest percentage point, then tip will be approximately plus or minus 1% than the real result.";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == TEATableViewSectionInputField) {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell" forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
            cell = (InputCell *)[nib objectAtIndex:0];
        }

        self.inputTextField = cell.inputTextField;
        NSArray *fields = @[self.inputTextField];
        self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
        self.keyboardControls.delegate = self;
        self.inputTextField.delegate = self;
        
        [self updateUIForInputTextField];
        
        return cell;
        
    } else if (indexPath.section == TEATableViewSectionSliders) {
        ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpandingCell" forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self options:nil];
            cell = (ExpandingCell *)[nib objectAtIndex:0];
        }

        cell.titleLabel.text = self.sliderTitleArray[indexPath.row];
        cell.hintLabel.text = self.hintArray[indexPath.row];
        
        float sliderValue = [CalcUtil stringToNumber:self.sliderAmountArray[indexPath.row]];
        cell.detailLabel.text = [CalcUtil numberToPercentStyle:sliderValue];
        
        //add angle-down image
        UIImage *angleImage = [UIImage imageWithIcon:@"fa-angle-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:angleImage];
        cell.accessoryView = imageView;
        
        cell.clipsToBounds = YES;

        //setup slider
        [self setupSlider:cell.slider withValue:sliderValue displayForRowAtIndexPath:indexPath];
        
        self.sliderLabel = cell.detailLabel;
        self.trackingSlider = cell.slider;
        
        //expand cell
        if (self.selectedIndex == indexPath.row) {

            cell.backgroundColor = [UIColor lightGrayColor];
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:18];
            cell.detailLabel.textColor = [UIColor whiteColor];
            cell.detailLabel.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:18];
            
            //change angle-down to angle-up image
            UIImage *angleImage = [UIImage imageWithIcon:@"fa-angle-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:angleImage];
            cell.accessoryView = imageView;
            
            [cell.slider showPopUpViewAnimated:YES];
            
            //slider changing values
            cell.slider.continuous = YES;
            
            [cell.slider addTarget:self
                            action:@selector(sliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
          
        //collapse cell
        } else {
            [cell.slider removeTarget:self
                               action:@selector(sliderValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
            cell.backgroundColor = [UIColor whiteColor];
            [cell.slider hidePopUpViewAnimated:YES];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OriyaSangamMN" size:18];
            cell.detailLabel.textColor = [UIColor blackColor];
            cell.detailLabel.font = [UIFont fontWithName:@"OriyaSangamMN" size:18];
            
        }
        return cell;
        
    } else if (indexPath.section == TEATableViewSectionResults) {
        ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResultCell" owner:self options:nil];
            cell = (ResultCell *)[nib objectAtIndex:0];
        }
        cell.amountTitleLabel.text = self.amountTitleArray[indexPath.row];
        
        [self doCalculations];
        
        switch (indexPath.row) {
            case TEAResultsSectionGrandTotalRow:
                cell.valueLabel.text = [CalcUtil numberToCurrencyFormat:self.grandTotalAmount];
                break;
            case TEAResultsSectionTotalBillRow:
                cell.valueLabel.text = [CalcUtil numberToCurrencyFormat:self.totalBill];
                break;
            case TEAResultsSectionTaxPaidRow:
                cell.valueLabel.text = [CalcUtil numberToCurrencyFormat:self.taxAmount];
                break;
            case TEAResultsSectionTipPaidRow:
                cell.valueLabel.text = [CalcUtil numberToCurrencyFormat:self.tipAmount];
                break;
            case TEAResultsSectionEachPayRow:
                cell.valueLabel.text = [CalcUtil numberToCurrencyFormat:self.eachPayAmount];
                break;
            default:
                cell.valueLabel.text = @"";
                break;
        }

        return cell;
    } else {
        return nil;
    }
    
}

- (void)sliderValueChanged:(id)sender {
    float sliderValue = self.trackingSlider.value;
    if (sliderValue > kTEATIPMAXRATE) {
        //increment 1 by 1
        [self.trackingSlider setValue:floorf(sliderValue) animated:NO];
        self.sliderLabel.text = [CalcUtil numberToPercentStyle:floorf(sliderValue)];
        [self.sliderAmountArray replaceObjectAtIndex:self.selectedIndex withObject:[CalcUtil numberToString:floorf(sliderValue)]];
    } else {
        float sliderValue100 = sliderValue * 100.0;
        sliderValue = floorf(sliderValue100) / 100.0;
        [self.trackingSlider setValue:sliderValue animated:NO];
        self.sliderLabel.text = [CalcUtil numberToPercentStyle:sliderValue];
        [self.sliderAmountArray replaceObjectAtIndex:self.selectedIndex withObject:[CalcUtil numberToString:sliderValue]];
    }
    [self doCalculations];
    [self reloadResultsSection];
    [self saveData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TEATableViewSectionSliders) {
        //Taps expanded row
        if (self.selectedIndex == indexPath.row) {
            
            self.selectedIndex = -1;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        //Taps different row
        if (self.selectedIndex != -1) {
            NSIndexPath *prePath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:TEATableViewSectionSliders];
            self.selectedIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prePath] withRowAnimation:UITableViewRowAnimationFade];
        }
        //Taps a not expanded row
        self.selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TEATableViewSectionSliders && self.selectedIndex == indexPath.row) {
        return 130;
    }
    return 44;
}

#pragma mark -
#pragma mark section InputField - setup textfield
// Create inputTextField - NOT USING IT ANYMORE
//- (UITableViewCell *)setupInputTextFieldInsideCell {
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    //config cell appearance
//    //cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    self.inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(30,5,260,34)]; //need to use auto layout
//    NSArray *fields = @[self.inputTextField];
//    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
//    
//    self.keyboardControls.delegate = self;
//    self.inputTextField.delegate = self;
//    
//    self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
//    
//    self.inputTextField.textAlignment = NSTextAlignmentCenter;
//    self.inputTextField.backgroundColor = [UIColor clearColor];
//    self.inputTextField.placeholder = @"Enter here to begin...";
//    //placeholder image
//    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
//    UIImage *calcImage = [UIImage imageWithIcon:@"fa-calculator" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
//    self.inputTextField.leftView = [[UIImageView alloc] initWithImage:calcImage];
//    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    [cell.contentView addSubview:self.inputTextField];
//    
//    return cell;
//}

- (void)updateUIForInputTextField {
    
    //self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    //self.inputTextField.textAlignment = NSTextAlignmentCenter;
    self.inputTextField.backgroundColor = [UIColor clearColor];
    //remove cursor
    //self.inputTextField.tintColor = [UIColor clearColor];
    self.inputTextField.placeholder = @"Tap here to begin...";
    //placeholder image
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImage *calcImage = [UIImage imageWithIcon:@"fa-calculator" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
    self.inputTextField.leftView = [[UIImageView alloc] initWithImage:calcImage];
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

}

#pragma mark -
#pragma mark section Sliders - setup slider

- (void)setupSlider:(ASValueTrackingSlider *)slider withValue:(float)value displayForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    if (indexPath.row == TEASlidersSectionTaxRateRow) {
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [slider setNumberFormatter:formatter];
        slider.minimumValue = kTEAMINRATE;
        slider.maximumValue = kTEATAXMAXRATE;
        if (value >= kTEAMINRATE && value <= kTEATAXMAXRATE) {
            slider.value = value;
        } else {
            slider.value = (kTEATAXMAXRATE + kTEAMINRATE) / 2;
        }
        slider.minimumValue = kTEAMINRATE;
        slider.maximumValue = kTEATAXMAXRATE;
        slider.minimumValueImage = [UIImage imageWithIcon:@"fa-arrow-circle-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
        slider.maximumValueImage = [UIImage imageWithIcon:@"fa-arrow-circle-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
        
        slider.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:16];
        slider.textColor = [UIColor lightGrayColor];
        slider.popUpViewColor = [UIColor whiteColor];
        slider.autoAdjustTrackColor = NO;
        slider.minimumTrackTintColor = [UIColor whiteColor];

    } else if (indexPath.row == TEASlidersSectionTipRateRow){
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [slider setNumberFormatter:formatter];
        slider.minimumValue = kTEAMINRATE;
        slider.maximumValue = kTEATIPMAXRATE;
        if (value >= kTEAMINRATE && value <= kTEATIPMAXRATE) {
            slider.value = value;
        } else {
            slider.value = (kTEATIPMAXRATE + kTEAMINRATE) / 2;
        }
        
        slider.minimumValueImage = [UIImage imageWithIcon:@"fa-frown-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
        slider.maximumValueImage = [UIImage imageWithIcon:@"fa-smile-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    
        slider.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:16];
        slider.textColor = [UIColor lightGrayColor];
        slider.popUpViewColor = [UIColor whiteColor];
        slider.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor whiteColor], [UIColor greenColor]];
        
    } else {
        [formatter setNumberStyle:NSNumberFormatterNoStyle];
        [slider setNumberFormatter:formatter];
        slider.minimumValue = kTEAMINPERSONS;
        slider.maximumValue = kTEAMAXPERSONS;
        if (value >= kTEAMINPERSONS && value <= kTEAMAXPERSONS) {
            slider.value = value;
        } else {
            slider.value = (kTEAMAXPERSONS + kTEAMINPERSONS) / 2;
        }
        
        slider.minimumValueImage = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
        slider.maximumValueImage = [UIImage imageWithIcon:@"fa-users" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];

        slider.font = [UIFont fontWithName:@"OriyaSangamMN-Bold" size:16];
        slider.textColor = [UIColor lightGrayColor];
        slider.popUpViewColor = [UIColor whiteColor];
        slider.autoAdjustTrackColor = NO;
        slider.minimumTrackTintColor = [UIColor whiteColor];
    }
}

#pragma mark -
#pragma mark section Results - Calculation

- (void)doCalculations {
    
    float total = self.totalBill;
    float taxRate = [CalcUtil stringToNumber:self.sliderAmountArray[TEASlidersSectionTaxRateRow]];
    float tipRate = [CalcUtil stringToNumber:self.sliderAmountArray[TEASlidersSectionTipRateRow]];
    int billSplitCount = (int)[CalcUtil stringToNumber:self.sliderAmountArray[TEASlidersSectionBillSplitRow]];
    self.grandTotalAmount = [CalcUtil calcGrandTotal:total withTaxRate:taxRate andTipRate:tipRate];
    self.taxAmount = [CalcUtil calcTaxAmount:total withTaxRate:taxRate];
    self.tipAmount = [CalcUtil calcTipAmount:total withTaxRate:taxRate andTipRate:tipRate];
    self.eachPayAmount = self.grandTotalAmount / billSplitCount;
    
}

- (void)reloadResultsSection {
    //reload results section
    NSRange range = NSMakeRange(TEATableViewSectionResults, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.placeholder = @"0";
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.numeric || self.decimalNumeric)
    {
        NSString *fulltext = [textField.text stringByAppendingString:string];
        NSString *charactersSetString = @"0123456789";
        
        // For decimal keyboard, allow "dot" and "comma" characters.
        if(self.decimalNumeric) {
            charactersSetString = [charactersSetString stringByAppendingString:@".,"];
        }
        
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:charactersSetString];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:fulltext];
        
        // If typed character is out of Set, ignore it.
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        if(!stringIsValid) {
            return NO;
        }
        
        if(self.decimalNumeric)
        {
            NSString *currentText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            // Change the "," (appears in other locale keyboards, such as russian) key ot "."
            currentText = [currentText stringByReplacingOccurrencesOfString:@"," withString:@"."];
            
            // Check the statements of decimal value.
            if([fulltext isEqualToString:@"."]) {
                textField.text = @"0.";
                return NO;
            }
            
            if([fulltext rangeOfString:@".."].location != NSNotFound) {
                textField.text = [fulltext stringByReplacingOccurrencesOfString:@".." withString:@"."];
                return NO;
            }
            
            // If second dot is typed, ignore it.
            NSArray *dots = [fulltext componentsSeparatedByString:@"."];
            if(dots.count > 2) {
                textField.text = currentText;
                return NO;
            }
            
            // If first character is zero and second character is > 0, replace first with second. 05 => 5;
            if(fulltext.length == 2) {
                if([[fulltext substringToIndex:1] isEqualToString:@"0"] && ![fulltext isEqualToString:@"0."]) {
                    textField.text = [fulltext substringWithRange:NSMakeRange(1, 1)];
                    return NO;
                }
            }
        }
    }
    
    // Check the max characters typed.
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= self.maxCharacters || returnKey;
}

#pragma mark -
#pragma mark BSKeyboardControlsDelegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    self.totalBill = [CalcUtil stringToNumber:self.inputTextField.text];
    [self doCalculations];
    [self reloadResultsSection];
    [self.inputTextField resignFirstResponder];
}

#pragma mark -
#pragma mark Handle data

- (void)saveData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.sliderAmountArray forKey:@"sliderAmountArray"];
    [defaults synchronize];
}

@end
