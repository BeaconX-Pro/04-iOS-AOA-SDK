//
//  MKBXACScanPageAdopter.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACScanPageAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import <objc/runtime.h>

#import "MKMacroDefines.h"

#import "MKBXACScanInfoCellModel.h"

#import "MKBXACScanDetialCell.h"
#import "MKBXACScanDeviceInfoCell.h"
#import "MKBXACScanParamInfoCell.h"

#import "MKBXACBaseBeacon.h"

#pragma mark - *********************此处分类为了对数据列表里面的设备信息帧数据和设备信息帧数据里面的广播帧数据进行替换和排序使用**********************

static const char *indexKey = "indexKey";
static const char *frameTypeKey = "frameTypeKey";

@interface NSObject (MKBXACcanAdd)

/// 用来标示数据model在设备列表或者设备信息广播帧数组里的index
@property (nonatomic, assign)NSInteger index;

/*
 用来对同一个设备的广播帧进行排序，顺序为
 MKBXACParamInfoPositionFrameType/MKBXACTriaxialDataFrameType/MKBXACUserDataPositionFrameType三种广播帧对应MKBXACScanDeviceInfoCellModel
 MKBXACProductionTestFrameType对应MKBXACScanParamInfoCellModel
 注意，MKBXACTagInfoFrameType为每个section的第一个row数据，不在此进行排列了
 */
@property (nonatomic, assign)NSInteger frameIndex;

@end

@implementation NSObject (MKBXACcanAdd)

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

- (void)setFrameIndex:(NSInteger)frameIndex {
    objc_setAssociatedObject(self, &frameTypeKey, @(frameIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)frameIndex {
    return [objc_getAssociatedObject(self, &frameTypeKey) integerValue];
}

@end




#pragma mark - *****************************MKBXACScanPageAdopter**********************


@implementation MKBXACScanPageAdopter

+ (NSObject *)parseBeaconDatas:(MKBXACBaseBeacon *)beacon {
    if ([beacon isKindOfClass:MKBXACParamInfoPositionBeacon.class]) {
        //参数信息定位包
        MKBXACParamInfoPositionBeacon *tempModel = (MKBXACParamInfoPositionBeacon *)beacon;
        
        MKBXACScanDeviceInfoCellModel *cellModel = [[MKBXACScanDeviceInfoCellModel alloc] init];
        cellModel.advChannel = [self parseAdvChannel:tempModel.advChannel];
        cellModel.advInterval = [self parseAdvInterval:tempModel.advInterval];
        cellModel.txPower = [self parseAdvTxPower:tempModel.txPower];
        cellModel.alarmStatus = (tempModel.alarmStatus ? @"Triggerd" : @"Standy");
        
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXACTriaxialDataBeacon.class]) {
        //三轴信息定位包
        MKBXACTriaxialDataBeacon *tempModel = (MKBXACTriaxialDataBeacon *)beacon;
        
        MKBXACScanDeviceInfoCellModel *cellModel = [[MKBXACScanDeviceInfoCellModel alloc] init];
        
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXACUserDataPositionBeacon.class]) {
        //用户数据定位包
        MKBXACUserDataPositionBeacon *tempModel = (MKBXACUserDataPositionBeacon *)beacon;
        
        MKBXACScanDeviceInfoCellModel *cellModel = [[MKBXACScanDeviceInfoCellModel alloc] init];
        cellModel.temperature = [NSString stringWithFormat:@"%@%@",tempModel.temperature,@"℃"];
        cellModel.alarmCount = tempModel.alarmCount;
        
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXACProductionTestBeacon.class]) {
        //产测广播帧
        MKBXACProductionTestBeacon *tempModel = (MKBXACProductionTestBeacon *)beacon;
        
        MKBXACScanParamInfoCellModel *cellModel = [[MKBXACScanParamInfoCellModel alloc] init];
        cellModel.advChannel = [self parseAdvChannel:tempModel.advChannel];
        cellModel.advInterval = [self parseAdvInterval:tempModel.advInterval];
        cellModel.txPower = [self parseAdvTxPower:tempModel.txPower];
        
        return cellModel;
    }
    
    return nil;
}

