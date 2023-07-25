//
//  MKBXACTabBarController.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertView.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXACCentralManager.h"

#import "MKBXACSlotConfigController.h"
#import "MKBXACSettingController.h"
#import "MKBXACDeviceInfoController.h"

@interface MKBXACTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:恢复出厂设置
/// 04:关机

@property (nonatomic, assign)BOOL disconnectType;

/// 设备如果正在进行dfu，会出现断开连接让设备进入升级模式的现象，
@property (nonatomic, assign)BOOL dfu;

@end

@implementation MKBXACTabBarController

- (void)dealloc {
    NSLog(@"MKBXACTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKBXACCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_bxa_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_bxa_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_bxa_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_bxa_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_bxa_peripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStartDFUProcess)
                                                 name:@"mk_bxa_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxa_needResetScanDelegate:)]) {
            [self.delegate mk_bxa_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxa_needResetScanDelegate:)]) {
            [self.delegate mk_bxa_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //02:修改密码成功后，返回结果，断开连接
    //03:恢复出厂设置
    //04:关机
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Modify password success! Please reconnect the Device." title:@""];
        return;
    }
    if ([type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"Factory reset successfully!Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self gotoScanPage];
//        [self showAlertWithMsg:@"Beacon is disconnected." title:@"Reset success!"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType || self.dfu) {
        return;
    }
    if ([MKBXACCentralManager shared].centralStatus != mk_bxa_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
     if (self.disconnectType || self.dfu) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

- (void)deviceStartDFUProcess {
    self.dfu = YES;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxa_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self gotoScanPage];
    }];
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:title message:msg notificationName:@"mk_bxa_needDismissAlert"];
}

- (void)loadSubPages {
    MKBXACSlotConfigController *slotPage = [[MKBXACSlotConfigController alloc] init];
    slotPage.tabBarItem.title = @"ADVERTISEMENT";
    slotPage.tabBarItem.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_slotTabBarItemUnselected.png");
    slotPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_slotTabBarItemSelected.png");
    MKBaseNavigationController *slotNav = [[MKBaseNavigationController alloc] initWithRootViewController:slotPage];

    MKBXACSettingController *settingPage = [[MKBXACSettingController alloc] init];
    settingPage.tabBarItem.title = @"SETTING";
    settingPage.tabBarItem.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_settingTabBarItemUnselected.png");
    settingPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_settingTabBarItemSelected.png");
    MKBaseNavigationController *settingNav = [[MKBaseNavigationController alloc] initWithRootViewController:settingPage];

    MKBXACDeviceInfoController *devicePage = [[MKBXACDeviceInfoController alloc] init];
    devicePage.tabBarItem.title = @"DEVICE";
    devicePage.tabBarItem.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_deviceTabBarItemUnselected.png");
    devicePage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXProACTag", @"MKBXACTabBarController", @"bxa_deviceTabBarItemSelected.png");
    MKBaseNavigationController *deviceNav = [[MKBaseNavigationController alloc] initWithRootViewController:devicePage];
    
    self.viewControllers = @[slotNav,settingNav,deviceNav];
}

@end
