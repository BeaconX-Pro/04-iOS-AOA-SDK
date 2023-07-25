//
//  MKBXACScanInfoCellModel.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACScanInfoCellModel.h"

@implementation MKBXACScanInfoCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.battery = @"N/A";
        self.macAddress = @"N/A";
        self.displayTime = @"N/A";
        self.deviceName = @"N/A";
    }
    return self;
}

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
