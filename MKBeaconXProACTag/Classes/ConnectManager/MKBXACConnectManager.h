//
//  MKBXACConnectManager.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXACConnectManager : NSObject

/// 当前连接密码
@property (nonatomic, copy)NSString *password;

/// 是否需要密码连接
@property (nonatomic, assign)BOOL needPassword;

/// 0:无传感器 1:LIS2DH/LIS3DH  2:STK8328
@property (nonatomic, assign)NSInteger axisType;

/// 0:无温湿度传感器 1:SHT30/SHT31(温湿度) 2:SHT40 (温湿度) 3:STS40(温度)
@property (nonatomic, assign)NSInteger temperatureType;

/// 0:无光感传感器 1:SMD0805-20
@property (nonatomic, assign)NSInteger lightSensorType;

/// 0:无PIR传感器 1:BL612
@property (nonatomic, assign)NSInteger pirSensorType;

/// 0:无红外Tof传感器 1:VL53L3CXV0DH
@property (nonatomic, assign)NSInteger tofSensorType;

+ (MKBXACConnectManager *)shared;

/// 连接设备
/// @param peripheral 设备
/// @param password 密码
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
