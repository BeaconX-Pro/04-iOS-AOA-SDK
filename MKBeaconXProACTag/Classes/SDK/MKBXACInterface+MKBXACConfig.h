//
//  MKBXACInterface+MKBXACConfig.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACInterface.h"

#import "MKBXACSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACInterface (MKBXACConfig)

/**
 Setting the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor

 @param dataRate sampling rate
 @param acceleration acceleration
 @param motionThreshold  1~255.
 mk_bxa_threeAxisDataAG0(±2g)----->Unit:3.91mg
 mk_bxa_threeAxisDataAG1(±4g)------>Unit:7.81mg
 mk_bxa_threeAxisDataAG2(±8g)------>Unit:15.63mg
 mk_bxa_threeAxisDataAG3(±16g)------>Unit:31.25mg
 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxa_configThreeAxisDataParams:(mk_bxa_threeAxisDataRate)dataRate
                         acceleration:(mk_bxa_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxa_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the trigger LED indicator light reminder status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Normal Broadcast Mode Parameters.
/// @param protocol protocol.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configNormalAdvModeParam:(id <mk_bxa_normalAdvModeParamProtocol>)protocol
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Button trigger broadcast mode parameters.
/// @param protocol protocol.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configButtonTriggerAdvModeParam:(id <mk_bxa_buttonTriggerAdvModeParamProtocol>)protocol
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Static trigger time.
/// @param time 0s~65535s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configStaticTriggerTime:(NSInteger)time
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark - AA07 密码相关

/// Configure the current connection password of the device.
/// @param password 1~16 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
