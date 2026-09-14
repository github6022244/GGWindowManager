#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGWindowManager : NSObject

+ (instancetype)sharedInstance;

/// 获取当前用户正在交互的活跃 Scene
@property (nonatomic, weak, readonly, nullable) UIWindowScene *currentActiveScene;

#pragma mark - Scene 生命周期回调（由 SceneDelegate 调用）

/// Scene 变为活跃时调用，记录为当前活跃 Scene
/// @param scene 传入 UIScene，内部会过滤，仅接受 UIWindowScene
- (void)sceneDidBecomeActive:(nullable UIScene *)scene;

/// Scene 断开连接时调用，内部会判断"是否正好是记录的活跃 Scene"，是则清空
/// @param scene 传入 UIScene，内部会过滤，仅接受 UIWindowScene
- (void)sceneDidDisconnect:(nullable UIScene *)scene;

@end

NS_ASSUME_NONNULL_END
