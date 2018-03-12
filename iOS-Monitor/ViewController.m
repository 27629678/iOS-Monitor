//
//  ViewController.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 27/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "ViewController.h"

#import "sysmonitor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cpu_usage;
@property (weak, nonatomic) IBOutlet UILabel *memory_usage;
@property (weak, nonatomic) IBOutlet UISwitch *loop_switch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loop_switch setOn:NO];
    [self.loop_switch addTarget:self
                         action:@selector(start_infinite_loop:)
               forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self print_cpu_usage];
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

- (void)print_cpu_usage
{
    double cpu = get_cpu_usage() * 100;
    self.cpu_usage.text = [NSString stringWithFormat:@"%.2f%%", cpu];
    
    long long kBytesPerMB = 1024 * 1024;
    long long memory = get_memory_usage() * 1.0f / kBytesPerMB;
    self.memory_usage.text = [NSString stringWithFormat:@"%.2lld MB of %lld MB", memory,
                               [[NSProcessInfo processInfo] physicalMemory] / kBytesPerMB];
    
    [self performSelector:@selector(print_cpu_usage) withObject:nil afterDelay:1];
}


@end
