//
//  MKBXACSlotConfigController.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACSlotConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXACSlotConfigModel.h"

#import "MKBXACSlotConfigAdvCell.h"
#import "MKBXACSlotConfigTriggerCell.h"

@interface MKBXACSlotConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXACSlotConfigAdvCellDelegte,
MKBXACSlotConfigTriggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXACSlotConfigModel *dataModel;

@end

@implementation MKBXACSlotConfigController

- (void)dealloc {
    NSLog(@"MKBXACSlotConfigController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxa_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250.f;
    }
    if (indexPath.section == 1) {
        return (self.dataModel.trigger ? 230.f : 44.f);
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
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
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKBXACSlotConfigAdvCell *cell = [MKBXACSlotConfigAdvCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKBXACSlotConfigTriggerCell *cell = [MKBXACSlotConfigTriggerCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXACSlotConfigAdvCellDelegte
- (void)bxa_slotConfigAdvCell_channelChanged:(NSInteger)channel {
    self.dataModel.advChannel = channel;
}

- (void)bxa_slotConfigAdvCell_intervalChanged:(NSInteger)interval {
    self.dataModel.advInterval = interval;
}

- (void)bxa_slotConfigAdvCell_advDurationChanged:(NSString *)duration {
    self.dataModel.advDuration = duration;
}

- (void)bxa_slotConfigAdvCell_standbyDurationChanged:(NSString *)duration {
    self.dataModel.standbyDuration = duration;
}

- (void)bxa_slotConfigAdvCell_txPowerChanged:(NSInteger)txPower {
    self.dataModel.advTxPower = txPower;
}

#pragma mark - MKBXACSlotConfigTriggerCellDelegate
- (void)bxa_slotConfigTriggerCell_triggerStatusChanged:(BOOL)isOn {
    self.dataModel.trigger = isOn;
    MKBXACSlotConfigTriggerCellModel *cellModel = self.section1List[0];
    cellModel.trigger = isOn;
    
    [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)bxa_slotConfigTriggerCell_triggerTypeChanged:(NSInteger)type {
    self.dataModel.triggerType = type;
}

- (void)bxa_slotConfigTriggerCell_intervalChanged:(NSInteger)interval {
    self.dataModel.triggerInterval = interval;
}

- (void)bxa_slotConfigTriggerCell_durationChanged:(NSString *)duration {
    self.dataModel.triggerDuration = duration;
}

- (void)bxa_slotConfigTriggerCell_txPowerChanged:(NSInteger)txPower {
    self.dataModel.triggerTxPower = txPower;
}

#pragma mark - interface
- (void)readDatasFromDevice {
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

- (void)saveDataToDevice {
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKBXACSlotConfigAdvCellModel *cellModel = [[MKBXACSlotConfigAdvCellModel alloc] init];
    cellModel.advChannel = self.dataModel.advChannel;
    cellModel.advInterval = self.dataModel.advInterval;
    cellModel.advDuration = self.dataModel.advDuration;
    cellModel.standbyDuration = self.dataModel.standbyDuration;
    cellModel.advTxPower = self.dataModel.advTxPower;
    
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKBXACSlotConfigTriggerCellModel *cellModel = [[MKBXACSlotConfigTriggerCellModel alloc] init];
    cellModel.trigger = self.dataModel.trigger;
    cellModel.triggerType = self.dataModel.triggerType;
    cellModel.triggerInterval = self.dataModel.triggerInterval;
    cellModel.triggerDuration = self.dataModel.triggerDuration;
    cellModel.triggerTxPower = self.dataModel.triggerTxPower;
    
    [self.section1List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"ADVERTISEMENT";
    [self.rightButton setImage:LOADICON(@"MKBeaconXProACTag", @"MKBXACSlotConfigController", @"bxa_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXACSlotConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXACSlotConfigModel alloc] init];
    }
    return _dataModel;
}



@end
