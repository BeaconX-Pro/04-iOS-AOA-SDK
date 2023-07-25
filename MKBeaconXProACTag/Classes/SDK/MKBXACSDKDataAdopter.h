//
//  MKBXACSDKDataAdopter.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXACSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACSDKDataAdopter : NSObject

/// 解析广播数据中的发射信道
/// - Parameter string: 3位bit位
/*
 000b ->0-> 2401MHZ
 001b ->1-> 2402MHZ
 010b ->2-> 2426MHZ
 011b ->3-> 2480MHZ
 100b ->4-> 2481MHZ
 */
+ (NSInteger)parseAdvChannel:(NSString *)string;

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
+ (NSInteger)parseAdvTxPower:(NSString *)string;

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
+ (NSInteger)parseAdvInterval:(NSString *)string;


/// 解析广播数据中的电池电量百分比
/// - Parameter string: 4bit位
+ (NSString *)parseAdvBattery:(NSString *)string;

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
+ (NSString *)parseTxPowerWithHex:(NSString *)hex;


+ (NSString *)parseNormalAdvModeParamCommandString:(id <mk_bxa_normalAdvModeParamProtocol>)protocol;

+ (NSString *)parseButtonTriggerAdvModeParamCommandString:(id <mk_bxa_buttonTriggerAdvModeParamProtocol>)protocol;

+ (NSString *)fetchThreeAxisDataRate:(mk_bxa_threeAxisDataRate)dataRate;
+ (NSString *)fetchThreeAxisDataAG:(mk_bxa_threeAxisDataAG)ag;

@end

NS_ASSUME_NONNULL_END
