
typedef NS_ENUM(NSInteger, mk_bxa_taskOperationID) {
    mk_bxa_defaultTaskOperationID,
    
#pragma mark - Read
    mk_bxa_taskReadDeviceModelOperation,        //读取产品型号
    mk_bxa_taskReadProductDateOperation,        //读取生产日期
    mk_bxa_taskReadFirmwareOperation,           //读取固件版本
    mk_bxa_taskReadHardwareOperation,           //读取硬件类型
    mk_bxa_taskReadSoftwareOperation,           //读取软件版本
    mk_bxa_taskReadManufacturerOperation,       //读取厂商信息
    mk_bxa_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 自定义读取
    mk_bxa_taskReadMacAddressOperation,         //读取mac地址
    mk_bxa_taskReadThreeAxisDataParamsOperation,    //读取三轴传感器参数
    mk_bxa_taskReadTriggerLEDIndicatorStatusOperation,  //读取触发 led 提醒状态
    mk_bxa_taskReadBatteryVoltageOperation,     //读取电池电压
    mk_bxa_taskReadNormalAdvModeParamOperation, //读取正常广播模式参数
    mk_bxa_taskReadButtonTriggerAdvModeParamOperation,  //读取按键触发广播模式参数
    mk_bxa_taskReadStaticTriggerTimeOperation,          //读取设备省电机制等待时长
    mk_bxa_taskReadSensorTypeOperation,         //读取传感器类型
    
    
    
#pragma mark - 自定义配置
    mk_bxa_taskConfigThreeAxisDataParamsOperation,  //配置三轴传感器参数
    mk_bxa_taskPowerOffOperation,               //关机
    mk_bxa_taskFactoryResetOperation,           //恢复出厂设置
    mk_bxa_taskConfigTriggerLEDIndicatorStatusOperation,    //配置触发 led 提醒状态
    mk_bxa_taskConfigNormalAdvModeParamOperation,       //配置正常广播模式参数
    mk_bxa_taskConfigButtonTriggerAdvModeParamOperation,    //配置按键触发广播模式参数
    mk_bxa_taskConfigStaticTriggerTimeOperation,        //配置设备省电机制等待时长
    
    
#pragma mark - 密码特征
    mk_bxa_taskReadNeedPasswordOperation,                       //读取设备是否需要连接密码
 
#pragma mark - 密码相关
    mk_bxa_connectPasswordOperation,                            //连接密码
    mk_bxa_taskConfigConnectPasswordOperation,                  //修改密码
    mk_bxa_taskConfigPasswordVerificationOperation,             //配置是否需要连接密码
    
};
