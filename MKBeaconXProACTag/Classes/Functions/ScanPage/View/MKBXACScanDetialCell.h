//
//  MKBXACScanDetialCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/20.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;

@class MKBXACScanInfoCellModel;

@protocol MKBXACScanDetialCellDelegate <NSObject>

- (void)mk_bxa_connectPeripheral:(CBPeripheral *)peripheral;

@end

@interface MKBXACScanDetialCell : MKBaseCell

@property (nonatomic, strong)MKBXACScanInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXACScanDetialCellDelegate>delegate;

+ (MKBXACScanDetialCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