+ (MKBXACScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXACBaseBeacon *)beacon {
    if (!beacon || ![beacon isKindOfClass:MKBXACBaseBeacon.class]) {
        return [[MKBXACScanInfoCellModel alloc] init];
    }
    MKBXACScanInfoCellModel *deviceModel = [[MKBXACScanInfoCellModel alloc] init];
    deviceModel.identifier = beacon.peripheral.identifier.UUIDString;
    deviceModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    deviceModel.deviceName = (ValidStr(beacon.deviceName) ? beacon.deviceName : @"");
    deviceModel.displayTime = @"N/A";
    deviceModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
    deviceModel.connectEnable = beacon.connectEnable;
    deviceModel.peripheral = beacon.peripheral;
    
    if (beacon.frameType == MKBXACParamInfoPositionFrameType) {
        //如果是设备信息帧
        MKBXACParamInfoPositionBeacon *tempInfoModel = (MKBXACParamInfoPositionBeacon *)beacon;
        deviceModel.battery = [tempInfoModel.battery stringByAppendingString:@"%"];
    }else if (beacon.frameType == MKBXACProductionTestFrameType) {
        //如果是产测
        MKBXACProductionTestBeacon *tempModel = (MKBXACProductionTestBeacon *)beacon;
        deviceModel.battery = [tempModel.voltage stringByAppendingString:@"mV"];
        deviceModel.macAddress = tempModel.macAddress;
    }
    NSObject *obj = [self parseBeaconDatas:beacon];
    if (!obj) {
        return deviceModel;
    }
    NSInteger frameType = [self fetchFrameIndex:obj];
    obj.index = 0;
    obj.frameIndex = frameType;
    [deviceModel.advertiseList addObject:obj];
    
    return deviceModel;
}

+ (void)updateInfoCellModel:(MKBXACScanInfoCellModel *)exsitModel beaconData:(MKBXACBaseBeacon *)beacon {
    exsitModel.connectEnable = beacon.connectEnable;
    exsitModel.peripheral = beacon.peripheral;
    if (SafeStr(beacon.deviceName)) {
        exsitModel.deviceName = beacon.deviceName;
    }
    
    exsitModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    if (exsitModel.lastScanDate > 0) {
        NSTimeInterval space = [[NSDate date] timeIntervalSince1970] * 1000 - exsitModel.lastScanDate;
        if (space > 10) {
            exsitModel.displayTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)space,@"ms"];
            exsitModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
        }
    }
    if (beacon.frameType == MKBXACParamInfoPositionFrameType) {
        //如果是设备信息帧
        MKBXACParamInfoPositionBeacon *tempInfoModel = (MKBXACParamInfoPositionBeacon *)beacon;
        exsitModel.battery = [tempInfoModel.battery stringByAppendingString:@"%"];
    }else if (beacon.frameType == MKBXACProductionTestFrameType) {
        //如果是产测
        MKBXACProductionTestBeacon *tempModel = (MKBXACProductionTestBeacon *)beacon;
        exsitModel.battery = [tempModel.voltage stringByAppendingString:@"mV"];
        exsitModel.macAddress = tempModel.macAddress;
    }
    
    BOOL contain = NO;
    
    for (NSInteger i = 0; i < exsitModel.advertiseList.count; i ++) {
        NSObject *model = exsitModel.advertiseList[i];
        if ([model isKindOfClass:MKBXACScanDeviceInfoCellModel.class]) {
            //Device info
            MKBXACScanDeviceInfoCellModel *cellModelModel = (MKBXACScanDeviceInfoCellModel *)model;
            if (beacon.frameType == MKBXACParamInfoPositionFrameType) {
                //参数信息定位包
                MKBXACParamInfoPositionBeacon *beaconModel = (MKBXACParamInfoPositionBeacon *)beacon;
                cellModelModel.advChannel = [self parseAdvChannel:beaconModel.advChannel];
                cellModelModel.advInterval = [self parseAdvInterval:beaconModel.advInterval];
                cellModelModel.txPower = [self parseAdvTxPower:beaconModel.txPower];
                cellModelModel.alarmStatus = (beaconModel.alarmStatus ? @"Triggerd" : @"Standy");
                
                contain = YES;
            }else if (beacon.frameType == MKBXACTriaxialDataFrameType) {
                //三轴数据定位包
                contain = YES;
            }else if (beacon.frameType == MKBXACUserDataPositionFrameType) {
                //用户数据定位包
                MKBXACUserDataPositionBeacon *beaconModel = (MKBXACUserDataPositionBeacon *)beacon;
                cellModelModel.temperature = [NSString stringWithFormat:@"%@%@",beaconModel.temperature,@"℃"];
                cellModelModel.alarmCount = beaconModel.alarmCount;
                
                contain = YES;
            }
        }else if ([model isKindOfClass:MKBXACScanParamInfoCellModel.class]) {
            //Parameter info
            if (beacon.frameType == MKBXACProductionTestFrameType) {
                //产测广播帧
                MKBXACScanParamInfoCellModel *cellModel = (MKBXACScanParamInfoCellModel *)model;
                
                MKBXACParamInfoPositionBeacon *beaconModel = (MKBXACProductionTestBeacon *)beacon;
                
                cellModel.advChannel = [self parseAdvChannel:beaconModel.advChannel];
                cellModel.advInterval = [self parseAdvInterval:beaconModel.advInterval];
                cellModel.txPower = [self parseAdvTxPower:beaconModel.txPower];
                
                contain = YES;
            }
        }
    }
    if (!contain) {
        //未包含当前广播帧
        NSObject *tempModel = [MKBXACScanPageAdopter parseBeaconDatas:beacon];
        if (tempModel) {
            tempModel.frameIndex = [self fetchFrameIndex:tempModel];
            [exsitModel.advertiseList addObject:tempModel];
            tempModel.index = exsitModel.advertiseList.count - 1;
        }
    }
    
    NSArray *tempArray = [NSArray arrayWithArray:exsitModel.advertiseList];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSObject *p1, NSObject *p2){
        if (p1.frameIndex > p2.frameIndex) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [exsitModel.advertiseList removeAllObjects];
    for (NSInteger i = 0; i < sortedArray.count; i ++) {
        NSObject *tempModel = sortedArray[i];
        tempModel.index = i;
        [exsitModel.advertiseList addObject:tempModel];
    }
}

