//
//  TimerView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/15/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)initWithCoder:(NSCoder *)decoder {
//    self = [super initWithCoder:decoder];
//    if (self) {
//        [self.myDatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventTouchDown];
//        [self.someBtn addTarget:self action:@selector(someBtnPressed) forControlEvents:UIControlEventTouchDown];
//    }
//    return self;
//}
//
//- (void)datePickerChanged:(UIDatePicker *)datePicker {
//    NSLog(@"datePicker changed");
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
//    dateFormatter.dateFormat = @"HH:mm";
//    
//    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
//    self.selectedTime.text = strDate;
//}
//
//- (void)someBtnPressed {
//    NSLog(@"Some btn pressed");
//}


- (IBAction)datePickerChanged:(UIDatePicker *)datePicker {
        NSLog(@"datePicker changed");
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateFormat = @"HH:mm";
    
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        self.selectedTime.text = strDate;
}
@end
