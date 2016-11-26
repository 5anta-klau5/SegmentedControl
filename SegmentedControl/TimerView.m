//
//  TimerView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/15/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "TimerView.h"

typedef enum: NSUInteger {
    CountdownStateReady,
    CountdownStateStart,
    CountdownStateStarted,
    CountdownStatePause,
    CountdownStatePaused,
    CountdownStateCancel
} CountdownStateType;

@interface TimerView() {
    int _remainder;
    int _afterRemainder;
    int _elapsedTime;
    NSTimeInterval _countDownInterval;
    NSTimer *_myTimer;
    CountdownStateType _currentCountdownState;
}

@end

@implementation TimerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _currentCountdownState = CountdownStateReady;
    _elapsedTime = 0;
    
//    self.myDatePicker.countDownDuration = 120.0f;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myDatePicker.countDownDuration = 120.0f ;
    });
}

- (IBAction)datePickerChanged:(UIDatePicker *)datePicker {
    NSLog(@"datePicker changed");
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
//    dateFormatter.dateFormat = @"HH:mm:ss";
//    
//    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
//    self.selectedTime.text = strDate;
}

- (IBAction)pushedStartPauseBtn:(UIButton *)sender {

    switch (_currentCountdownState) {
        case CountdownStateReady:
            [self setCountDownState:CountdownStateStart];
            break;
        case CountdownStateStarted: {
            [self setCountDownState:CountdownStatePause];
            break;
        }
        case CountdownStatePaused: {
            [self setCountDownState:CountdownStateStart];
            break;
        }
        default:
            break;
    }
}

- (IBAction)pushedCancelBtn:(UIButton *)sender {
    [self setCountDownState:CountdownStateCancel];
}

- (void)setCountDownState:(CountdownStateType)state {
    [self changeButtonsForState:state];
    
    switch (state) {
        case CountdownStateStart: {
            _currentCountdownState = CountdownStateStarted;
            _countDownInterval = (NSTimeInterval)_myDatePicker.countDownDuration;
            _remainder = _countDownInterval;
            _afterRemainder = _countDownInterval - _remainder%60 - _elapsedTime;
            NSLog(@"interval: %f, rem: %i, remainder: %i", _countDownInterval, _remainder, _remainder%60);
            [self updateCountDown];
            [self startTimer];
            self.myDatePicker.hidden = YES;
            self.selectedTime.hidden = NO;
            break;
        }
        case CountdownStatePause: {
            [self stopTimer];
            _currentCountdownState = CountdownStatePaused;
            NSLog(@"%i", _elapsedTime);
            break;
        }
        case CountdownStateCancel: {
            [self stopTimer];
            _elapsedTime = 0;
            self.selectedTime.hidden = YES;
            self.myDatePicker.hidden = NO;
            _currentCountdownState = CountdownStateReady;
            break;
        }
        default:
            break;
    }
}

- (void)changeButtonsForState:(CountdownStateType)state {
    switch (state) {
        case CountdownStateStart:
            [self.startPauseBtn setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
            [self.startPauseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            self.cancelBtn.enabled = YES;
            [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case CountdownStatePause:
            [self.startPauseBtn setTitle:NSLocalizedString(@"Resume", nil) forState:UIControlStateNormal];
            [self.startPauseBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            break;
        case CountdownStateCancel:
            [self.startPauseBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
            [self.startPauseBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [self.cancelBtn setTitleColor:[UIColor colorWithRed:85/255.0
                                                               green:85/255.0
                                                                blue:85/255.0
                                                               alpha:1.0] forState:UIControlStateNormal];
            self.cancelBtn.enabled = NO;
            break;
        default:
            break;
    }
}

- (void)startTimer {
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateCountDown)
                                                  userInfo:nil
                                                   repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
}


- (void)stopTimer {
    if ([_myTimer isValid]) {
//        NSLog(@"stopTimer");
        [_myTimer invalidate];
    }
    _myTimer = nil;
//    NSLog(@"%@", _myTimer);
}

- (void)updateCountDown {
    _elapsedTime++;
    self.selectedTime.text = [self createTimeFromSeconds:_afterRemainder];
    _afterRemainder --;
//    NSLog(@"%d", _afterRemainder);
    if (_afterRemainder == -1) {
        [self setCountDownState:CountdownStateCancel];
        NSLog(@"time is up");
    }
}

- (NSString *)createTimeFromSeconds:(int)seconds {
    int hours = (int)seconds / 3600;
    int minutes = (int)(seconds - hours*3600)/60;
    int extraSeconds = seconds%60;
    
    NSString *sec = [NSString stringWithFormat:@"%i", extraSeconds];
    if (extraSeconds < 10) {
        sec = [NSString stringWithFormat:@"0%i", extraSeconds];
    }
    
    NSString *min = [NSString stringWithFormat:@"%i", minutes];
    if (minutes < 10) {
        min = [NSString stringWithFormat:@"0%i", minutes];
    }
    
    NSString *hour = [NSString stringWithFormat:@"%i", hours];
    if (hours < 10) {
        hour = [NSString stringWithFormat:@"0%i", hours];
    }
    
    NSString *timeText = [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
    
    return timeText;
}

@end