+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXACScanInfoCellModel.class]) {
        //信息帧
        MKBXACScanDetialCell *cell = [MKBXACScanDetialCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXACScanDeviceInfoCellModel.class]) {
        //Device info
        MKBXACScanDeviceInfoCell *cell = [MKBXACScanDeviceInfoCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXACScanParamInfoCellModel.class]){
        //Parameter info
        MKBXACScanParamInfoCell *cell = [MKBXACScanParamInfoCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACScanPageAdopterIdenty"];
}

+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXACScanInfoCellModel.class]) {
        //信息帧
        return 65.f;
    }
    if ([dataModel isKindOfClass:MKBXACScanDeviceInfoCellModel.class]) {
        //Device info
        return 155.f;
    }
    if ([dataModel isKindOfClass:MKBXACScanParamInfoCellModel.class]){
        //Parameter info
        return 95.f;
    }
    
    return 0;
}

+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXACScanDeviceInfoCellModel")]) {
        //Device info
        return 0;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXACScanParamInfoCellModel")]) {
        //Parameter info
        return 1;
    }
    
    return 2;
}



#pragma mark - private method
/*
 0:2401MHZ
 1:2402MHZ
 2:2426MHZ
 3:2480MHZ
 4:2481MHZ
 */
+ (NSString *)parseAdvChannel:(NSInteger)channel {
    if (channel == 0) {
        return @"2401MHZ";
    }
    if (channel == 1) {
        return @"2402MHZ";
    }
    if (channel == 2) {
        return @"2426MHZ";
    }
    if (channel == 3) {
        return @"2480MHZ";
    }
    if (channel == 4) {
        return @"2481MHZ";
    }
    return @"";
}

/*
 0: 10ms
 1: 20ms
 2: 50ms
 3: 100ms
 4: 200ms
 5: 250ms
 6: 500ms
 7: 1000ms
 8: 2000ms
 9: 5000ms
 10: 10000ms
 11: 20000ms
 12: 50000ms
 */
+ (NSString *)parseAdvInterval:(NSInteger)interval {
    if (interval == 0) {
        return @"10ms";
    }
    if (interval == 1) {
        return @"20mm";
    }
    if (interval == 2) {
        return @"50mm";
    }
    if (interval == 3) {
        return @"100ms";
    }
    if (interval == 4) {
        return @"200ms";
    }
    if (interval == 5) {
        return @"250ms";
    }
    if (interval == 6) {
        return @"500ms";
    }
    if (interval == 7) {
        return @"1000ms";
    }
    if (interval == 8) {
        return @"2000ms";
    }
    if (interval == 9) {
        return @"5000ms";
    }
    if (interval == 10) {
        return @"10000ms";
    }
    if (interval == 11) {
        return @"20000ms";
    }
    if (interval == 12) {
        return @"50000ms";
    }
    
    return @"";
}

/*
 0: 0dBm
 1: +3dBm
 2: +4dBm
 3: -40dBm
 4: -20dBm
 5: -16dBm
 6: -12dBm
 7: -8dBm
 8: -4dBm
 9: -30dBm
 */
+ (NSString *)parseAdvTxPower:(NSInteger)txPower {
    if (txPower == 0) {
        return @"0dBm";
    }
    if (txPower == 1) {
        return @"+3dBm";
    }
    if (txPower == 2) {
        return @"+4dBm";
    }
    if (txPower == 3) {
        return @"-40dBm";
    }
    if (txPower == 4) {
        return @"-20dBm";
    }
    if (txPower == 5) {
        return @"-16dBm";
    }
    if (txPower == 6) {
        return @"-12dBm";
    }
    if (txPower == 7) {
        return @"-8dBm";
    }
    if (txPower == 8) {
        return @"-4dBm";
    }
    if (txPower == 9) {
        return @"-30dBm";
    }
    return @"";
}

@end
