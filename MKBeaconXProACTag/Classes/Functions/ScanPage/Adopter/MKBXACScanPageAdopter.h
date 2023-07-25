//
//  MKBXACScanPageAdopter.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXACBaseBeacon;
@class MKBXACScanInfoCellModel;
@interface MKBXACScanPageAdopter : NSObject


/// 将扫描到的beacon数据转换成对应的cellModel
/*
 如果beacon是:
 MKBXACParamInfoPositionFrameType:                   参数信息定位包(对应的dataModel是MKBXACScanDeviceInfoCellModel类型)
 MKBXACTriaxialDataFrameType:                 三轴数据定位包(对应的dataModel是MKBXACScanDeviceInfoCellModel类型)
 MKBXACUserDataPositionFrameType:                 用户数据定位包(对应的dataModel是MKBXACScanDeviceInfoCellModel类型)
 MKBXTProductionTestFrameType:                 产测广播帧(对应的dataModel是MKBXACScanParamInfoCellModel类型)
 
 如果不是其中的一种，则返回nil
 */
/// @param beacon 扫描到的beacon数据
+ (NSObject *)parseBeaconDatas:(MKBXACBaseBeacon *)beacon;

+ (MKBXACScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXACBaseBeacon *)beacon;

/// 新扫描到的数据已经在列表的数据源中存在，则需要将扫描到的数据结合列表数据源中的数据进行处理
/*
 如果beacon是参数信息定位包/三轴数据定位包/用户数据定位包，判断exsitModel的advertiseList列表数据源是否已经存在MKBXACScanDeviceInfoCellModel，如果存在，则更新其内容，如果不存在则生成之后加入advertiseList，如果是产测广播帧，则判断是否存在MKBXACScanParamInfoCellModel
 */
/// @param exsitModel 列表数据源中已经存在的数据
/// @param beacon 刚扫描到的beacon数据
+ (void)updateInfoCellModel:(MKBXACScanInfoCellModel *)exsitModel beaconData:(MKBXACBaseBeacon *)beacon;

/// 根据不同的dataModel加载cell
/*
 目前支持
 MKBXACScanDetialCell:            信息帧(对应的dataModel是MKBXACScanInfoCellModel类型)
 MKBXACScanDeviceInfoCell:        定位广播帧(对应的dataModel是MKBXACScanDeviceInfoCellModel类型)
 MKBXACScanParamInfoCell:           产测广播帧(对应的dataModel是MKBXACScanParamInfoCellModel类型)
 如果不是其中的一种，则返回一个初始化的UITableViewCell
 */
/// @param tableView tableView
/// @param dataModel dataModel
+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel;

/// 根据不同的dataModel返回cell的高度
/*
 目前支持
 根据UUID动态计算:
 180.f:                 定位广播帧(对应的dataModel是MKBXACScanDeviceInfoCellModel类型)
 100.f:                 产测广播帧(对应的dataModel是MKBXACScanParamInfoCellModel类型)
 如果不是其中的一种，则返回0
 */
/// @param indexPath indexPath
+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel;

/// 根据传进来的model确定在设备信息帧的dataArray里面的排序号
/*
 0:         MKBXACScanDeviceInfoCellModel
 1:         MKBXACScanParamInfoCellModel
 否则返回2，排在最后面
 */
/// @param dataModel dataModel
+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel;

@end

NS_ASSUME_NONNULL_END
