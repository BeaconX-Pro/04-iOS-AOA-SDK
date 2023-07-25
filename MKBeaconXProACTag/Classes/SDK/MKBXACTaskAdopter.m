//
//  MKBXACTaskAdopter.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBXACOperationID.h"
#import "MKBXACSDKDataAdopter.h"

@implementation MKBXACTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_bxa_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
        //生产日期
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"productionDate":tempString} operationID:mk_bxa_taskReadProductDateOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_bxa_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_bxa_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_bxa_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_bxa_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        return [self parseCustomData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        //密码相关
        return [self parsePasswordData:readData];
    }
    
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parsePasswordData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parsePasswordReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parsePasswordConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePasswordReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxa_taskOperationID operationID = mk_bxa_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"53"]) {
        //读取设备连接是否需要密码
        operationID = mk_bxa_taskReadNeedPasswordOperation;
        resultDic = @{
            @"state":content
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parsePasswordConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxa_taskOperationID operationID = mk_bxa_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"51"]) {
        //验证密码
        operationID = mk_bxa_connectPasswordOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //修改密码
        operationID = mk_bxa_taskConfigConnectPasswordOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //是否需要密码验证
        operationID = mk_bxa_taskConfigPasswordVerificationOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    
    if (![headerString isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxa_taskOperationID operationID = mk_bxa_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"20"]) {
        //读取MAC地址
        //读取MAC地址
        operationID = mk_bxa_taskReadMacAddressOperation;
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
    }else if ([cmd isEqualToString:@"21"]){
        //读取三轴传感器参数
        operationID = mk_bxa_taskReadThreeAxisDataParamsOperation;
        resultDic = @{
                      @"samplingRate":[content substringWithRange:NSMakeRange(0, 2)],
                      @"gravityReference":[content substringWithRange:NSMakeRange(2, 2)],
                      @"motionThreshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)],
                      };
    }else if ([cmd isEqualToString:@"30"]) {
        //读取触发led提醒状态
        operationID = mk_bxa_taskReadTriggerLEDIndicatorStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"31"]) {
        //读取电池电压
        operationID = mk_bxa_taskReadBatteryVoltageOperation;
        NSString *voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"voltage":voltage,
        };
    }else if ([cmd isEqualToString:@"35"]) {
        //读取正常广播模式参数
        operationID = mk_bxa_taskReadNormalAdvModeParamOperation;
        NSString *advInteravl = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *txPower = [MKBXACSDKDataAdopter parseTxPowerWithHex:[content substringWithRange:NSMakeRange(4, 2)]];
        NSString *advDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSString *standbyDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        NSString *advChannel = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(14, 2)];
        resultDic = @{
            @"advInteravl":advInteravl,
            @"txPower":txPower,
            @"advDuration":advDuration,
            @"standbyDuration":standbyDuration,
            @"advChannel":advChannel,
        };
    }else if ([cmd isEqualToString:@"36"]) {
        //读取按键触发广播模式参数
        operationID = mk_bxa_taskReadButtonTriggerAdvModeParamOperation;
        NSString *advInteravl = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *txPower = [MKBXACSDKDataAdopter parseTxPowerWithHex:[content substringWithRange:NSMakeRange(4, 2)]];
        NSString *advDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSString *triggerTrigger = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
        resultDic = @{
            @"advInteravl":advInteravl,
            @"txPower":txPower,
            @"advDuration":advDuration,
            @"triggerTrigger":triggerTrigger,
        };
    }else if ([cmd isEqualToString:@"37"]) {
        //读取设备省电机制等待时长
        operationID = mk_bxa_taskReadStaticTriggerTimeOperation;
        NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"time":time,
        };
    }else if ([cmd isEqualToString:@"39"]) {
        //读取传感器类型
        operationID = mk_bxa_taskReadSensorTypeOperation;
        resultDic = @{
            @"axisType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"temperatureType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
            @"lightSensorType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)],
            @"pirSensorType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)],
            @"tofSensorType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)],
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxa_taskOperationID operationID = mk_bxa_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"01"]) {
        //
    }else if ([cmd isEqualToString:@"21"]) {
        //配置三轴传感器参数
        operationID = mk_bxa_taskConfigThreeAxisDataParamsOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //关机
        operationID = mk_bxa_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //恢复出厂设置
        operationID = mk_bxa_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //配置触发 led 提醒状态
        operationID = mk_bxa_taskConfigTriggerLEDIndicatorStatusOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //配置正常广播模式参数
        operationID = mk_bxa_taskConfigNormalAdvModeParamOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //配置按键触发广播模式参数
        operationID = mk_bxa_taskConfigButtonTriggerAdvModeParamOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //配置设备省电机制等待时长
        operationID = mk_bxa_taskConfigStaticTriggerTimeOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_bxa_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
