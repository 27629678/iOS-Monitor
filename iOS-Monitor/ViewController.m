//
//  ViewController.m
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 27/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "ViewController.h"

#import "NEMonitorManager.h"
#import "NEMonitorViewController.h"

@interface ViewController ()

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
    
    [NEMonitorManager showMonitorWindow];
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

@end
