//
//  MKBXACQuickSwitchModel.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACQuickSwitchModel : NSObject

@property (nonatomic, assign)BOOL passwordVerification;

@property (nonatomic, assign)BOOL trigger;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
