//
//  ViewController.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 10/25/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textLabel.text = @"First selected";
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
            break;
        case 1:
            self.textLabel.text = @"Second segment selected";
            self.viewFirst.hidden = YES;
            self.viewSecond.hidden = NO;
        default:
            break;
    }
}
@end
