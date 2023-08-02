//
//  MKBXACSDKDataAdopter.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACSDKDataAdopter.h"

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

@implementation MKBXACSDKDataAdopter

/// 解析广播数据中的发射信道
/// - Parameter string: 3位bit位
/*
 000b ->0-> 2401MHZ
 001b ->1-> 2402MHZ
 010b ->2-> 2426MHZ
 011b ->3-> 2480MHZ
 100b ->4-> 2481MHZ
 */
+ (NSInteger)parseAdvChannel:(NSString *)string {
    if (!MKValidStr(string) || string.length != 3) {
        return 0;
    }
    if ([string isEqualToString:@"000"]) {
        return 0;
    }
    if ([string isEqualToString:@"001"]) {
        return 1;
    }
    if ([string isEqualToString:@"010"]) {
        return 2;
    }
    if ([string isEqualToString:@"011"]) {
        return 3;
    }
    if ([string isEqualToString:@"100"]) {
        return 4;
    }
    return 0;
}

/// 解析广播数据中的信道发射功率
/// - Parameter string: 4位bit位
/*
 0000b ->0-> 0dBm
 0001b ->1-> +3dBm
 0010b ->2-> +4dBm
 0011b ->3-> -40dBm
 0100b ->4-> -20dBm
 0101b ->5-> -16dBm
 0110b ->6-> -12dBm
 0111b ->7-> -8dBm
 1000b ->8-> -4dBm
 1001b ->9-> -30dBm
 */
+ (NSInteger)parseAdvTxPower:(NSString *)string {
    if (!MKValidStr(string) || string.length != 4) {
        return 0;
    }
    if ([string isEqualToString:@"0000"]) {
        return 0;
    }
    if ([string isEqualToString:@"0001"]) {
        return 1;
    }
    if ([string isEqualToString:@"0010"]) {
        return 2;
    }
    if ([string isEqualToString:@"0011"]) {
        return 3;
    }
    if ([string isEqualToString:@"0100"]) {
        return 4;
    }
    if ([string isEqualToString:@"0101"]) {
        return 5;
    }
    if ([string isEqualToString:@"0110"]) {
        return 6;
    }
    if ([string isEqualToString:@"0111"]) {
        return 7;
    }
    if ([string isEqualToString:@"1000"]) {
        return 8;
    }
    if ([string isEqualToString:@"1001"]) {
        return 9;
    }
    return 0;
}

/// 解析广播数据中的信道广播间隔
/// - Parameter string: 7位bit位
/*
 1101010b ->0-> 10ms
 1100101b ->1-> 20ms
 1010100b ->2-> 50ms
 1001010b ->3-> 100ms
 1000101b ->4-> 200ms
 1000100b ->5-> 250ms
 1000010b ->6-> 500ms
 1000001b ->7-> 1000ms
 0000010b ->8-> 2000ms
 0000101b ->9-> 5000ms
 0001010b ->10-> 10000ms
 0010100b ->11-> 20000ms
 0100101b ->12-> 50000ms
 */
+ (NSInteger)parseAdvInterval:(NSString *)string {
    if (!MKValidStr(string) || string.length != 7) {
        return 0;
    }
    if ([string isEqualToString:@"1101010"]) {
        return 0;
    }
    if ([string isEqualToString:@"1100101"]) {
        return 1;
    }
    if ([string isEqualToString:@"1010100"]) {
        return 2;
    }
    if ([string isEqualToString:@"1001010"]) {
        return 3;
    }
    if ([string isEqualToString:@"1000101"]) {
        return 4;
    }
    if ([string isEqualToString:@"1000100"]) {
        return 5;
    }
    if ([string isEqualToString:@"1000010"]) {
        return 6;
    }
    if ([string isEqualToString:@"1000001"]) {
        return 7;
    }
    if ([string isEqualToString:@"0000010"]) {
        return 8;
    }
    if ([string isEqualToString:@"0000101"]) {
        return 9;
    }
    if ([string isEqualToString:@"0001010"]) {
        return 10;
    }
    if ([string isEqualToString:@"0010100"]) {
        return 11;
    }
    if ([string isEqualToString:@"0100101"]) {
        return 12;
    }
    return 0;
}

+ (NSString *)parseAdvBattery:(NSString *)string {
    if (!MKValidStr(string) || string.length != 4) {
        return 0;
    }
    NSString *binaryValue = [@"0000" stringByAppendingString:string];
    NSString *hexValue = [MKBLEBaseSDKAdopter getHexByBinary:binaryValue];
    NSInteger value = [MKBLEBaseSDKAdopter getDecimalWithHex:hexValue range:NSMakeRange(0, hexValue.length)];
    return [NSString stringWithFormat:@"%ld",(long)(value * 10)];
}

/// 读取回来的txPower，转换成对应的Tx Power
/*
 d8 ->0-> -40dBm
 e2 ->1-> -30dBm
 ec ->2-> -20dBm
 f0 ->3-> -16dBm
 f4 ->4-> -12dBm
 f8 ->5-> -8dBm
 fc ->6-> -4dBm
 00 ->7-> 0dBm
 03 ->8-> 3dBm
 04 ->9-> 4dBm
 */
