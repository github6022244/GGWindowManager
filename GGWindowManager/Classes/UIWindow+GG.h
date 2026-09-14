#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (GG)

/// 获取当前用户正在交互的 Key Window
/// 注意：在 iPadOS 多窗口并发场景下，此方法依赖 GGWindowManager 记录的激活状态。
/// 若未正确集成 SceneDelegate，将回退到遍历模式。
+ (nullable UIWindow *)getKeyWindow;

@end

NS_ASSUME_NONNULL_END
