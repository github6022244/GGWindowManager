#import "GGWindowManager.h"

@implementation GGWindowManager

+ (instancetype)sharedInstance {
    static GGWindowManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GGWindowManager alloc] init];
    });
    return instance;
}

#pragma mark - Active Scene

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // 过滤非 UIWindowScene
    if (scene && ![scene isKindOfClass:[UIWindowScene class]]) {
        NSLog(@"[GGWindowManager] sceneDidBecomeActive 忽略非 UIWindowScene: %@", scene);
        return;
    }
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    // nil 视为无效输入，不更新
    if (!windowScene) {
        NSLog(@"[GGWindowManager] sceneDidBecomeActive 传入 nil，忽略");
        return;
    }
    
    // 无变化，不重复赋值
    if (_currentActiveScene == windowScene) {
        return;
    }
    
    _currentActiveScene = windowScene;
    NSLog(@"[GGWindowManager] activeScene 更新: %@", [self _sceneDescription:windowScene]);
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // 过滤非 UIWindowScene
    if (scene && ![scene isKindOfClass:[UIWindowScene class]]) {
        NSLog(@"[GGWindowManager] sceneDidDisconnect 忽略非 UIWindowScene: %@", scene);
        return;
    }
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    // 内部判断：只有断开的是"当前记录的活跃 Scene"才清空
    if (windowScene && _currentActiveScene != windowScene) {
        // 断开的不是记录的活跃 Scene，无需清空
        return;
    }
    
    if (!_currentActiveScene) {
        // 本来就没有记录，无需清空
        return;
    }
    
    NSLog(@"[GGWindowManager] activeScene 清空（原: %@）", [self _sceneDescription:_currentActiveScene]);
    _currentActiveScene = nil;
}

#pragma mark - 便捷方法

- (NSString *)_sceneDescription:(UIWindowScene *)scene {
    if (!scene) return @"nil";
    
    return [NSString stringWithFormat:
            @"<UIWindowScene: %p, state=%@(%ld), windows=%lu, keyWindow=%@>",
            scene,
            [self _activationStateDescription:scene.activationState],
            (long)scene.activationState,
            (unsigned long)scene.windows.count,
            [self _keyWindowBrief:scene]];
}

- (NSString *)_activationStateDescription:(UISceneActivationState)state {
    switch (state) {
        case UISceneActivationStateUnattached:
            return @"Unattached(未连接)";
        case UISceneActivationStateForegroundActive:
            return @"ForegroundActive(前台活跃)";
        case UISceneActivationStateForegroundInactive:
            return @"ForegroundInactive(前台非活跃)";
        case UISceneActivationStateBackground:
            return @"Background(后台)";
        default:
            return [NSString stringWithFormat:@"Unknown(%ld)", (long)state];
    }
}

- (NSString *)_keyWindowBrief:(UIWindowScene *)scene {
    for (UIWindow *w in scene.windows) {
        if (w.isKeyWindow) {
            return [NSString stringWithFormat:@"<%p level=%.0f hidden=%@>",
                    w, w.windowLevel, w.hidden ? @"YES" : @"NO"];
        }
    }
    return @"nil";
}

@end