/// - Parameter hex: 带符号的16进制数据
+ (NSString *)parseTxPowerWithHex:(NSString *)hex {
    if (!MKValidStr(hex) || ![MKBLEBaseSDKAdopter checkHexCharacter:hex] || hex.length != 2) {
        return @"0";
    }
    if ([hex isEqualToString:@"d8"]) {
        return @"0";
    }
    if ([hex isEqualToString:@"e2"]) {
        return @"1";
    }
    if ([hex isEqualToString:@"ec"]) {
        return @"2";
    }
    if ([hex isEqualToString:@"f0"]) {
        return @"3";
    }
    if ([hex isEqualToString:@"f4"]) {
        return @"4";
    }
    if ([hex isEqualToString:@"f8"]) {
        return @"5";
    }
    if ([hex isEqualToString:@"fc"]) {
        return @"6";
    }
    if ([hex isEqualToString:@"00"]) {
        return @"7";
    }
    if ([hex isEqualToString:@"03"]) {
        return @"8";
    }
    if ([hex isEqualToString:@"04"]) {
        return @"9";
    }
    return @"0";
}

+ (NSString *)parseNormalAdvModeParamCommandString:(id <mk_bxa_normalAdvModeParamProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_bxa_normalAdvModeParamProtocol)]) {
        return @"";
    }
    if (protocol.advInterval < 0 || protocol.advInterval > 65535
        || protocol.advDuration < 1 || protocol.advDuration > 65535
        || protocol.standbyDuration < 0 || protocol.standbyDuration > 65535) {
        return @"";
    }
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:protocol.advInterval byteLen:2];
    NSString *txPower = [self parseTxPowerCommandString:protocol.txPower];
    NSString *advDuration = [MKBLEBaseSDKAdopter fetchHexValue:protocol.advDuration byteLen:2];
    NSString *standyDuration = [MKBLEBaseSDKAdopter fetchHexValue:protocol.standbyDuration byteLen:2];
    NSString *advChannel = [MKBLEBaseSDKAdopter fetchHexValue:protocol.advChannel byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea013508",interval,txPower,advDuration,standyDuration,advChannel];
    return commandString;
}

+ (NSString *)parseButtonTriggerAdvModeParamCommandString:(id <mk_bxa_buttonTriggerAdvModeParamProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_bxa_buttonTriggerAdvModeParamProtocol)]) {
        return @"";
    }
    if (protocol.advInterval < 0 || protocol.advInterval > 65535
        || protocol.advDuration < 1 || protocol.advDuration > 65535) {
        return @"";
    }
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:protocol.advInterval byteLen:2];
    NSString *txPower = [self parseTxPowerCommandString:protocol.txPower];
    NSString *advDuration = [MKBLEBaseSDKAdopter fetchHexValue:protocol.advDuration byteLen:2];
    NSString *triggerType = [MKBLEBaseSDKAdopter fetchHexValue:protocol.triggerType byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea013606",interval,txPower,advDuration,triggerType];
    return commandString;
}

+ (NSString *)fetchThreeAxisDataRate:(mk_bxa_threeAxisDataRate)dataRate {
    switch (dataRate) {
        case mk_bxa_threeAxisDataRate1hz:
            return @"00";
        case mk_bxa_threeAxisDataRate10hz:
            return @"01";
        case mk_bxa_threeAxisDataRate25hz:
            return @"02";
        case mk_bxa_threeAxisDataRate50hz:
            return @"03";
        case mk_bxa_threeAxisDataRate100hz:
            return @"04";
    }
}

+ (NSString *)fetchThreeAxisDataAG:(mk_bxa_threeAxisDataAG)ag {
    switch (ag) {
        case mk_bxa_threeAxisDataAG0:
            return @"00";
        case mk_bxa_threeAxisDataAG1:
            return @"01";
        case mk_bxa_threeAxisDataAG2:
            return @"02";
        case mk_bxa_threeAxisDataAG3:
            return @"03";
    }
}


#pragma mark - private method
+ (NSString *)parseTxPowerCommandString:(mk_bxa_txPower)txPower {
    switch (txPower) {
        case mk_bxa_txPowerNeg40dBm:
            return @"d8";
        case mk_bxa_txPowerNeg30dBm:
            return @"e2";
        case mk_bxa_txPowerNeg20dBm:
            return @"ec";
        case mk_bxa_txPowerNeg16dBm:
            return @"f0";
        case mk_bxa_txPowerNeg12dBm:
            return @"f4";
        case mk_bxa_txPowerNeg8dBm:
            return @"f8";
        case mk_bxa_txPowerNeg4dBm:
            return @"fc";
        case mk_bxa_txPower0dBm:
            return @"00";
        case mk_bxa_txPower3dBm:
            return @"03";
        case mk_bxa_txPower4dBm:
            return @"04";
    }
}

@end
