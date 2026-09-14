#import "UIWindow+GG.h"
#import "GGWindowManager.h"

@implementation UIWindow (GG)

#pragma mark - Public Methods

+ (UIWindow *)getKeyWindow {
    // 1. 优先使用 GGWindowManager 记录的活跃 Scene
    UIWindowScene *activeScene = [GGWindowManager sharedInstance].currentActiveScene;
    
    // 放宽到"非 Background"，覆盖控制中心/系统弹窗/权限弹窗等导致的 Inactive 状态
    if (activeScene &&
        activeScene.activationState != UISceneActivationStateBackground) {
        
        UIWindow *window = [self _findTopKeyWindowInScene:activeScene];
        if (window) {
            return window;
        }
    }
    
    // 2. 【兜底策略】如果记录的 Scene 失效或未集成，遍历所有 Scene 寻找
    NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
    if (!connectedScenes.count) {
        NSLog(@"[UIWindow+GG] connectedScenes 为空");
        return nil;
    }
    
    // 优先在前台激活的 Scene 中查找
    UIWindow *foundWindow = [self _findKeyWindowInScenes:connectedScenes onlyForegroundActive:YES];
    if (foundWindow) {
        return foundWindow;
    }
    
    // 遍历所有 Scene 寻找
    foundWindow = [self _findKeyWindowInScenes:connectedScenes onlyForegroundActive:NO];
    if (foundWindow) {
        return foundWindow;
    }
    
    NSLog(@"[UIWindow+GG] 警告: 未找到 keyWindow，请检查是否处于后台状态");
    return nil;
}

#pragma mark - Private Methods

/**
 * 在指定的 Scene 中查找最上层的 keyWindow
 */
+ (UIWindow *)_findTopKeyWindowInScene:(UIWindowScene *)windowScene {
    UIWindow *topWindow = nil;
    for (UIWindow *window in windowScene.windows) {
        if (window.isKeyWindow) {
            if (!topWindow || window.windowLevel > topWindow.windowLevel) {
                topWindow = window;
            }
        }
    }
    return topWindow;
}

/**
 * 在 Scene 集合中查找 keyWindow（兜底遍历逻辑）
 */
+ (UIWindow *)_findKeyWindowInScenes:(NSSet<UIScene *> *)scenes
                  onlyForegroundActive:(BOOL)onlyForegroundActive {
    
    for (UIScene *scene in scenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        if (onlyForegroundActive &&
            windowScene.activationState != UISceneActivationStateForegroundActive) {
            continue;
        }
        
        UIWindow *topWindow = [self _findTopKeyWindowInScene:windowScene];
        if (topWindow) {
            return topWindow;
        }
    }
    
    return nil;
}

@end
