//
//  ViewController.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 27/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "ViewController.h"

#import "NEMonitor.h"
#import "HWWaveView.h"
#import "HWCircleView.h"

#define kBytesPerMB (1024 * 1024)

@interface ViewController () <NEMonitorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cpu_usage;
@property (weak, nonatomic) IBOutlet UILabel *memory_usage;
@property (weak, nonatomic) IBOutlet UILabel *frame_per_second;
@property (weak, nonatomic) IBOutlet UISwitch *loop_switch;

@property (nonatomic, strong) HWWaveView *wave;
@property (nonatomic, strong) HWCircleView *circle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loop_switch setOn:NO];
    [self.loop_switch addTarget:self
                         action:@selector(start_infinite_loop:)
               forControlEvents:UIControlEventValueChanged];
    [[NEMonitor monitor] setDelegate:self];
    
    [self.view addSubview:self.wave];
    [self.view addSubview:self.circle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NEMonitor monitor] start];
}

#pragma mark - private

- (void)start_infinite_loop:(UISwitch *)sender
{
    if (!sender.isOn) {
        return;
    }
    
    __weak __typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (; ;) {
            if (!weakself.loop_switch.isOn) {
                break;
            }
        }
    });
}

#pragma mark - delegate

- (void)monitor:(NEMonitor *)monitor didUpdateFPS:(NSInteger)fps
{
    self.frame_per_second.text = [NSString stringWithFormat:@"%@", @(fps)];
}

- (void)monitor:(NEMonitor *)monitor didUpdateCPU:(double)usage
{
    [self.circle setProgress:usage];
    self.cpu_usage.text = [NSString stringWithFormat:@"%.2f%%", usage * 100];
}

- (void)monitor:(NEMonitor *)monitor didUpdateMemory:(double)usage
{
    [self.wave setProgress:((usage/kBytesPerMB)/200)];
    long long memory = usage / kBytesPerMB;
    self.memory_usage.text = [NSString stringWithFormat:@"%.2lld MB of %lld MB", memory,
                              [[NSProcessInfo processInfo] physicalMemory] / kBytesPerMB];
}

#pragma mark - getter

- (HWWaveView *)wave
{
    if (!_wave) {
        _wave = [[HWWaveView alloc] initWithFrame:CGRectMake(2, 2, 56, 56)];
    }
    
    return _wave;
}

- (HWCircleView *)circle
{
    if (!_circle) {
        _circle = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    
    return _circle;
}

@end
