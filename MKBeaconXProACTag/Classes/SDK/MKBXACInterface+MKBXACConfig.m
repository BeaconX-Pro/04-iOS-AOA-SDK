//
//  MKBXACInterface+MKBXACConfig.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACInterface+MKBXACConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXACCentralManager.h"
#import "MKBXACOperationID.h"
#import "MKBXACOperation.h"
#import "CBPeripheral+MKBXACAdd.h"
#import "MKBXACSDKDataAdopter.h"

#define centralManager [MKBXACCentralManager shared]
#define peripheral ([MKBXACCentralManager shared].peripheral)

@implementation MKBXACInterface (MKBXACConfig)

+ (void)bxa_configThreeAxisDataParams:(mk_bxa_threeAxisDataRate)dataRate
                         acceleration:(mk_bxa_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (motionThreshold < 1 || motionThreshold > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [MKBXACSDKDataAdopter fetchThreeAxisDataRate:dataRate];
    NSString *ag = [MKBXACSDKDataAdopter fetchThreeAxisDataAG:acceleration];
    NSString *threshold = [MKBLEBaseSDKAdopter fetchHexValue:motionThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea012103",rate,ag,threshold];
    [self configDataWithTaskID:mk_bxa_taskConfigThreeAxisDataParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012600";
    [self configDataWithTaskID:mk_bxa_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012800";
    [self configDataWithTaskID:mk_bxa_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01300101" : @"ea01300100");
    [self configDataWithTaskID:mk_bxa_taskConfigTriggerLEDIndicatorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_configNormalAdvModeParam:(id <mk_bxa_normalAdvModeParamProtocol>)protocol
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [MKBXACSDKDataAdopter parseNormalAdvModeParamCommandString:protocol];
    if (!MKValidStr(commandString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    [self configDataWithTaskID:mk_bxa_taskConfigNormalAdvModeParamOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_configButtonTriggerAdvModeParam:(id <mk_bxa_buttonTriggerAdvModeParamProtocol>)protocol
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [MKBXACSDKDataAdopter parseButtonTriggerAdvModeParamCommandString:protocol];
    if (!MKValidStr(commandString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    [self configDataWithTaskID:mk_bxa_taskConfigButtonTriggerAdvModeParamOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxa_configStaticTriggerTime:(NSInteger)time
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [@"ea013702" stringByAppendingString:value];
    [self configDataWithTaskID:mk_bxa_taskConfigStaticTriggerTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}



#pragma mark - AA07 密码相关

+ (void)bxa_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0152",lenString,commandData];
    [self configPasswordDataWithTaskID:mk_bxa_taskConfigConnectPasswordOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

+ (void)bxa_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01530101" : @"ea01530100");
    [self configPasswordDataWithTaskID:mk_bxa_taskConfigPasswordVerificationOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_bxa_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxa_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)configPasswordDataWithTaskID:(mk_bxa_taskOperationID)taskID
                                data:(NSString *)data
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxa_password commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
