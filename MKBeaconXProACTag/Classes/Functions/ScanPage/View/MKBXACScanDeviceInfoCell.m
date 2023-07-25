//
//  MKBXACScanDeviceInfoCell.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACScanDeviceInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXACScanDeviceInfoCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.advChannel = @"N/A";
        self.advInterval = @"N/A";
        self.txPower = @"N/A";
        self.alarmStatus = @"N/A";
        self.alarmCount = @"N/A";
        self.temperature = @"N/A";
    }
    return self;
}

@end

@interface MKBXACScanDeviceInfoCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *advChannelLabel;

@property (nonatomic, strong)UILabel *advChannelValueLabel;

@property (nonatomic, strong)UILabel *advIntervalLabel;

@property (nonatomic, strong)UILabel *advIntervalValueLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UILabel *alarmStatusLabel;

@property (nonatomic, strong)UILabel *alarmStatusValueLabel;

@property (nonatomic, strong)UILabel *alarmCountLabel;

@property (nonatomic, strong)UILabel *alarmCountValueLabel;

@property (nonatomic, strong)UILabel *temperatureLabel;

@property (nonatomic, strong)UILabel *temperatureValueLabel;

@end

@implementation MKBXACScanDeviceInfoCell

+ (MKBXACScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXACScanDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXACScanDeviceInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXACScanDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACScanDeviceInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.advChannelLabel];
        [self.contentView addSubview:self.advChannelValueLabel];
        [self.contentView addSubview:self.advIntervalLabel];
        [self.contentView addSubview:self.advIntervalValueLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.txPowerValueLabel];
        [self.contentView addSubview:self.alarmStatusLabel];
        [self.contentView addSubview:self.alarmStatusValueLabel];
        [self.contentView addSubview:self.alarmCountLabel];
        [self.contentView addSubview:self.alarmCountValueLabel];
        [self.contentView addSubview:self.temperatureLabel];
        [self.contentView addSubview:self.temperatureValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.advChannelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advChannelValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.advChannelLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advIntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.advChannelLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advIntervalValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.advIntervalLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.advIntervalLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.alarmStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.alarmStatusValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.alarmStatusLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.alarmCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.alarmStatusLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.alarmCountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.alarmCountLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.temperatureLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.alarmCountLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.temperatureValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.temperatureLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXACScanDeviceInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXACScanDeviceInfoCellModel.class]) {
        return;
    }
    self.advChannelValueLabel.text = SafeStr(_dataModel.advChannel);
    self.advIntervalValueLabel.text = SafeStr(_dataModel.advInterval);
    self.txPowerValueLabel.text = SafeStr(_dataModel.txPower);
    self.alarmStatusValueLabel.text = SafeStr(_dataModel.alarmStatus);
    self.alarmCountValueLabel.text = SafeStr(_dataModel.alarmCount);
    self.temperatureValueLabel.text = SafeStr(_dataModel.temperature);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Device info";
    }
    return _msgLabel;
}

- (UILabel *)advChannelLabel {
    if (!_advChannelLabel) {
        _advChannelLabel = [self createLabel];
        _advChannelLabel.text = @"Adv channel";
    }
    return _advChannelLabel;
}

- (UILabel *)advChannelValueLabel {
    if (!_advChannelValueLabel) {
        _advChannelValueLabel = [self createLabel];
    }
    return _advChannelValueLabel;
}

- (UILabel *)advIntervalLabel {
    if (!_advIntervalLabel) {
        _advIntervalLabel = [self createLabel];
        _advIntervalLabel.text = @"Adv interval";
    }
    return _advIntervalLabel;
}

- (UILabel *)advIntervalValueLabel {
    if (!_advIntervalValueLabel) {
        _advIntervalValueLabel = [self createLabel];
    }
    return _advIntervalValueLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabel];
        _txPowerLabel.text = @"Tx Power";
    }
    return _txPowerLabel;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [self createLabel];
    }
    return _txPowerValueLabel;
}

- (UILabel *)alarmStatusLabel {
    if (!_alarmStatusLabel) {
        _alarmStatusLabel = [self createLabel];
        _alarmStatusLabel.text = @"Alarm status";
    }
    return _alarmStatusLabel;
}

- (UILabel *)alarmStatusValueLabel {
    if (!_alarmStatusValueLabel) {
        _alarmStatusValueLabel = [self createLabel];
    }
    return _alarmStatusValueLabel;
}

- (UILabel *)alarmCountLabel {
    if (!_alarmCountLabel) {
        _alarmCountLabel = [self createLabel];
        _alarmCountLabel.text = @"Alarm count";
    }
    return _alarmCountLabel;
}

- (UILabel *)alarmCountValueLabel {
    if (!_alarmCountValueLabel) {
        _alarmCountValueLabel = [self createLabel];
    }
    return _alarmCountValueLabel;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [self createLabel];
        _temperatureLabel.text = @"Chip temperature";
    }
    return _temperatureLabel;
}

- (UILabel *)temperatureValueLabel {
    if (!_temperatureValueLabel) {
        _temperatureValueLabel = [self createLabel];
    }
    return _temperatureValueLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(10.f);
    return label;
}

@end
