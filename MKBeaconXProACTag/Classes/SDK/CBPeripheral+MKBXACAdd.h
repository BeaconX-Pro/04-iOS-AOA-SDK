//
//  CBPeripheral+MKBXACAdd.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBXACAdd)

#pragma mark - 系统信息下面的特征
/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_firmware;

@property (nonatomic, strong, readonly)CBCharacteristic *bxa_productDate;


#pragma mark - 自定义

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_threeSensor;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxa_password;



- (void)bxa_updateCharacterWithService:(CBService *)service;

- (void)bxa_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxa_connectSuccess;

- (void)bxa_setNil;

@end

NS_ASSUME_NONNULL_END
