//
//  sysmonitor.c
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 28/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#include "sysmonitor.h"

#include <time.h>
#include <mach/task.h>
#include <mach/vm_map.h>
#include <mach/mach_init.h>
#include <mach/thread_act.h>

double
get_cpu_usage()
{
    double ratio = 0;
    thread_info_data_t thinfo;
    thread_act_array_t threads;
    mach_msg_type_number_t count;
    thread_basic_info_t basic_thread_info;
    
    clock_t start = clock();
    if (task_threads(mach_task_self(), &threads, &count) == KERN_SUCCESS) {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        for (int idx = 0; idx < count; idx ++) {
            if (thread_info(threads[idx],
                            THREAD_BASIC_INFO,
                            (thread_info_t)&thinfo,
                            &thread_info_count) == KERN_SUCCESS)
            {
                basic_thread_info = (thread_basic_info_t)thinfo;
                if (basic_thread_info->flags & TH_FLAGS_IDLE) {
                    continue;
                }
                
                ratio += basic_thread_info->cpu_usage / (double)TH_USAGE_SCALE;
            }
        }
        
        vm_deallocate(mach_task_self(), (vm_address_t)threads, count * sizeof(thread_t));
    }
    
    printf("used %lu cpu time.\n", clock() - start);
    
    return ratio;
}

extern
long long get_memory_usage()
{
    struct mach_task_basic_info basic_info;
    mach_msg_type_number_t count = sizeof(basic_info) / sizeof(integer_t);
    
    kern_return_t status =task_info(mach_task_self(),
                                    MACH_TASK_BASIC_INFO,
                                    (task_info_t)&basic_info,
                                    &count);
    if (KERN_SUCCESS == status) {
        return basic_info.resident_size_max;
    }
    
    return 0;
}
