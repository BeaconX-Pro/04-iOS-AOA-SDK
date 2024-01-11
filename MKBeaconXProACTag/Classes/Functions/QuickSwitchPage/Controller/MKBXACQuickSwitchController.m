//
//  MKBXACQuickSwitchController.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACQuickSwitchController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseCollectionView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertView.h"

#import "MKBXQuickSwitchCell.h"

#import "MKBXACConnectManager.h"

#import "MKBXACInterface+MKBXACConfig.h"

#import "MKBXACQuickSwitchModel.h"

@interface MKBXACQuickSwitchController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MKBXQuickSwitchCellDelegate>

@property (nonatomic, strong)MKBaseCollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXACQuickSwitchModel *dataModel;

@end

@implementation MKBXACQuickSwitchController

- (void)dealloc {
    NSLog(@"MKBXACQuickSwitchController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKBXQuickSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty" forIndexPath:indexPath];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kViewWidth - 3 * 11.f) / 2, 85.f);
}

#pragma mark - MKBXQuickSwitchCellDelegate
- (void)mk_bx_quickSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Password verification
        [self configPasswordVerification:isOn];
        return;
    }
    if (index == 1) {
        //Trigger LED indicator
        [self configTriggerLEDIndicator:isOn];
        return;
    }
}

#pragma mark - 设置参数部分

#pragma mark - 设置设备是否免密码登录
- (void)configPasswordVerification:(BOOL)isOn {
    if (isOn) {
        [self commandForPasswordVerification:isOn];
        return;
    }
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self commandForPasswordVerification:isOn];
    }];
    NSString *msg = @"If Password verification is disabled, it will not need password to connect the Beacon.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxa_needDismissAlert"];
}

- (void)commandForPasswordVerification:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXACInterface bxa_configPasswordVerification:isOn sucBlock:^{
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        [MKBXACConnectManager shared].needPassword = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Trigger LED indicator
- (void)configTriggerLEDIndicator:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXACInterface bxa_configTriggerLEDIndicatorStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.trigger = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionData
- (void)loadSectionData {
    MKBXQuickSwitchCellModel *cellModel1 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.titleMsg = @"Password verification";
    cellModel1.isOn = self.dataModel.passwordVerification;
    [self.dataList addObject:cellModel1];
    
    MKBXQuickSwitchCellModel *cellModel2 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.titleMsg = @"Trigger LED indicator";
    cellModel2.isOn = self.dataModel.trigger;
    [self.dataList addObject:cellModel2];
        
    [self.collectionView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Quick switch";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseCollectionView *)collectionView {
    if (!_collectionView) {
        MKBXQuickSwitchCellLayout *layout = [[MKBXQuickSwitchCellLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(11.f, 11.f, 0, 11.f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[MKBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = RGBCOLOR(246.f, 247.f, 251.f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:MKBXQuickSwitchCell.class forCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXACQuickSwitchModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXACQuickSwitchModel alloc] init];
    }
    return _dataModel;
}

@end
