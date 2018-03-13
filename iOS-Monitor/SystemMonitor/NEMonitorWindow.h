//
//  NEMonitorWindow.h
//  iOS-Monitor
//
//  Created by hzyuxiaohua on 12/03/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NEMonitorEventDelegate <NSObject>

- (BOOL)canHandleTouchPoint:(CGPoint)point event:(UIEvent *)event;

@end

@interface NEMonitorWindow : UIWindow

@property (nonatomic, weak) id<NEMonitorEventDelegate> delegate;

@end
