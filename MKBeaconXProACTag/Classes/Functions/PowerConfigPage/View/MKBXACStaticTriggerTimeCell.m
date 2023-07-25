//
//  MKBXACStaticTriggerTimeCell.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACStaticTriggerTimeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKSlider.h"
#import "MKPickerView.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXACStaticTriggerTimeCellModel
@end

@interface MKBXACStaticTriggerTimeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKBXACStaticTriggerTimeCell

+ (MKBXACStaticTriggerTimeCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXACStaticTriggerTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXACStaticTriggerTimeCellIdenty"];
    if (!cell) {
        cell = [[MKBXACStaticTriggerTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXACStaticTriggerTimeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXACStaticTriggerTimeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXACStaticTriggerTimeCellModel.class]) {
        return;
    }
    self.textField.text = SafeStr(_dataModel.time);
    self.noteLabel.text = [NSString stringWithFormat:@"*After device keep static for %@ s, it will stop advertising and disable alarm mode to enter into power saving mode until device moves.",SafeStr(_dataModel.time)];
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Static trigger time";
    }
    return _msgLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"1~65535"
                                                             textType:mk_realNumberOnly];
        _textField.font = MKFont(13.f);
        _textField.maxLength = 5;
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            self.noteLabel.text = [NSString stringWithFormat:@"*After device keep static for %@ s, it will stop advertising and disable alarm mode to enter into power saving mode until device moves.",text];
            [self setNeedsLayout];
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxa_staticTriggerTimeCell_timeChanged:)]) {
                [self.delegate bxa_staticTriggerTimeCell_timeChanged:text];
            }
        };
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.font = MKFont(13.f);
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.text = @"s";
    }
    return _unitLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = [UIColor redColor];
        _noteLabel.text = @"*After device keep static for 600s, it will stop advertising and disable alarm mode to enter into power saving mode until device moves.";
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
