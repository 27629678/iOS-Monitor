//
//  NEMonitorManager.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "NEMonitorManager.h"

#import "NEMonitorWindow.h"
#import "NEMonitorViewController.h"

@interface NEMonitorManager () <NEMonitorEventDelegate>

@property (nonatomic, strong) NEMonitorWindow *monitorWindow;

@property (nonatomic, strong) NEMonitorViewController *viewController;

@end

@implementation NEMonitorManager

+ (instancetype)defaultManager
{
    static NEMonitorManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NEMonitorManager new];
    });
    
    return instance;
}

+ (void)showMonitorWindow
{
    [[self defaultManager] show];
}

+ (void)hideMonitorWindow
{
    [[self defaultManager] hide];
}

#pragma mark - private

- (void)show
{
    [self.monitorWindow setHidden:NO];
}

- (void)hide
{
    [self.monitorWindow setHidden:YES];
}

#pragma mark - getter & setter

- (NEMonitorWindow *)monitorWindow
{
    if (!_monitorWindow) {
        _monitorWindow = [[NEMonitorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _monitorWindow.rootViewController = self.viewController;
        _monitorWindow.delegate = self;
    }
    
    return _monitorWindow;
}

- (NEMonitorViewController *)viewController
{
    if (!_viewController) {
        _viewController = [NEMonitorViewController new];
    }
    
    return _viewController;
}

#pragma mark - delegate

- (BOOL)canHandleTouchPoint:(CGPoint)point event:(UIEvent *)event
{
    return [self.viewController canHandleTouchPoint:point event:event];
}

@end
