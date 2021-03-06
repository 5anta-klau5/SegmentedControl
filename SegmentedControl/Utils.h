//
//  Utils.h
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 11/28/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSUInteger {
    TimeFormatForTimer,
    TimeFormatForStopwatch,
    TimeFormatForSomeElse
} TimeFormat;

@interface Utils : NSObject

+ (NSString *)createTimeFromSeconds:(double)seconds withFormat:(TimeFormat )timeFormat;

@end
