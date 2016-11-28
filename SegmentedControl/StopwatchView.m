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
    StopwatchStateStarted,
    StopwatchStatePause,
    StopwatchStatePaused,
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

//double startTime;
//double _beforeStopTime = 0.0;
//double _beforeStopCircleTime = 0.0;
//double _lastCircleTime = 0.0;
//NSMutableArray *circleList = nil;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (id)init {
//    self = [super init];
//    if (self) {
//        _currentWatchState = StopwatchStateReady;
//        _beforeStopTime = 0.0;
//        _beforeStopCircleTime = 0.0;
//        circleList = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _currentWatchState = StopwatchStateReady;
//    }
//    return self;
//}

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
//    NSLog(@"pushStartStopBtn before pressed %@  %lu",self, (unsigned long)_currentWatchState);
//    NSLog(@"%lu", (unsigned long)_currentWatchState);

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
//    NSLog(@"pushStartStopBtn after pressed %@  %lu",self, (unsigned long)_currentWatchState);
//    if (currentWatchState == StopwatchStateReady | currentWatchState == StopwatchStatePaused) {
//        [self setStopwatchState:StopwatchStateStart];
//    } else if (currentWatchState == StopwatchStateStarted) {
//        [self setStopwatchState:StopwatchStatePause];
//    }
}

- (IBAction)pushResetCircleBtn:(id)sender {
//    NSLog(@"pushResetCircleBtn before pressed %@  %lu",self, (unsigned long)_currentWatchState);
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
//    NSLog(@"pushResetCircleBtn after pressed %@  %lu",self, (unsigned long)_currentWatchState);
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
        _beforeStopTime += stopTime - _startTime;
        _beforeStopCircleTime += stopTime - _lastCircleTime;
        [self stopTimer];
        _currentWatchState = StopwatchStatePaused;
    } else if (state == StopwatchStateCircle) {
//        if (!circleList) {
//            circleList = [[NSMutableArray alloc] init];
//        }
        [circleList addObject:self.circleTimeText.text];
//        NSLog(@"%@", circleList);
        _lastCircleTime = [NSDate timeIntervalSinceReferenceDate];
        _beforeStopCircleTime = 0.0;
        [self.circleTable reloadData];
    } else if (state == StopwatchStateReset) {
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
    if (_currentWatchState == StopwatchStateStarted) {
        double currentTime = [NSDate timeIntervalSinceReferenceDate];
        double totalSeconds = currentTime - _startTime + _beforeStopTime;
        
        double circleTime = currentTime - _lastCircleTime + _beforeStopCircleTime;
        
//        NSString *timeText = [self createTimeFromSeconds:totalSeconds];
        NSString *timeText = [Utils createTimeFromSeconds:totalSeconds withFormat:TimeFormat_iMin_fSec];
        [self.watchTimeText setText:timeText];
        
//        NSString *circleTimeText = [self createTimeFromSeconds:circleTime];
        NSString *circleTimeText = [Utils createTimeFromSeconds:circleTime withFormat:TimeFormat_iMin_fSec];
        [self.circleTimeText setText:circleTimeText];
        
    }
}

//- (NSString *)createTimeFromSeconds:(double)seconds {
//    double extraSeconds = fmod(seconds, 60.0);
//    int minutes = (int)seconds / 60;
//    
//    NSString *sec = [NSString stringWithFormat:@"%.2f", extraSeconds];
//    if (extraSeconds < 10) {
//        sec = [NSString stringWithFormat:@"0%.2f", extraSeconds];
//    }
//    
//    NSString *min = [NSString stringWithFormat:@"%i", minutes];
//    if (minutes < 10) {
//        min = [NSString stringWithFormat:@"0%i", minutes];
//    }
//    
//    NSString *timeText = [NSString stringWithFormat:@"%@:%@", min, sec];
//    
//    return timeText;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [circleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleTimeCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"circleTimeCell"];
//    }
//
//    cell.textLabel.text = [circleList objectAtIndex:indexPath.row];
    long itemsCount = [circleList count];
    long currentRow = indexPath.row;
    
    CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleTimeCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:@"circleTimeCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"circleTimeCell"];
    }
    cell.circleTimeTxt.text = [circleList objectAtIndex:itemsCount - currentRow - 1];
    cell.circleNmbrTxt.text = [NSString stringWithFormat:@"Circle %ld", itemsCount - currentRow];
    return cell;
}

@end
