//
//  TimerView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/15/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "TimerView.h"
#import "Utils.h"

typedef enum: NSUInteger {
    CountdownStateReady,
    CountdownStateStart,
    CountdownStatePause,
    CountdownStateResume,
    CountdownStateCancel
} CountdownStateType;

@interface TimerView() {
    double _secondsLeft;
    NSTimeInterval _countDownInterval;
    NSTimer *_myTimer;
    NSDate *_lastFireDateOfTimer;
    NSDate *_pauseStartDate;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myDatePicker.countDownDuration = 60.0f ;
    });
}

- (IBAction)datePickerChanged:(UIDatePicker *)datePicker {
//    NSLog(@"datePicker changed");
}

- (IBAction)pushedStartPauseBtn:(UIButton *)sender {
    switch (_currentCountdownState) {
        case CountdownStateReady:
            [self setCountDownState:CountdownStateStart];
            break;
        case CountdownStateStart:
            [self setCountDownState:CountdownStatePause];
            break;
        case CountdownStatePause:
            [self setCountDownState:CountdownStateResume];
            break;
        case CountdownStateResume:
            [self setCountDownState:CountdownStatePause];
            break;
        default:
            break;
    }
}

- (IBAction)pushedCancelBtn:(UIButton *)sender {
    [self setCountDownState:CountdownStateCancel];
}

- (void)setCountDownState:(CountdownStateType)state {
    [self changeButtonsForState:state];
    
    _currentCountdownState = state;
    switch (state) {
        case CountdownStateStart: {
            _countDownInterval = (NSTimeInterval)_myDatePicker.countDownDuration;
            _secondsLeft = _countDownInterval;
            self.selectedTime.text = [Utils createTimeFromSeconds:_secondsLeft withFormat:TimeFormatForTimer];
            [self startTimer];
            self.myDatePicker.hidden = YES;
            self.selectedTime.hidden = NO;
            self.alertMsg.text = @"";
            break;
        }
        case CountdownStatePause: {
            _lastFireDateOfTimer = [_myTimer fireDate];
            _pauseStartDate = [NSDate date];

            [_myTimer setFireDate:[NSDate distantFuture]];
            break;
        }
        case CountdownStateResume: {
            NSDate *resumeDate = [NSDate date];
            float pauseTime = [resumeDate timeIntervalSinceDate:_pauseStartDate];
            [_myTimer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:_lastFireDateOfTimer]];
            break;
        }
        case CountdownStateCancel: {
            [self stopTimer];
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
    UIColor *startPauseBtnColor;
    NSString *startPauseButtonTitle;
    switch (state) {
        case CountdownStateStart: {
            startPauseBtnColor = [UIColor redColor];
            startPauseButtonTitle = NSLocalizedString(@"Pause", nil);
            
            [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.cancelBtn.enabled = YES;
            break;
        }
        case CountdownStatePause: {
            startPauseBtnColor = [UIColor greenColor];
            startPauseButtonTitle = NSLocalizedString(@"Resume", nil);
            break;
        }
        case CountdownStateResume: {
            startPauseBtnColor = [UIColor redColor];
            startPauseButtonTitle = NSLocalizedString(@"Pause", nil);
            break;
        }
        case CountdownStateCancel: {
            startPauseBtnColor = [UIColor greenColor];
            startPauseButtonTitle = NSLocalizedString(@"Start", nil);
            
            [self.cancelBtn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.cancelBtn.enabled = NO;
            break;
        }
        default:
            break;
    }
    [self.startPauseBtn setTitle:startPauseButtonTitle forState:UIControlStateNormal];
    [self.startPauseBtn setTitleColor:startPauseBtnColor forState:UIControlStateNormal];
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
        [_myTimer invalidate];
    }
    _myTimer = nil;
}

- (void)updateCountDown {
    _secondsLeft --;

    self.selectedTime.text = [Utils createTimeFromSeconds:_secondsLeft withFormat:TimeFormatForTimer];
    if (_secondsLeft == 0) {
        self.alertMsg.text = NSLocalizedString(@"Time is UP!", nil);
        [self setCountDownState:CountdownStateCancel];
    }
}

@end
