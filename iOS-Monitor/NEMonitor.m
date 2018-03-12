//
//  NEMonitor.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "NEMonitor.h"

#include "sysmonitor.h"

#import <QuartzCore/CADisplayLink.h>

@interface NEMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSLock *displayLinkLock;
@property (nonatomic, assign) BOOL isMonitorRunning;
@property (nonatomic, assign, readwrite) NEMonitorOption option;

@end

@implementation NEMonitor
{
    NSInteger _frame_count;
    NSTimeInterval _last_frame_update_time_interval;
}

- (void)stop
{
    [self.displayLinkLock lock];
    [self stopMonitor];
    [self.displayLinkLock unlock];
}

- (void)start
{
    [self startWithOption:NEMonitorOptionAll];
}

- (void)startWithOption:(NEMonitorOption)option
{
    [self.displayLinkLock lock];
    [self startMonitorUsingOption:option];
    [self.displayLinkLock unlock];
}

#pragma mark - private

- (void)stopMonitor
{
    self.isMonitorRunning = NO;
}

- (void)startMonitorUsingOption:(NEMonitorOption)option
{
    self.option = option;
    self.isMonitorRunning = YES;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)cleanResourcesWithDisplayLink:(CADisplayLink *)sender
{
    [sender invalidate];
    self.displayLink = nil;
    self->_frame_count = 0;
    self->_last_frame_update_time_interval = -1;
}

#pragma mark - call delegate methods

- (void)monitorDidStart
{
    if (![self.delegate respondsToSelector:@selector(didStartMonitor:)]) {
        return;
    }
    
    [self.delegate didStartMonitor:self];
}

- (void)monitorDidStop
{
    if (![self.delegate respondsToSelector:@selector(didStopMonitor:)]) {
        return;
    }
    
    [self.delegate didStopMonitor:self];
}

- (void)monitorUpdateFPS:(NSInteger)fps
{
    if (![self.delegate respondsToSelector:@selector(monitor:didUpdateFPS:)]) {
        return;
    }
    
    [self.delegate monitor:self didUpdateFPS:fps];
}

- (void)monitorUpdateCPU
{
    if (![self.delegate respondsToSelector:@selector(monitor:didUpdateCPU:)]) {
        return;
    }
    
    [self.delegate monitor:self didUpdateCPU:get_cpu_usage()];
}

- (void)monitorUpdateMemory
{
    if (![self.delegate respondsToSelector:@selector(monitor:didUpdateMemory:)]) {
        return;
    }
    
    [self.delegate monitor:self didUpdateMemory:get_memory_usage()];
}

#pragma mark - display link callback

- (void)fireDisplaylink:(CADisplayLink *)sender
{
    // stop monitor
    if (!self.isMonitorRunning) {
        [self cleanResourcesWithDisplayLink:sender];
        [self monitorDidStop];
        
        return;
    }
    
    // start monitor
    if (self->_last_frame_update_time_interval <= 0) {
        [self monitorDidStart];
        self->_last_frame_update_time_interval = sender.timestamp;
        
        return;
    }
    
    self->_frame_count ++;
    NSTimeInterval duration = sender.timestamp - self->_last_frame_update_time_interval;
    
    if (duration < self.duration) {
        return;
    }
    
    self->_last_frame_update_time_interval = sender.timestamp;
    
    if (self.option & NEMonitorOptionFPS) {
        NSInteger frame_per_second = (NSInteger)ceil(self->_frame_count * 1.f / duration);
        [self monitorUpdateFPS:frame_per_second];
        self->_frame_count = 0;
    }
    
    if (self.option & NEMonitorOptionCPU) {
        [self monitorUpdateCPU];
    }
    
    if (self.option & NEMonitorOptionMemory) {
        [self monitorUpdateMemory];
    }
}

#pragma mark - getter & setter

+ (NEMonitor *)monitor
{
    static NEMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NEMonitor new];
        instance.duration = 1;
        instance->_frame_count = 0;
        instance.displayLinkLock = [NSLock new];
        instance->_last_frame_update_time_interval = -1;
    });
    
    return instance;
}

- (void)setDuration:(NSTimeInterval)duration
{
    if (duration < 1) {
        duration = 1;
    }
    
    _duration = duration;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(fireDisplaylink:)];
    }
    
    return _displayLink;
}

@end
