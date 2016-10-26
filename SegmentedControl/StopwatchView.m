//
//  StopwatchView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "StopwatchView.h"

@implementation StopwatchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"StopwatchView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (IBAction)pushStartStopBtn:(id)sender {
    self.watchTimeText.text = @"Start";
    NSLog(@"start button pressed");
}

- (IBAction)pushResetCircleBtn:(id)sender {
    NSLog(@"reset button pressed");
}
@end
