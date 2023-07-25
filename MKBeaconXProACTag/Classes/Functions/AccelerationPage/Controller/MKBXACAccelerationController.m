//
//  MKBXACAccelerationController.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACAccelerationController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXACCentralManager.h"

#import "MKBXACAccelerationModel.h"

#import "MKBXACAccelerationHeaderView.h"
#import "MKBXACAccelerationParamsCell.h"

@interface MKBXACAccelerationController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXACAccelerationHeaderViewDelegate,
MKBXACAccelerationParamsCellDelegate>

@property (nonatomic, strong)MKBXACAccelerationHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXACAccelerationModel *dataModel;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKBXACAccelerationController

- (void)dealloc {
    NSLog(@"MKBXACAccelerationController销毁");
    [[MKBXACCentralManager shared] notifyThreeAxisData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxa_receiveThreeAxisDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXACAccelerationParamsCell *cell = [MKBXACAccelerationParamsCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXACAccelerationHeaderViewDelegate
- (void)bxa_updateThreeAxisNotifyStatus:(BOOL)notify {
    [[MKBXACCentralManager shared] notifyThreeAxisData:notify];
}

#pragma mark - MKBXACAccelerationParamsCellDelegate

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxa_accelerationMotionThresholdChanged:(NSString *)threshold {
    self.dataModel.threshold = threshold;
    MKBXACAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.threshold = threshold;
}

#pragma mark - 通知
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self.headerView updateDataWithXData:dic[@"xData"] yData:dic[@"yData"] zData:dic[@"zData"]];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    [self loadSection0Datas];
    
    for (NSInteger i = 0; i < 1; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKBXACAccelerationParamsCellModel *cellModel = [[MKBXACAccelerationParamsCellModel alloc] init];
    cellModel.threshold = self.dataModel.threshold;
    [self.dataList addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-axis accelerometer";
    [self.rightButton setImage:LOADICON(@"MKBeaconXProACTag", @"MKBXACAccelerationController", @"bxa_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MKBXACAccelerationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXACAccelerationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 85.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXACAccelerationModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXACAccelerationModel alloc] init];
    }
    return _dataModel;
}

@end
