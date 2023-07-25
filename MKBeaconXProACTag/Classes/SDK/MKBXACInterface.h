//
//  MKBXACInterface.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACInterface : NSObject

#pragma mark ***********************************Device Information****************************************

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxa_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ***********************************Custom****************************************

/// Read the mac address of the device.
/*
    @{
    @"macAddress":@"AA:BB:CC:DD:EE:FF"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor
 
 @{
 @"samplingRate":The 3-axis accelerometer sampling rate is 5 levels in total, 00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"gravityReference": The 3-axis accelerometer scale is 4 levels, which are 00--±2g；01--±4g；02--±8g；03--±16g
 @"motionThreshold":
 ±2g----->Unit:3.91mg
 ±4g----->Unit:7.81mg
 ±8g----->Unit:15.63mg
 ±16g----->Unit:31.25mg
 }

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxa_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the trigger LED indicator light reminder status.
/*
 @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the Voltage of the device.
/*
 @{
 @"voltage":@"3330",        //mV
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Normal Broadcast Mode Parameters.
/*
 @{
     @"advInteravl":@"500",     //Device advertising interval.Unit:ms
     @"txPower":@"0",           //Device broadcast power.
     @"advDuration":@"10",      //Device broadcast duration.Unit:s
     @"standbyDuration":@"0",   //Device standby time.Unit:s
     @"advChannel":@"0",        //Broadcast channel frequency.
 };
 txPower:
 0-> -40dBm
 1-> -30dBm
 2-> -20dBm
 3-> -16dBm
 4-> -12dBm
 5-> -8dBm
 6-> -4dBm
 7-> 0dBm
 8-> 3dBm
 9-> 4dBm
 
 advChannel:
 @"0":2401MHZ
 @"1":2402MHZ
 @"2":2426MHZ
 @"3":2480MHZ
 @"4":2480MHZ
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readNormalAdvModeParamWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Button trigger broadcast mode parameters.
/*
 @{
     @"advInteravl":@"500",     //Device advertising interval.Unit:ms
     @"txPower":@"0",           //Device broadcast power.
     @"advDuration":@"10",      //Device broadcast duration.Unit:s
     @"triggerTrigger":@"0",    //Trigger Type.
 };
 txPower:
 0-> -40dBm
 1-> -30dBm
 2-> -20dBm
 3-> -16dBm
 4-> -12dBm
 5-> -8dBm
 6-> -4dBm
 7-> 0dBm
 8-> 3dBm
 9-> 4dBm
 
 triggerTrigger:
 @"0":No trigger
 @"1":Single click button.
 @"2":Press button twice.
 @"3":Press button three times.
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readButtonTriggerAdvModeParamWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Static trigger time.
/*
    @{
    @"time":@"5",       //Unit:s,
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readStaticTriggerTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device sensor type.
/*
 @{
     @"axisType":@"1",          //0:No sensor 1:LIS2DH/LIS3DH  2:STK8328
     @"temperatureType":@"1",   //0:No sensor 1:SHT30/SHT31 2:SHT40  3:STS40
     @"lightSensorType":@"0",   //0:No sensor 1:SMD0805-20
     @"pirSensorType":@"0",     //0:No sensor 1:BL612
     @"tofSensorType":@"0",     //0:No sensor 1:VL53L3CXV0DH
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readSensorTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark - AA07 密码相关
/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxa_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
