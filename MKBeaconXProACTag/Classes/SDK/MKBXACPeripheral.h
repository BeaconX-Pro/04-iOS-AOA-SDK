//
//  MKBXACPeripheral.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXACPeripheral : NSObject<MKBLEBasePeripheralProtocol>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
