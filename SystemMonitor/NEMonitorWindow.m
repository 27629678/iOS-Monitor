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
        self.windowLevel = UIWindowLevelStatusBar + 110.0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL canHandle = NO;
    if ([self.delegate canHandleTouchPoint:point event:event]) {
        canHandle = [super pointInside:point withEvent:event];
    }
    
    return canHandle;
}

@end
