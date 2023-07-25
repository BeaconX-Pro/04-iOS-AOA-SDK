//
//  MKBXACInterface.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXACCentralManager.h"
#import "MKBXACOperationID.h"
#import "MKBXACOperation.h"
#import "CBPeripheral+MKBXACAdd.h"

#define centralManager [MKBXACCentralManager shared]
#define peripheral ([MKBXACCentralManager shared].peripheral)

@implementation MKBXACInterface

#pragma mark ***********************************Device Information****************************************

+ (void)bxa_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadDeviceModelOperation
                           characteristic:peripheral.bxa_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxa_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadProductDateOperation
                           characteristic:peripheral.bxa_productDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxa_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadFirmwareOperation
                           characteristic:peripheral.bxa_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxa_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadHardwareOperation
                           characteristic:peripheral.bxa_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxa_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadSoftwareOperation
                           characteristic:peripheral.bxa_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxa_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxa_taskReadManufacturerOperation
                           characteristic:peripheral.bxa_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ***********************************Custom****************************************

+ (void)bxa_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadMacAddressOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadThreeAxisDataParamsOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadTriggerLEDIndicatorStatusOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadBatteryVoltageOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readNormalAdvModeParamWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadNormalAdvModeParamOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readButtonTriggerAdvModeParamWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadButtonTriggerAdvModeParamOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readStaticTriggerTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadStaticTriggerTimeOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readSensorTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxa_taskReadSensorTypeOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxa_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readPasswordDataWithTaskID:mk_bxa_taskReadNeedPasswordOperation
                             cmdFlag:@"53"
                            sucBlock:^(id returnData) {
        BOOL isOn = [returnData[@"result"][@"state"] isEqualToString:@"01"];
        NSDictionary *dic = @{
            @"msg":@"success",
            @"code":@"1",
            @"result":@{
                @"isOn":@(isOn)
            },
        };
        if (sucBlock) {
            sucBlock(dic);
        }
    } failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)readDataWithTaskID:(mk_bxa_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxa_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readPasswordDataWithTaskID:(mk_bxa_taskOperationID)taskID
                           cmdFlag:(NSString *)flag
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxa_password
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
