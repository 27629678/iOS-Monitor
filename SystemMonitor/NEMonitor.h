//
//  NEMonitor.h
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NEMonitor;

@protocol NEMonitorDelegate <NSObject>

@optional

- (void)didStartMonitor:(NEMonitor *)monitor;

- (void)didStopMonitor:(NEMonitor *)monitor;

- (void)monitor:(NEMonitor *)monitor didUpdateFPS:(NSInteger)fps;

- (void)monitor:(NEMonitor *)monitor didUpdateCPU:(double)usage;

- (void)monitor:(NEMonitor *)monitor didUpdateMemory:(double)usage;

@end    // NEMonitorDelegate

typedef NS_OPTIONS(NSUInteger, NEMonitorOption) {
    NEMonitorOptionFPS = 1 << 0,
    NEMonitorOptionCPU = 1 << 1,
    NEMonitorOptionMemory = 1 << 2,
    
    NEMonitorOptionAll = NSUIntegerMax,
};

@interface NEMonitor : NSObject

- (void)stop;

- (void)start;

- (void)startWithOption:(NEMonitorOption)option;

@property (nonatomic, readonly, class) NEMonitor *monitor;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, weak) id<NEMonitorDelegate> delegate;

@property (nonatomic, readonly, assign) NEMonitorOption option;

@end    // NEMonitor
