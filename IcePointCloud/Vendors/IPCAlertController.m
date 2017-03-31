//
//  IPCAlertController.m
//  IcePointCloud
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCAlertController.h"

@interface IPCAlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) UIAlertActionStyle  style;

@end

@implementation IPCAlertActionModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"";
        self.style = UIAlertViewStyleDefault;
    }
    return self;
}

@end

typedef void(^IPCAlertActionsConfig)(IPCAlertActionBlock actionBlock);

@interface IPCAlertController ()

@property (nonatomic, strong) NSMutableArray<IPCAlertActionModel *> * actionArray;

- (IPCAlertActionsConfig)alertActionsConfig;


@end

@implementation IPCAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.alertDismissBlock) {
        self.alertDismissBlock();
    }
}

- (NSMutableArray<IPCAlertActionModel *> *)actionArray{
    if (!_actionArray) {
        _actionArray = [[NSMutableArray alloc]init];
    }
    return _actionArray;
}

- (IPCAlertActionsConfig)alertActionsConfig{
    return ^(IPCAlertActionBlock actionBlock){
        if (self.actionArray.count) {
            __weak typeof (self) weakSelf = self;
            [self.actionArray enumerateObjectsUsingBlock:^(IPCAlertActionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction * alertAction = [UIAlertAction actionWithTitle:obj.title style:obj.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                [self addAction:alertAction];
            }];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }
    };
}


- (instancetype)initAlertControllerWithTitle:(NSString *)title Message:(NSString *)message Style:(UIAlertControllerStyle)style{
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:style];
    if (self) {}
    return self;
}


- (IPCAlertActionTitle)addCancelTitle{
    return ^(NSString *title){
        IPCAlertActionModel * model = [[IPCAlertActionModel alloc]init];
        model.title   = title;
        model.style  = UIAlertActionStyleCancel;
        [self.actionArray addObject:model];
        return self;
    };
}

- (IPCAlertActionTitle)addDefaultTitle{
    return ^(NSString *title){
        IPCAlertActionModel * model = [[IPCAlertActionModel alloc]init];
        model.title = title;
        model.style =UIAlertActionStyleDefault;
        [self.actionArray addObject:model];
        return self;
    };
}

- (IPCAlertActionTitle)addDestructiveTitle{
    return ^(NSString *title){
        IPCAlertActionModel * model = [[IPCAlertActionModel alloc]init];
        model.title = title;
        model.style = UIAlertActionStyleDestructive;
        [self.actionArray addObject:model];
        return self;
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation UIViewController(IPCAlertController)

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Process:(IPCAlertControllerProcess)process ActionBlock:(IPCAlertActionBlock)actionBlock{
    [self showAlertWithStyle:UIAlertControllerStyleAlert Title:title Message:message Process:process ActionBlock:actionBlock];
}


- (void)showActionSheetWithTitle:(NSString *)title Message:(NSString *)message Process:(IPCAlertControllerProcess)process ActionBlock:(IPCAlertActionBlock)actionBlock{
    [self showAlertWithStyle:UIAlertControllerStyleActionSheet Title:title Message:message Process:process ActionBlock:actionBlock];
}


- (void)showAlertWithStyle:(UIAlertControllerStyle)style Title:(NSString *)title Message:(NSString *)message Process:(IPCAlertControllerProcess)process ActionBlock:(IPCAlertActionBlock)actionBlock
{
    if (process) {
        IPCAlertController * alertController = [[IPCAlertController alloc] initAlertControllerWithTitle:title Message:message Style:style];
        if (process) {
            process(alertController);
        }
        if (alertController.alertActionsConfig && actionBlock) {
            alertController.alertActionsConfig(actionBlock);
        }
        if (alertController.alertShowBlock) {
            [self presentViewController:alertController animated:YES completion:^{
                alertController.alertDismissBlock();
            }];
        }else{
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}



@end
