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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSelector:@selector(print_cpu_usage) withObject:nil afterDelay:1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (; ;) {
            
        }
    });
}

- (void)print_cpu_usage
{
    printf("cpu usage: %.2f\n", get_cpu_usage() * 100);
    [self performSelector:@selector(print_cpu_usage) withObject:nil afterDelay:1];
}


@end
