// GGTestDetailViewController.h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGTestDetailViewController : UIViewController

@property (nonatomic, copy) NSString *tipText;

// 【关键修改】更新 Block 类型，增加 showAlert 回调
@property (nonatomic, copy) void(^testAction)(UIViewController *vc, void(^showAlert)(NSString *title, NSString *message));

@end

NS_ASSUME_NONNULL_END
