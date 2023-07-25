//
//  MKBXACPowerConfigModel.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACPowerConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXACInterface.h"
#import "MKBXACInterface+MKBXACConfig.h"

@interface MKBXACPowerConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXACPowerConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readStaticTriggerTimeParams]) {
            [self operationFailedBlockWithMsg:@"Read Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configStaticTriggerTimeParams]) {
            [self operationFailedBlockWithMsg:@"Config Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readStaticTriggerTimeParams {
    __block BOOL success = NO;
    [MKBXACInterface bxa_readStaticTriggerTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger time = [returnData[@"result"][@"time"] integerValue];
        if (time == 0) {
            self.isOn = NO;
        }else {
            self.isOn = YES;
            self.time = returnData[@"result"][@"time"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStaticTriggerTimeParams {
    __block BOOL success = NO;
    NSInteger time = 0;
    if (self.isOn) {
        time = [self.time integerValue];
    }
    [MKBXACInterface bxa_configStaticTriggerTime:time sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"acceleration"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (BOOL)validParams {
    if (!self.isOn) {
        return YES;
    }
    if (!ValidStr(self.time) || [self.time integerValue] < 1 || [self.time integerValue] > 65535) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("accelerationQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
