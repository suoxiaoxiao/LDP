//
//  MemoryMonitoring.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "MemoryMonitoring.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation MemoryMonitoring

//使用内存
+ (double)getDeviceUseMemory
{
    task_basic_info_data_t taskInfo;
    
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        
                                        TASK_BASIC_INFO,
                                        
                                        (task_info_t)&taskInfo,
                                        
                                        &infoCount);
    
    
    
    if (kernReturn != KERN_SUCCESS
        
        ) {
        
        return NSNotFound;
        
    }
    
    
    
    return taskInfo.resident_size;
    
    
}
//设备内存
+ (double)getDeviceAllMemory
{
    
    vm_statistics_data_t vmStats;
    
    mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
    
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               
                                               HOST_VM_INFO,
                                               
                                               (host_info_t)&vmStats,
                                               
                                               &infoCount);
    
    
    
    if (kernReturn != KERN_SUCCESS) {
        
        return NSNotFound;
        
    }
    
    
    
    return ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
}

@end
