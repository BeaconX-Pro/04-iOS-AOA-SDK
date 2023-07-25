#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CTMediator+MKBXACAdd.h"
#import "MKBXACConnectManager.h"
#import "MKBXACAboutController.h"
#import "MKBXACAccelerationController.h"
#import "MKBXACAccelerationModel.h"
#import "MKBXACAccelerationHeaderView.h"
#import "MKBXACAccelerationParamsCell.h"
#import "MKBXACDeviceInfoController.h"
#import "MKBXACDeviceInfoModel.h"
#import "MKBXACPowerConfigController.h"
#import "MKBXACPowerConfigModel.h"
#import "MKBXACStaticTriggerTimeCell.h"
#import "MKBXACQuickSwitchController.h"
#import "MKBXACQuickSwitchModel.h"
#import "MKBXACScanPageAdopter.h"
#import "MKBXACScanController.h"
#import "MKBXACScanInfoCellModel.h"
#import "MKBXACScanDetialCell.h"
#import "MKBXACScanDeviceInfoCell.h"
#import "MKBXACScanFilterView.h"
#import "MKBXACScanParamInfoCell.h"
#import "MKBXACSettingController.h"
#import "MKBXACSettingModel.h"
#import "MKBXACSlotConfigController.h"
#import "MKBXACSlotConfigModel.h"
#import "MKBXACSlotConfigAdvCell.h"
#import "MKBXACSlotConfigTriggerCell.h"
#import "MKBXACTabBarController.h"
#import "MKBXACUpdateController.h"
#import "MKBXACDFUModule.h"
#import "CBPeripheral+MKBXACAdd.h"
#import "MKBXACBaseBeacon.h"
#import "MKBXACCentralManager.h"
#import "MKBXACInterface+MKBXACConfig.h"
#import "MKBXACInterface.h"
#import "MKBXACOperation.h"
#import "MKBXACOperationID.h"
#import "MKBXACPeripheral.h"
#import "MKBXACSDK.h"
#import "MKBXACSDKDataAdopter.h"
#import "MKBXACSDKNormalDefines.h"
#import "MKBXACTaskAdopter.h"
#import "Target_BXPAC_Module.h"

FOUNDATION_EXPORT double MKBeaconXProACTagVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXProACTagVersionString[];

