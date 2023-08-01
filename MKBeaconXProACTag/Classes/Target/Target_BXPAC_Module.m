//
//  Target_BXPAC_Module.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "Target_BXPAC_Module.h"

#import "MKBXACScanController.h"

@implementation Target_BXPAC_Module

- (UIViewController *)Action_BXAC_Module_ScanController:(NSDictionary *)params {
    return [[MKBXACScanController alloc] init];
}

@end
