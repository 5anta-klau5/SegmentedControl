//
//  StopwatchView.h
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopwatchView : UIView {
    NSTimer *myTimer;
}

@property (strong, nonatomic) NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UILabel *watchTimeText;
@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetCircleBtn;

- (IBAction)pushStartStopBtn:(id)sender;
- (IBAction)pushResetCircleBtn:(id)sender;


@end
