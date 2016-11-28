//
//  Utils.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/28/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)createTimeFromSeconds:(double)seconds withFormat:(TimeFormat )timeFormat {
    double hours, minutes, extraSeconds;
    NSString *timeText;
    switch (timeFormat) {
        case TimeFormat_iHour_iMin_iSec:
            hours = seconds / 3600;
            minutes = fmod(seconds, 3600) / 60;
            extraSeconds = fmod(fmod(seconds, 3600), 60);
            
            timeText = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hours, (int)minutes, (int)extraSeconds];
            break;
        case TimeFormat_iMin_fSec:
            extraSeconds = fmod(seconds, 60.0);
            minutes = (int)seconds / 60;
            
            timeText = [NSString stringWithFormat:@"%02d:%05.2f", (int)minutes, extraSeconds];
            break;
        default:
            break;
    }
            return timeText;
}

@end
