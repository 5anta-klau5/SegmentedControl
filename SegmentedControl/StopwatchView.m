//
//  StopwatchView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "StopwatchView.h"

typedef enum: NSUInteger {
    StopwatchStateReady,
    StopwatchStateStart,
    StopwatchStateStarted,
    StopwatchStatePause,
    StopwatchStatePaused,
    StopwatchStateCircle,
    StopwatchStateReset
} StopwatchStateType;

@interface StopwatchView ()
{
    
    StopwatchStateType _currentWatchState;
}
@end

@implementation StopwatchView


double startTime;
double beforeStopTime = 0.0;
double beforeStopCircleTime = 0.0;
double lastCircleTime = 0.0;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentWatchState = StopwatchStateReady;
    }
    return self;
}

- (IBAction)pushStartStopBtn:(id)sender {
    NSLog(@"pushStartStopBtn before pressed %@  %i",self, _currentWatchState);

    switch (_currentWatchState) {
        case StopwatchStateReady:
            [self setStopwatchState:StopwatchStateStart];
            break;
        case StopwatchStatePaused:
            [self setStopwatchState:StopwatchStateStart];
            break;
        case StopwatchStateStarted:
            [self setStopwatchState:StopwatchStatePause];
            break;
        default:
            break;
    }
    NSLog(@"pushStartStopBtn after pressed %@  %i",self, _currentWatchState);
//    if (currentWatchState == StopwatchStateReady | currentWatchState == StopwatchStatePaused) {
//        [self setStopwatchState:StopwatchStateStart];
//    } else if (currentWatchState == StopwatchStateStarted) {
//        [self setStopwatchState:StopwatchStatePause];
//    }
}

- (IBAction)pushResetCircleBtn:(id)sender {
    NSLog(@"pushResetCircleBtn before pressed %@  %i",self, _currentWatchState);
    switch (_currentWatchState) {
        case StopwatchStateStarted:
            [self setStopwatchState:StopwatchStateCircle];
            break;
        case StopwatchStatePaused:
            [self setStopwatchState:StopwatchStateReset];
            break;
        default:
            break;
    }
    NSLog(@"pushResetCircleBtn after pressed %@  %i",self, _currentWatchState);
//    if (currentWatchState == StopwatchStateStarted) {
//        [self setStopwatchState:StopwatchStateCircle];
//    } else if (currentWatchState == StopwatchStatePaused) {
//        [self setStopwatchState:StopwatchStateReset];
//    }
}

- (void)setStopwatchState:(StopwatchStateType)state {
    if (state == StopwatchStateStart) {
        _currentWatchState = StopwatchStateStarted;
        [self startTimer];
    } else if (state == StopwatchStatePause) {
        double stopTime = [NSDate timeIntervalSinceReferenceDate];
        beforeStopTime += stopTime - startTime;
        beforeStopCircleTime += stopTime - lastCircleTime;
        [self stopTimer];
        _currentWatchState = StopwatchStatePaused;
    } else if (state == StopwatchStateCircle) {
//        [circleList addObject:self.circleTimeText.text];
        lastCircleTime = [NSDate timeIntervalSinceReferenceDate];
        beforeStopCircleTime = 0.0;
//        [self.circleTable reloadData];
    } else if (state == StopwatchStateReset) {
        [self stopTimer];
        startTime = 0.0;
        beforeStopTime = 0.0;
        beforeStopCircleTime = 0.0;
        lastCircleTime = 0.0;
//        [circleList removeAllObjects];
        _currentWatchState = StopwatchStateReady;
        [self.watchTimeText setText:@"00:00.00"];
//        [self.circleTimeText setText:@"00:00.00"];
//        [self.circleTable reloadData];
    }
    [self changeButtonsForState:state];
}

- (void)changeButtonsForState:(StopwatchStateType)state {
    switch (state) {
        case StopwatchStateStart:
            [self.startStopBtn setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            self.resetCircleBtn.enabled = YES;
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil) forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case StopwatchStatePause:
            [self.startStopBtn setTitle:NSLocalizedString(@"Resume", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Reset", nil) forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case StopwatchStateReset:
            [self.startStopBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil)  forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:[UIColor colorWithRed:85/255.0
                                                               green:85/255.0
                                                                blue:85/255.0
                                                               alpha:1.0] forState:UIControlStateNormal];
            self.resetCircleBtn.enabled = NO;
            break;
        default:
            break;
    }
/*    if (state == StopwatchStateStart) {
        [self.startStopBtn setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
        [self.startStopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        self.resetCircleBtn.enabled = YES;
        [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil) forState:UIControlStateNormal];
        [self.resetCircleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (state == StopwatchStatePause) {
        [self.startStopBtn setTitle:NSLocalizedString(@"Resume", nil) forState:UIControlStateNormal];
        [self.startStopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        [self.resetCircleBtn setTitle:NSLocalizedString(@"Reset", nil) forState:UIControlStateNormal];
        [self.resetCircleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (state == StopwatchStateReset) {
        [self.startStopBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [self.startStopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil)  forState:UIControlStateNormal];
        [self.resetCircleBtn setTitleColor:[UIColor colorWithRed:85/255.0
                                                     green:85/255.0
                                                      blue:85/255.0
                                                     alpha:1.0] forState:UIControlStateNormal];
        self.resetCircleBtn.enabled = NO;
    }
*/
}

- (void)startTimer {
    startTime = [NSDate timeIntervalSinceReferenceDate];
    lastCircleTime = startTime;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                    target:self
                                                  selector:@selector(ticTac)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.myTimer isValid]) {
        [self.myTimer invalidate];
    }
    //    self.myTimer = nil;
}

- (void)ticTac {
    if (_currentWatchState == StopwatchStateStarted) {
        double currentTime = [NSDate timeIntervalSinceReferenceDate];
        double totalSeconds = currentTime - startTime + beforeStopTime;
        
        double circleTime = currentTime - lastCircleTime + beforeStopCircleTime;
        
        NSString *timeText = [self createTimeFromSeconds:totalSeconds];
        [self.watchTimeText setText:timeText];
        
        NSString *circleTimeText = [self createTimeFromSeconds:circleTime];
//        [self.circleTimeText setText:circleTimeText];
        
    }
}

- (NSString *)createTimeFromSeconds:(double)seconds {
    double extraSeconds = fmod(seconds, 60.0);
    int minutes = (int)seconds / 60;
    
    NSString *sec = [NSString stringWithFormat:@"%.2f", extraSeconds];
    if (extraSeconds < 10) {
        sec = [NSString stringWithFormat:@"0%.2f", extraSeconds];
    }
    
    NSString *min = [NSString stringWithFormat:@"%i", minutes];
    if (minutes < 10) {
        min = [NSString stringWithFormat:@"0%i", minutes];
    }
    
    NSString *timeText = [NSString stringWithFormat:@"%@:%@", min, sec];
    
    return timeText;
}
@end
