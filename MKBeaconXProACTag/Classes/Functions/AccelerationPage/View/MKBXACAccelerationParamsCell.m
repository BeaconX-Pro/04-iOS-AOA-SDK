//
//  MKBXACAccelerationParamsCell.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACAccelerationParamsCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKCustomUIAdopter.h"

#import "MKPickerView.h"
#import "MKTextField.h"

#import "MKBXACConnectManager.h"

@implementation MKBXACAccelerationParamsCellModel
@end

@interface MKBXACAccelerationParamsCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *thresholdLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *thresholdUnitLabel;

@end

@implementation MKBXACAccelerationParamsCell

+ (MKBXACAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXACAccelerationParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXACAccelerationParamsCellIdenty"];
    if (!cell) {
        cell = [[MKBXACAccelerationParamsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACAccelerationParamsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.thresholdLabel];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.thresholdUnitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.thresholdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.thresholdUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.thresholdUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXACAccelerationParamsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.textField.text = SafeStr(_dataModel.threshold);
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

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font= MKFont(15.f);
        _msgLabel.text = @"Sensor parameters";
    }
    return _msgLabel;
}

- (UILabel *)thresholdLabel {
    if (!_thresholdLabel) {
        _thresholdLabel = [[UILabel alloc] init];
        _thresholdLabel.textAlignment = NSTextAlignmentLeft;
        _thresholdLabel.textColor = DEFAULT_TEXT_COLOR;
        _thresholdLabel.font = MKFont(13.f);
        _thresholdLabel.text = @"Motion threshold";
    }
    return _thresholdLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"1~255"
                                                             textType:mk_realNumberOnly];
        _textField.maxLength = 3;
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxa_accelerationMotionThresholdChanged:)]) {
                [self.delegate bxa_accelerationMotionThresholdChanged:text];
            }
        };
    }
    return _textField;
}

- (UILabel *)thresholdUnitLabel {
    if (!_thresholdUnitLabel) {
        _thresholdUnitLabel = [[UILabel alloc] init];
        _thresholdUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _thresholdUnitLabel.font = MKFont(12.f);
        _thresholdUnitLabel.textAlignment = NSTextAlignmentLeft;
        _thresholdUnitLabel.text = @"x16mg";
    }
    return _thresholdUnitLabel;
}

@end
