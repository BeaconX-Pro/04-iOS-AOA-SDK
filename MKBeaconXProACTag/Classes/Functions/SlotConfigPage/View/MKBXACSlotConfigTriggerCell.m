//
//  MKBXACSlotConfigTriggerCell.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACSlotConfigTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKSlider.h"
#import "MKPickerView.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXACSlotConfigTriggerCellModel
@end


@interface MKBXACSlotConfigTriggerCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *triggerTypeLabel;

@property (nonatomic, strong)UIButton *typeButton;


@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)UIButton *intervalButton;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UILabel *advDurationLabel;

@property (nonatomic, strong)MKTextField *advDurationTextField;

@property (nonatomic, strong)UILabel *advDurationUnitLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;


@property (nonatomic, strong)NSArray *triggerTypeList;

@property (nonatomic, strong)NSArray *intervalList;

@end

@implementation MKBXACSlotConfigTriggerCell

+ (MKBXACSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXACSlotConfigTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXACSlotConfigTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKBXACSlotConfigTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACSlotConfigTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(5.f);
        make.bottom.mas_equalTo(-5.f);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxa_slotConfigTriggerCell_triggerStatusChanged:)]) {
        [self.delegate bxa_slotConfigTriggerCell_triggerStatusChanged:!self.switchButton.selected];
    }
}

- (void)typeButtonPressed {
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < self.triggerTypeList.count; i ++) {
        if ([self.typeButton.titleLabel.text isEqualToString:self.triggerTypeList[i]]) {
            index = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.triggerTypeList selectedRow:index block:^(NSInteger currentRow) {
        [self.typeButton setTitle:self.triggerTypeList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(bxa_slotConfigTriggerCell_triggerTypeChanged:)]) {
            [self.delegate bxa_slotConfigTriggerCell_triggerTypeChanged:currentRow];
        }
    }];
}

- (void)intervalButtonPressed {
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < self.intervalList.count; i ++) {
        if ([self.intervalButton.titleLabel.text isEqualToString:self.intervalList[i]]) {
            index = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.intervalList selectedRow:index block:^(NSInteger currentRow) {
        [self.intervalButton setTitle:self.intervalList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(bxa_slotConfigTriggerCell_intervalChanged:)]) {
            [self.delegate bxa_slotConfigTriggerCell_intervalChanged:currentRow];
        }
    }];
}

- (void)txPowerSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.txPowerSlider.value];
    self.txPowerValueLabel.text = [self txPowerValueText:[value integerValue]];
    if ([self.delegate respondsToSelector:@selector(bxa_slotConfigTriggerCell_txPowerChanged:)]) {
        [self.delegate bxa_slotConfigTriggerCell_txPowerChanged:[value integerValue]];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXACSlotConfigTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXACSlotConfigTriggerCellModel.class]) {
        return;
    }
    self.switchButton.selected = _dataModel.trigger;
    UIImage *switchIcon = (_dataModel.trigger ? LOADICON(@"MKBeaconXProACTag", @"MKBXACSlotConfigTriggerCell", @"bxa_switchSelectedIcon.png") : LOADICON(@"MKBeaconXProACTag", @"MKBXACSlotConfigTriggerCell", @"bxa_switchUnselectedIcon.png"));
    [self.switchButton setImage:switchIcon forState:UIControlStateNormal];
    [self.intervalButton setTitle:self.intervalList[_dataModel.triggerInterval] forState:UIControlStateNormal];
    self.advDurationTextField.text = SafeStr(_dataModel.triggerDuration);
    self.txPowerSlider.value = _dataModel.triggerTxPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.triggerTxPower];
    [self.typeButton setTitle:self.triggerTypeList[_dataModel.triggerType] forState:UIControlStateNormal];
    [self.backView mk_removeAllSubviews];
    [self addTopViews];
    if (!_dataModel.trigger) {
        //关闭触发
        [self setupTriggerClose];
        return;
    }
    [self addBottomView];
    [self setupTriggerOpen];
}

#pragma mark - private method
- (NSString *)txPowerValueText:(NSInteger)value{
    if (value == 0){
        return @"-40dBm";
    }
    if (value == 1){
        return @"-30dBm";
    }
    if (value == 2){
        return @"-20dBm";
    }
    if (value == 3){
        return @"-16dBm";
    }
    if (value == 4){
        return @"-12dBm";
    }
    if (value == 5){
        return @"-8dBm";
    }
    if (value == 6){
        return @"-4dBm";
    }
    if (value == 7){
        return @"0dBm";
    }
    if (value == 8) {
        return @"3dBm";
    }
    if (value == 9) {
        return @"4dBm";
    }
    return @"-40dBm";
}

