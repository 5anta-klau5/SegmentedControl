//
//  TimerView.h
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/15/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *selectedTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *someBtn;

- (IBAction)datePickerChanged:(UIDatePicker *)datePicker;

@end
