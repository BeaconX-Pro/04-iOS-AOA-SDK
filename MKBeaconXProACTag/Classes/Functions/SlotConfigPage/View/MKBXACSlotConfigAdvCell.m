//
//  MKBXACSlotConfigAdvCell.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACSlotConfigAdvCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKSlider.h"
#import "MKPickerView.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXACSlotConfigAdvCellModel
@end

@interface MKBXACSlotConfigAdvCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *channelLabel;

@property (nonatomic, strong)UIButton *channelButton;

@property (nonatomic, strong)UILabel *channelUnitLabel;

@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)UIButton *intervalButton;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UILabel *advDurationLabel;

@property (nonatomic, strong)MKTextField *advDurationTextField;

@property (nonatomic, strong)UILabel *advDurationUnitLabel;

@property (nonatomic, strong)UILabel *standbyDurationLabel;

@property (nonatomic, strong)MKTextField *standbyDurationTextField;

@property (nonatomic, strong)UILabel *standbyDurationUnitLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;


@property (nonatomic, strong)NSArray *channelList;

@property (nonatomic, strong)NSArray *intervalList;

@end

@implementation MKBXACSlotConfigAdvCell

+ (MKBXACSlotConfigAdvCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXACSlotConfigAdvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXACSlotConfigAdvCellIdenty"];
    if (!cell) {
        cell = [[MKBXACSlotConfigAdvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACSlotConfigAdvCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.msgLabel];
        
        [self.backView addSubview:self.channelLabel];
        [self.backView addSubview:self.channelButton];
        [self.backView addSubview:self.channelUnitLabel];
        
        [self.backView addSubview:self.intervalLabel];
        [self.backView addSubview:self.intervalButton];
        [self.backView addSubview:self.intervalUnitLabel];
        
        [self.backView addSubview:self.advDurationLabel];
        [self.backView addSubview:self.advDurationTextField];
        [self.backView addSubview:self.advDurationUnitLabel];
        
        [self.backView addSubview:self.standbyDurationLabel];
        [self.backView addSubview:self.standbyDurationTextField];
        [self.backView addSubview:self.standbyDurationUnitLabel];
        
        [self.backView addSubview:self.txPowerLabel];
        [self.backView addSubview:self.txPowerSlider];
        [self.backView addSubview:self.txPowerValueLabel];
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
    
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.channelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.channelButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.channelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.channelUnitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.channelUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.channelButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
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
        make.top.mas_equalTo(self.channelButton.mas_bottom).mas_offset(10.f);
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
    
    [self.standbyDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.standbyDurationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.standbyDurationTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.standbyDurationUnitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(self.advDurationTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.standbyDurationUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.standbyDurationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.standbyDurationTextField.mas_bottom).mas_offset(10.f);
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

#pragma mark - event method
- (void)channelButtonPressed {
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < self.channelList.count; i ++) {
        if ([self.channelButton.titleLabel.text isEqualToString:self.channelList[i]]) {
            index = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.channelList selectedRow:index block:^(NSInteger currentRow) {
        [self.channelButton setTitle:self.channelList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(bxa_slotConfigAdvCell_channelChanged:)]) {
            [self.delegate bxa_slotConfigAdvCell_channelChanged:currentRow];
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
        if ([self.delegate respondsToSelector:@selector(bxa_slotConfigAdvCell_intervalChanged:)]) {
            [self.delegate bxa_slotConfigAdvCell_intervalChanged:currentRow];
        }
    }];
}

- (void)txPowerSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.txPowerSlider.value];
    self.txPowerValueLabel.text = [self txPowerValueText:[value integerValue]];
    if ([self.delegate respondsToSelector:@selector(bxa_slotConfigAdvCell_txPowerChanged:)]) {
        [self.delegate bxa_slotConfigAdvCell_txPowerChanged:[value integerValue]];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXACSlotConfigAdvCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXACSlotConfigAdvCellModel.class]) {
        return;
    }
    [self.channelButton setTitle:self.channelList[_dataModel.advChannel] forState:UIControlStateNormal];
    [self.intervalButton setTitle:self.intervalList[_dataModel.advInterval] forState:UIControlStateNormal];
    self.advDurationTextField.text = SafeStr(_dataModel.advDuration);
    self.standbyDurationTextField.text = SafeStr(_dataModel.standbyDuration);
    self.txPowerSlider.value = _dataModel.advTxPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.advTxPower];
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

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACSlotConfigAdvCell", @"bxa_slot_baseParams.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Adv Parameters";
    }
    return _msgLabel;
}

- (UILabel *)channelLabel {
    if (!_channelLabel) {
        _channelLabel = [self loadLabelWithMsg:@"Adv channel"];
    }
    return _channelLabel;
}

- (UIButton *)channelButton {
    if (!_channelButton) {
        _channelButton = [MKCustomUIAdopter customButtonWithTitle:@"2401"
                                                           target:self
                                                           action:@selector(channelButtonPressed)];
        _channelButton.titleLabel.font = MKFont(12.f);
    }
    return _channelButton;
}

- (UILabel *)channelUnitLabel {
    if (!_channelUnitLabel) {
        _channelUnitLabel = [self loadLabelWithMsg:@"MHZ"];
    }
    return _channelUnitLabel;
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
            if ([self.delegate respondsToSelector:@selector(bxa_slotConfigAdvCell_advDurationChanged:)]) {
                [self.delegate bxa_slotConfigAdvCell_advDurationChanged:text];
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

- (UILabel *)standbyDurationLabel {
    if (!_standbyDurationLabel) {
        _standbyDurationLabel = [self loadLabelWithMsg:@"Standby duration"];
    }
    return _standbyDurationLabel;
}

- (MKTextField *)standbyDurationTextField {
    if (!_standbyDurationTextField) {
        _standbyDurationTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                         placeHolder:@"0~65535"
                                                                            textType:mk_realNumberOnly];
        _standbyDurationTextField.maxLength = 5;
        _standbyDurationTextField.font = MKFont(12.f);
        @weakify(self);
        _standbyDurationTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxa_slotConfigAdvCell_standbyDurationChanged:)]) {
                [self.delegate bxa_slotConfigAdvCell_standbyDurationChanged:text];
            }
        };
    }
    return _standbyDurationTextField;
}

- (UILabel *)standbyDurationUnitLabel {
    if (!_standbyDurationUnitLabel) {
        _standbyDurationUnitLabel = [self loadLabelWithMsg:@"s"];
    }
    return _standbyDurationUnitLabel;
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

- (NSArray *)channelList {
    if (!_channelList) {
        _channelList = @[@"2401",@"2402",@"2426",@"2480",@"2481"];
    }
    return _channelList;
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
