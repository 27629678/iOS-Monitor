//
//  NEMonitorViewController.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "NEMonitorViewController.h"

#import "HWWaveView.h"
#import "HWCircleView.h"
#import "NEMonitor.h"

#define kBytesPerMB (1024 * 1024)

@interface NEMonitorViewController () <NEMonitorDelegate>

@property (nonatomic, strong) UIView *monitorView;
@property (nonatomic, strong) UILabel *fps_label;
@property (nonatomic, strong) HWWaveView *wave;
@property (nonatomic, strong) HWCircleView *circle;
@property (nonatomic, strong) UIPanGestureRecognizer *gesture;

@end

@implementation NEMonitorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NEMonitor monitor] setDelegate:self];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.monitorView];
    [self.view addGestureRecognizer:self.gesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NEMonitor monitor] start];
}

- (BOOL)canHandleTouchPoint:(CGPoint)point event:(UIEvent *)event
{
    CGPoint pointInLocalCoordinates = [self.view convertPoint:point fromView:nil];
    
    return CGRectContainsPoint(self.monitorView.frame, pointInLocalCoordinates);
}

#pragma mark - pan gesture

- (void)handlePanGesture:(UIGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    CGRect frame = self.monitorView.frame;
    CGPoint locate = [sender locationInView:self.view];
    frame.origin.x = locate.x - 30;
    frame.origin.y = locate.y - 30;
    self.monitorView.frame = frame;
}

#pragma mark - delegate

- (void)monitor:(NEMonitor *)monitor didUpdateFPS:(NSInteger)fps
{
    self.fps_label.text = [NSString stringWithFormat:@"%@", @(fps)];
}

- (void)monitor:(NEMonitor *)monitor didUpdateCPU:(double)usage
{
    self.circle.progress = usage;
}

- (void)monitor:(NEMonitor *)monitor didUpdateMemory:(double)usage
{
    self.wave.progress = usage / (400 * kBytesPerMB);
}

#pragma mark - getter

- (UIView *)monitorView
{
    if (!_monitorView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 60, 60)];
        [view addSubview:self.wave];
        [view addSubview:self.circle];
        [view addSubview:self.fps_label];
        
        _monitorView = view;
    }
    
    return _monitorView;
}

- (HWWaveView *)wave
{
    if (!_wave) {
        _wave = [[HWWaveView alloc] initWithFrame:CGRectMake(2, 2, 56, 56)];
        [_wave setProgress:.5f];
    }
    
    return _wave;
}

- (HWCircleView *)circle
{
    if (!_circle) {
        _circle = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_circle setProgress:.8f];
    }
    
    return _circle;
}

- (UILabel *)fps_label
{
    if (!_fps_label) {
        _fps_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_fps_label setTextAlignment:NSTextAlignmentCenter];
        [_fps_label setText:@"60"];
    }
    
    return _fps_label;
}

- (UIPanGestureRecognizer *)gesture
{
    if (!_gesture) {
        _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    
    return _gesture;
}

@end
