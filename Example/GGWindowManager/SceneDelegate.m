//
//  SceneDelegate.m
//  CommeniOSAppFundation
//
//  Created by GG on 2024/3/7.
//

#import "SceneDelegate.h"
#import "GGAppDelegate.h"
#import "GGViewController.h"
#import <GGWindowManager.h>

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    [[GGWindowManager sharedInstance] sceneDidBecomeActive:scene];
    
    [self setUpWindowWithScene:windowScene];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // 记录当前用户正在交互的 Scene
    [[GGWindowManager sharedInstance] sceneDidBecomeActive:scene];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    [[GGWindowManager sharedInstance] sceneDidDisconnect:scene];
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // 暂停 UI 任务
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // 保存 UI 状态、持久化草稿
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // 恢复前台状态
}

#pragma mark - URL / Universal Link 回调（Scene 架构下由 SceneDelegate 处理）

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    
}

#pragma mark --- Private
- (void)setUpWindowWithScene:(UIWindowScene *)scene {
    // 1. 创建 window
    self.window = [[UIWindow alloc] initWithWindowScene:scene];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 2. 设置根控制器
    GGViewController *vc = [GGViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    // 3. 显示 window
    [self.window makeKeyAndVisible];
    
    // 4.为 Appdelegate 设置 window
    GGAppDelegate *appDelegate = (GGAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window = self.window;
}

@end
