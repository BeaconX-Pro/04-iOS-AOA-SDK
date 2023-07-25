//
//  MKBXACAccelerationModel.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACAccelerationModel : NSObject

/// 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
@property (nonatomic, assign)NSInteger samplingRate;

/// 0:±2g,1:±4g,2:±8g,3:±16g
@property (nonatomic, assign)NSInteger scale;

@property (nonatomic, copy)NSString *threshold;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
