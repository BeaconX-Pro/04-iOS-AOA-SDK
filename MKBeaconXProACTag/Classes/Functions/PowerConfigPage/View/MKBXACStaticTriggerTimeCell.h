//
//  MKBXACStaticTriggerTimeCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACStaticTriggerTimeCellModel : NSObject

@property (nonatomic, copy)NSString *time;

@end


@protocol MKBXACStaticTriggerTimeCellDelegate <NSObject>

- (void)bxa_staticTriggerTimeCell_timeChanged:(NSString *)time;

@end

@interface MKBXACStaticTriggerTimeCell : MKBaseCell

@property (nonatomic, strong)MKBXACStaticTriggerTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKBXACStaticTriggerTimeCellDelegate>delegate;

+ (MKBXACStaticTriggerTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
