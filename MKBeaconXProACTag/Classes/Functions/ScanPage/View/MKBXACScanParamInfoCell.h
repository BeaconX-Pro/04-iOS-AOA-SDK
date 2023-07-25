//
//  MKBXACScanParamInfoCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACScanParamInfoCellModel : NSObject

@property (nonatomic, copy)NSString *advChannel;

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, copy)NSString *txPower;

@end

@interface MKBXACScanParamInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXACScanParamInfoCellModel *dataModel;

+ (MKBXACScanParamInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
