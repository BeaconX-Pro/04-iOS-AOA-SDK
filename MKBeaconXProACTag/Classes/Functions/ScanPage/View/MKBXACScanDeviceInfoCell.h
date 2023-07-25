//
//  MKBXACScanDeviceInfoCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACScanDeviceInfoCellModel : NSObject

@property (nonatomic, copy)NSString *advChannel;

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, copy)NSString *txPower;

@property (nonatomic, copy)NSString *alarmStatus;

@property (nonatomic, copy)NSString *alarmCount;

@property (nonatomic, copy)NSString *temperature;

@end

@interface MKBXACScanDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXACScanDeviceInfoCellModel *dataModel;

+ (MKBXACScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
