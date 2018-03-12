//
//  NEMonitorWindow.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "NEMonitorWindow.h"

@interface NEMonitorWindow ()

@end

@implementation NEMonitorWindow

#pragma mark - override

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.delegate canHandleTouchPoint:point event:event];
}

@end
