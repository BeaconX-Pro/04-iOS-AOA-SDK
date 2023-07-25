//
//  MKBXACBaseBeacon.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACBaseBeacon.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXACSDKDataAdopter.h"

@implementation MKBXACBaseBeacon

+ (MKBXACBaseBeacon *)parseAdvData:(NSDictionary *)advData {
    MKBXACBaseBeacon *beacon = [[MKBXACBaseBeacon alloc] init];
    if (!MKValidDict(advData)) {
        return beacon;
    }
    NSDictionary *productionTestDic = advData[CBAdvertisementDataServiceDataKey];
    if (MKValidDict(productionTestDic)) {
        //产测广播帧
        NSData *data = productionTestDic[[CBUUID UUIDWithString:@"EC01"]];
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
        if (MKValidStr(content)) {
            beacon = [MKBXACProductionTestBeacon parseAdvertiseData:content];
        }
    }
    NSData *deviceData = advData[CBAdvertisementDataManufacturerDataKey];
    if (MKValidData(deviceData)) {
        //广播帧
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:deviceData];
        NSString *type = [content substringWithRange:NSMakeRange(6, 2)];
        if ([type isEqualToString:@"10"]) {
            //参数信息定位包
            beacon = [MKBXACParamInfoPositionBeacon parseAdvertiseData:[content substringFromIndex:8]];
        }else if ([type isEqualToString:@"18"]) {
            //三轴数据定位包
            beacon = [MKBXACTriaxialDataBeacon parseAdvertiseData:[content substringFromIndex:8]];
        }else if ([type isEqualToString:@"1c"]) {
            //用户数据定位包
            beacon = [MKBXACUserDataPositionBeacon parseAdvertiseData:[content substringFromIndex:8]];
        }
    }
    return beacon;
}

@end




@implementation MKBXACParamInfoPositionBeacon

+ (MKBXACParamInfoPositionBeacon *)parseAdvertiseData:(NSString *)advData {
    MKBXACParamInfoPositionBeacon *beacon = [[MKBXACParamInfoPositionBeacon alloc] init];
    beacon.frameType = MKBXACParamInfoPositionFrameType;
    NSString *binary1 = [MKBLEBaseSDKAdopter binaryByhex:[advData substringWithRange:NSMakeRange(0, 2)]];
    beacon.advChannel = [MKBXACSDKDataAdopter parseAdvChannel:[binary1 substringWithRange:NSMakeRange(5, 3)]];
    beacon.txPower = [MKBXACSDKDataAdopter parseAdvChannel:[binary1 substringWithRange:NSMakeRange(0, 4)]];
    NSString *binary2 = [MKBLEBaseSDKAdopter binaryByhex:[advData substringWithRange:NSMakeRange(2, 2)]];
    beacon.battery = [MKBXACSDKDataAdopter parseAdvBattery:[binary2 substringWithRange:NSMakeRange(0, 4)]];
    beacon.alarmStatus = [[binary2 substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    NSString *binary3 = [MKBLEBaseSDKAdopter binaryByhex:[advData substringWithRange:NSMakeRange(4, 2)]];
    beacon.advInterval = [MKBXACSDKDataAdopter parseAdvInterval:[binary3 substringWithRange:NSMakeRange(1, 7)]];
    
    return beacon;
}

@end


@implementation MKBXACTriaxialDataBeacon

+ (MKBXACTriaxialDataBeacon *)parseAdvertiseData:(NSString *)advData {
    MKBXACTriaxialDataBeacon *beacon = [[MKBXACTriaxialDataBeacon alloc] init];
    beacon.frameType = MKBXACTriaxialDataFrameType;
    
    NSNumber *xNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[advData substringWithRange:NSMakeRange(0, 2)]];
    beacon.xData = [NSString stringWithFormat:@"%ld",(long)([xNumber integerValue] * 16)];
    
    NSNumber *yNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[advData substringWithRange:NSMakeRange(2, 2)]];
    beacon.yData = [NSString stringWithFormat:@"%ld",(long)([yNumber integerValue] * 16)];
    
    NSNumber *zNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[advData substringWithRange:NSMakeRange(4, 2)]];
    beacon.zData = [NSString stringWithFormat:@"%ld",(long)([zNumber integerValue] * 16)];
    
    return beacon;
}

@end


@implementation MKBXACUserDataPositionBeacon

+ (MKBXACUserDataPositionBeacon *)parseAdvertiseData:(NSString *)advData {
    MKBXACUserDataPositionBeacon *beacon = [[MKBXACUserDataPositionBeacon alloc] init];
    beacon.frameType = MKBXACUserDataPositionFrameType;
    
    beacon.temperature = [MKBLEBaseSDKAdopter signedHexTurnString:[advData substringWithRange:NSMakeRange(0, 2)]];
    beacon.alarmCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:advData range:NSMakeRange(2, 4)];
    
    return beacon;
}

@end


@implementation MKBXACProductionTestBeacon

+ (MKBXACProductionTestBeacon *)parseAdvertiseData:(NSString *)advData {
    
    MKBXACProductionTestBeacon *beacon = [[MKBXACProductionTestBeacon alloc] init];
    beacon.frameType = MKBXACProductionTestFrameType;
    
    beacon.voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:advData range:NSMakeRange(2, 4)];
    NSString *tempMac = [[advData substringWithRange:NSMakeRange(6, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    beacon.macAddress = macAddress;
    
    NSString *advBinary = [MKBLEBaseSDKAdopter binaryByhex:[advData substringWithRange:NSMakeRange(18, 2)]];
    beacon.advChannel = [MKBXACSDKDataAdopter parseAdvChannel:[advBinary substringWithRange:NSMakeRange(5, 3)]];
    beacon.txPower = [MKBXACSDKDataAdopter parseAdvTxPower:[advBinary substringWithRange:NSMakeRange(0, 4)]];
    NSString *frequencyBinary = [MKBLEBaseSDKAdopter binaryByhex:[advData substringWithRange:NSMakeRange(20, 2)]];
    beacon.advInterval = [MKBXACSDKDataAdopter parseAdvInterval:[frequencyBinary substringWithRange:NSMakeRange(1, 7)]];
    
    return beacon;
}

@end
