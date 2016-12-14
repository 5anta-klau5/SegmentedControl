//
//  StopwatchView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "StopwatchView.h"
#import "CircleCell.h"
#import "Utils.h"

typedef enum: NSUInteger {
    StopwatchStateReady,
    StopwatchStateStart,
//    StopwatchStateStarted,
    StopwatchStatePause,
//    StopwatchStatePaused,
    StopwatchStateCircle,
    StopwatchStateReset
} StopwatchStateType;

@interface StopwatchView ()
{
    
    StopwatchStateType _currentWatchState;
    NSMutableArray *circleList;
    
    double _startTime;
    double _beforeStopTime;
    double _beforeStopCircleTime;
    double _lastCircleTime;
}
@end

@implementation StopwatchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _currentWatchState = StopwatchStateReady;
        _beforeStopTime = 0.0;
        _beforeStopCircleTime = 0.0;
        circleList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (IBAction)pushStartStopBtn:(id)sender {
    switch (_currentWatchState) {
        case StopwatchStateReady:
            [self setStopwatchState:StopwatchStateStart];
            break;
        case StopwatchStatePause:
            [self setStopwatchState:StopwatchStateStart];
            break;
        case StopwatchStateStart:
            [self setStopwatchState:StopwatchStatePause];
            break;
        default:
            break;
    }
}

- (IBAction)pushResetCircleBtn:(id)sender {
    switch (_currentWatchState) {
        case StopwatchStateStart:
            [self setStopwatchState:StopwatchStateCircle];
            break;
        case StopwatchStatePause:
            [self setStopwatchState:StopwatchStateReset];
            break;
        default:
            break;
    }
}

- (void)setStopwatchState:(StopwatchStateType)state {
    [self changeButtonsForState:state];
    switch (state) {
        case StopwatchStateStart: {
            _currentWatchState = state;
            [self startTimer];
            break;
        }
        case StopwatchStatePause: {
            double stopTime = [NSDate timeIntervalSinceReferenceDate];
            _beforeStopTime += stopTime - _startTime;
            _beforeStopCircleTime += stopTime - _lastCircleTime;
            [self stopTimer];
            _currentWatchState = state;
            break;
        }
        case StopwatchStateCircle: {
            [circleList addObject:self.circleTimeText.text];
            _lastCircleTime = [NSDate timeIntervalSinceReferenceDate];
            _beforeStopCircleTime = 0.0;
            [self.circleTable reloadData];
            break;
        }
        case StopwatchStateReset: {
            [self stopTimer];
            _startTime = 0.0;
            _beforeStopTime = 0.0;
            _beforeStopCircleTime = 0.0;
            _lastCircleTime = 0.0;
            [circleList removeAllObjects];
            _currentWatchState = StopwatchStateReady;
            [self.watchTimeText setText:@"00:00.00"];
            [self.circleTimeText setText:@"00:00.00"];
            [self.circleTable reloadData];
        }
            
        default:
            break;
    }
}

- (void)changeButtonsForState:(StopwatchStateType)state {
    UIColor *color;
    switch (state) {
        case StopwatchStateStart: {
            color = [UIColor redColor];
            [self.startStopBtn setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:color forState:UIControlStateNormal];
            
            self.resetCircleBtn.enabled = YES;
            color = [UIColor blackColor];
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil) forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:color forState:UIControlStateNormal];
            break;
        }
        case StopwatchStatePause: {
            color = [UIColor greenColor];
            [self.startStopBtn setTitle:NSLocalizedString(@"Resume", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:color forState:UIControlStateNormal];
            
            color = [UIColor blackColor];
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Reset", nil) forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:color forState:UIControlStateNormal];
            break;
        }
        case StopwatchStateReset: {
            color = [UIColor greenColor];
            [self.startStopBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
            [self.startStopBtn setTitleColor:color forState:UIControlStateNormal];
            
            color = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            [self.resetCircleBtn setTitle:NSLocalizedString(@"Circle", nil)  forState:UIControlStateNormal];
            [self.resetCircleBtn setTitleColor:color forState:UIControlStateNormal];
            self.resetCircleBtn.enabled = NO;
            break;
        }
        default:
            break;
    }
}

- (void)startTimer {
    _startTime = [NSDate timeIntervalSinceReferenceDate];
    _lastCircleTime = _startTime;
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
    if (_currentWatchState == StopwatchStateStart) {
        double currentTime = [NSDate timeIntervalSinceReferenceDate];
        double totalSeconds = currentTime - _startTime + _beforeStopTime;
        
        double circleTime = currentTime - _lastCircleTime + _beforeStopCircleTime;
        
        NSString *timeText = [Utils createTimeFromSeconds:totalSeconds withFormat:TimeFormatForStopwatch];
        [self.watchTimeText setText:timeText];
        
        NSString *circleTimeText = [Utils createTimeFromSeconds:circleTime withFormat:TimeFormatForStopwatch];
        [self.circleTimeText setText:circleTimeText];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [circleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long itemsCount = [circleList count];
    long currentRow = indexPath.row;
    NSString *cellIdentifier = @"circleTimeCell";
    
    CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1.0];
    cell.circleTimeTxt.text = [circleList objectAtIndex:itemsCount - currentRow - 1];
    cell.circleNmbrTxt.text = [NSString stringWithFormat:@"Circle %ld", itemsCount - currentRow];
    return cell;
}

@end
