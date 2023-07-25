//
//  MKBXACScanInfoCellModel.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXACScanInfoCellModel : NSObject

/// 强业务相关，设备信息帧的广播数组，广播包(4种广播帧)、回应包广播帧会被添加到对应的设备信息帧的广播数组里面来
@property (nonatomic, strong)NSMutableArray *advertiseList;

@property (nonatomic, copy)NSString *rssi;

@property (nonatomic, assign) BOOL connectEnable;

/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *battery;

@property (nonatomic, copy)NSString *macAddress;

/// 用于记录本次扫到该设备距离上次扫到该设备的时间差，单位ms.
@property (nonatomic, copy)NSString *displayTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, assign)NSTimeInterval lastScanDate;

@end

NS_ASSUME_NONNULL_END
