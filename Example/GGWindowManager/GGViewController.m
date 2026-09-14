// GGViewController.m
#import "GGViewController.h"
#import "GGTestDetailViewController.h"
#import <UIWindow+GG.h>
#import <GGWindowManager.h>

@interface GGViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *testCases;
@end

@implementation GGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIWindow+GG 测试大厅";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.testCases = @[
        [self testCaseWithTitle:@"1. 基础测试：获取当前 KeyWindow"
                           tip:@"调用 getKeyWindow，检查控制台打印的日志，确认是否成功获取到 Window 对象。"
                        action:^(UIViewController *vc, void(^showAlert)(NSString *, NSString *)) {
            UIWindow *keyWindow = [UIWindow getKeyWindow];
            NSString *msg = keyWindow ? [NSString stringWithFormat:@"✅ 成功获取: %@", keyWindow] : @"❌ 未找到 KeyWindow";
            // 通过传入的 Block 来弹窗
            showAlert(@"测试结果", msg);
        }],
        
        [self testCaseWithTitle:@"2. 弹窗测试：在 KeyWindow 上展示 Alert"
                           tip:@"在获取到的 KeyWindow 上弹出 UIAlertController，验证 UI 是否正常显示在当前页面。"
                        action:^(UIViewController *vc, void(^showAlert)(NSString *, NSString *)) {
            UIWindow *keyWindow = [UIWindow getKeyWindow];
            if (keyWindow) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗测试" message:@"此弹窗由 getKeyWindow 触发" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            } else {
                showAlert(@"测试失败", @"KeyWindow 为空");
            }
        }],
        
        [self testCaseWithTitle:@"3. 层级测试：在 KeyWindow 上添加悬浮窗"
                           tip:@"在 KeyWindow 上添加一个红色的悬浮 View，验证其层级是否在最上方，3秒后自动消失。"
                        action:^(UIViewController *vc, void(^showAlert)(NSString *, NSString *)) {
            UIWindow *keyWindow = [UIWindow getKeyWindow];
            if (keyWindow) {
                UIView *floatingView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
                floatingView.backgroundColor = [UIColor redColor];
                floatingView.layer.cornerRadius = 10;
                floatingView.center = keyWindow.center;
                [keyWindow addSubview:floatingView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [floatingView removeFromSuperview];
                });
            }
        }],
        
        [self testCaseWithTitle:@"4. 多 Scene 验证：打印当前活跃 Scene 信息"
                           tip:@"打印 GGWindowManager 记录的 Scene 状态，以及当前所有连接的 Scene 信息。"
                        action:^(UIViewController *vc, void(^showAlert)(NSString *, NSString *)) {
            
            NSMutableString *info = [NSMutableString string];
            UIWindowScene *activeScene = [GGWindowManager sharedInstance].currentActiveScene;
            
            // 将数字转换为可读的状态字符串
            NSString *stateString;
            switch (activeScene.activationState) {
                case UISceneActivationStateForegroundActive:
                    stateString = @"ForegroundActive (前台激活)";
                    break;
                case UISceneActivationStateForegroundInactive:
                    stateString = @"ForegroundInactive (前台非激活)";
                    break;
                case UISceneActivationStateBackground:
                    stateString = @"Background (后台)";
                    break;
                default:
                    stateString = @"Unknown (未知)";
                    break;
            }
            
            [info appendFormat:@"当前记录的活跃 Scene: %@\n", activeScene];
            [info appendFormat:@"当前活跃状态: %@\n", stateString];
            [info appendFormat:@"连接的 Scene 总数: %lu\n", (unsigned long)[UIApplication sharedApplication].connectedScenes.count];
            
            showAlert(@"Scene 信息", info);
        }],
    ];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.testCases[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.testCases[indexPath.row];
    
    GGTestDetailViewController *detailVC = [[GGTestDetailViewController alloc] init];
    detailVC.title = item[@"title"];
    detailVC.tipText = item[@"tip"];
    detailVC.testAction = item[@"action"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Helper

// 【关键修改】将 showAlert 也作为 Block 传入
- (NSDictionary *)testCaseWithTitle:(NSString *)title tip:(NSString *)tip action:(void(^)(UIViewController *vc, void(^showAlert)(NSString *, NSString *)))action {
    return @{@"title": title, @"tip": tip, @"action": action};
}

@end
