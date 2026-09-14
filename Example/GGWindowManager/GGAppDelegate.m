//
//  GGAppDelegate.m
//  GGWindowManager
//
//  Created by github6022244 on 09/14/2026.
//  Copyright (c) 2026 github6022244. All rights reserved.
//

#import "GGAppDelegate.h"

@implementation GGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

// 当系统需要创建新 Scene 时，返回对应的配置
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

// 当用户通过多任务界面划掉某个 Scene 时触发，用于清理资源
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}

@end
