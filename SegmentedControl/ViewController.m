//
//  ViewController.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "ViewController.h"
#import "StopwatchView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textLabel.text = @"First selected";
    
    StopwatchView* stopwatchView = [[[NSBundle mainBundle] loadNibNamed:@"StopwatchView" owner:nil options:nil] objectAtIndex:0];
    stopwatchView.frame = CGRectMake(0, 0, self.viewThird.bounds.size.width, self.viewThird.bounds.size.height);
    [self.viewThird addSubview:stopwatchView];
    
    stopwatchView = [[[NSBundle mainBundle] loadNibNamed:@"StopwatchView" owner:nil options:nil] objectAtIndex:0];
    stopwatchView.frame = CGRectMake(0, 0, self.viewThird.bounds.size.width, self.viewThird.bounds.size.height);
    [self.viewSecond addSubview:stopwatchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentIndexChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.textLabel.text = @"First segment selected";
            self.viewFirst.hidden = NO;
            self.viewSecond.hidden = YES;
            self.viewThird.hidden = YES;
            break;
        case 1:
            self.textLabel.text = @"Second segment selected";
            self.viewFirst.hidden = YES;
            self.viewSecond.hidden = NO;
            self.viewThird.hidden = YES;
            break;
        case 2:
            self.textLabel.text = @"Third segment selected";
            self.viewFirst.hidden = YES;
            self.viewSecond.hidden = YES;
            self.viewThird.hidden = NO;
            break;
        default:
            break;
    }
}
@end