#pragma mark - UI
- (void)addTopViews {
    [self.backView addSubview:self.icon];
    [self.backView addSubview:self.msgLabel];
    [self.backView addSubview:self.switchButton];
}

- (void)setupTriggerClose {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

- (void)addBottomView {
    [self.backView addSubview:self.triggerTypeLabel];
    [self.backView addSubview:self.typeButton];
    
    [self.backView addSubview:self.intervalLabel];
    [self.backView addSubview:self.intervalButton];
    [self.backView addSubview:self.intervalUnitLabel];
    
    [self.backView addSubview:self.advDurationLabel];
    [self.backView addSubview:self.advDurationTextField];
    [self.backView addSubview:self.advDurationUnitLabel];
    
    [self.backView addSubview:self.txPowerLabel];
    [self.backView addSubview:self.txPowerSlider];
    [self.backView addSubview:self.txPowerValueLabel];
}

- (void)setupTriggerOpen {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.triggerTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.typeButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.typeButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.typeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(145.f);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.intervalButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.intervalButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.intervalUnitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.typeButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.intervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.intervalButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.advDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.advDurationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advDurationTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.advDurationUnitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(self.intervalButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.advDurationUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.advDurationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.advDurationTextField.mas_bottom).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACSlotConfigTriggerCell", @"bxa_slotParamsTriggerIcon.png");
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Trigger";
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)triggerTypeLabel {
    if (!_triggerTypeLabel) {
        _triggerTypeLabel = [[UILabel alloc] init];
        _triggerTypeLabel.textColor = DEFAULT_TEXT_COLOR;
        _triggerTypeLabel.textAlignment = NSTextAlignmentLeft;
        _triggerTypeLabel.font = MKFont(15.f);
        _triggerTypeLabel.text = @"Trigger type";
    }
    return _triggerTypeLabel;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [MKCustomUIAdopter customButtonWithTitle:@"Single click button"
                                                        target:self
                                                        action:@selector(typeButtonPressed)];
        _typeButton.titleLabel.font = MKFont(12.f);
    }
    return _typeButton;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [self loadLabelWithMsg:@"Adv interval"];
    }
    return _intervalLabel;
}

- (UIButton *)intervalButton {
    if (!_intervalButton) {
        _intervalButton = [MKCustomUIAdopter customButtonWithTitle:@"10"
                                                            target:self
                                                            action:@selector(intervalButtonPressed)];
        _intervalButton.titleLabel.font = MKFont(12.f);
    }
    return _intervalButton;
}

- (UILabel *)intervalUnitLabel {
    if (!_intervalUnitLabel) {
        _intervalUnitLabel = [self loadLabelWithMsg:@"ms"];
    }
    return _intervalUnitLabel;
}

- (UILabel *)advDurationLabel {
    if (!_advDurationLabel) {
        _advDurationLabel = [self loadLabelWithMsg:@"Adv duration"];
    }
    return _advDurationLabel;
}

- (MKTextField *)advDurationTextField {
    if (!_advDurationTextField) {
        _advDurationTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                     placeHolder:@"1~65535"
                                                                        textType:mk_realNumberOnly];
        _advDurationTextField.maxLength = 5;
        _advDurationTextField.font = MKFont(12.f);
        @weakify(self);
        _advDurationTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxa_slotConfigTriggerCell_durationChanged:)]) {
                [self.delegate bxa_slotConfigTriggerCell_durationChanged:text];
            }
        };
    }
    return _advDurationTextField;
}

- (UILabel *)advDurationUnitLabel {
    if (!_advDurationUnitLabel) {
        _advDurationUnitLabel = [self loadLabelWithMsg:@"s"];
    }
    return _advDurationUnitLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [[UILabel alloc] init];
        _txPowerLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tx power",@"   (-40,-30,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _txPowerLabel;
}

- (MKSlider *)txPowerSlider {
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 9.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(txPowerSliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [[UILabel alloc] init];
        _txPowerValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerValueLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerValueLabel.font = MKFont(11.f);
    }
    return _txPowerValueLabel;
}


- (NSArray *)triggerTypeList {
    if (!_triggerTypeList) {
        _triggerTypeList = @[@"Single click button",@"Press button twice",@"Press button three times"];
    }
    return _triggerTypeList;
}

- (NSArray *)intervalList {
    if (!_intervalList) {
        _intervalList = @[@"10",@"20",@"50",@"100",@"200",@"250",@"500",@"1000",@"2000",@"5000",@"10000",@"20000",@"50000"];
    }
    return _intervalList;
}

- (UILabel *)loadLabelWithMsg:(NSString *)msg {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(12.f);
    label.text = msg;
    return label;
}

@end
