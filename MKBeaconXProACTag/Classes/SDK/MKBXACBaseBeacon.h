//
//  MKBXACBaseBeacon.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXACDataFrameType) {
    MKBXACUnknowFrameType,
    MKBXACParamInfoPositionFrameType,
    MKBXACTriaxialDataFrameType,
    MKBXACUserDataPositionFrameType,
    MKBXACProductionTestFrameType,
};

@class CBPeripheral;
@interface MKBXACBaseBeacon : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKBXACDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;

@property (nonatomic, assign) BOOL connectEnable;

/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

@property (nonatomic, copy)NSString *deviceName;

+ (MKBXACBaseBeacon *)parseAdvData:(NSDictionary *)advData;

@end



@interface MKBXACParamInfoPositionBeacon : MKBXACBaseBeacon

/*
 0:2401MHZ
 1:2402MHZ
 2:2426MHZ
 3:2480MHZ
 4:2481MHZ
 */
@property (nonatomic, assign)NSInteger advChannel;

@property (nonatomic, assign)BOOL alarmStatus;

/// 100%
@property (nonatomic, copy)NSString *battery;

/*
 0: 10ms
 1: 20ms
 2: 50ms
 3: 100ms
 4: 200ms
 5: 250ms
 6: 500ms
 7: 1000ms
 8: 2000ms
 9: 5000ms
 10: 10000ms
 11: 20000ms
 12: 50000ms
 */
@property (nonatomic, assign)NSInteger advInterval;

/*
 0: 0dBm
 1: +3dBm
 2: +4dBm
 3: -40dBm
 4: -20dBm
 5: -16dBm
 6: -12dBm
 7: -8dBm
 8: -4dBm
 9: -30dBm
 */
@property (nonatomic, assign)NSInteger txPower;

+ (MKBXACParamInfoPositionBeacon *)parseAdvertiseData:(NSString *)advData;

@end



@interface MKBXACTriaxialDataBeacon : MKBXACBaseBeacon

/// X-axis data.(mg)
@property (nonatomic, copy)NSString *xData;

/// Y-axis data.(mg)
@property (nonatomic, copy)NSString *yData;

/// Z-axis data.(mg)
@property (nonatomic, copy)NSString *zData;


+ (MKBXACTriaxialDataBeacon *)parseAdvertiseData:(NSString *)advData;

@end


@interface MKBXACUserDataPositionBeacon : MKBXACBaseBeacon

@property (nonatomic, strong)NSNumber *temperature;

@property (nonatomic, copy)NSString *alarmCount;

+ (MKBXACUserDataPositionBeacon *)parseAdvertiseData:(NSString *)advData;

@end



@interface MKBXACProductionTestBeacon : MKBXACBaseBeacon

@property (nonatomic, copy)NSString *macAddress;

/*
 0:2401MHZ
 1:2402MHZ
 2:2426MHZ
 3:2480MHZ
 4:2481MHZ
 */
@property (nonatomic, assign)NSInteger advChannel;

/// 3333mV
@property (nonatomic, copy)NSString *voltage;

/*
 0: 10ms
 1: 20ms
 2: 50ms
 3: 100ms
 4: 200ms
 5: 250ms
 6: 500ms
 7: 1000ms
 8: 2000ms
 9: 5000ms
 10: 10000ms
 11: 20000ms
 12: 50000ms
 */
@property (nonatomic, assign)NSInteger advInterval;

/*
 0: 0dBm
 1: +3dBm
 2: +4dBm
 3: -40dBm
 4: -20dBm
 5: -16dBm
 6: -12dBm
 7: -8dBm
 8: -4dBm
 9: -30dBm
 */
@property (nonatomic, assign)NSInteger txPower;

+ (MKBXACProductionTestBeacon *)parseAdvertiseData:(NSString *)advData;

@end

NS_ASSUME_NONNULL_END
