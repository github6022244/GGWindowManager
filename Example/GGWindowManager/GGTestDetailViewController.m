// GGTestDetailViewController.m
#import "GGTestDetailViewController.h"

@interface GGTestDetailViewController ()
@end

@implementation GGTestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 100)];
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.text = self.tipText;
    [self.view addSubview:tipLabel];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actionBtn.frame = CGRectMake(20, 220, self.view.bounds.size.width - 40, 50);
    actionBtn.backgroundColor = [UIColor systemBlueColor];
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    actionBtn.layer.cornerRadius = 8;
    [actionBtn setTitle:@"点击执行测试" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(executeTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionBtn];
}

- (void)executeTest {
    if (self.testAction) {
        // 【关键修改】将 self 和 self.showAlert 方法作为 Block 传给外部
        self.testAction(self, ^(NSString *title, NSString *message) {
            [self showAlertWithTitle:title message:message];
        });
    }
}

#pragma mark - Helper

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
