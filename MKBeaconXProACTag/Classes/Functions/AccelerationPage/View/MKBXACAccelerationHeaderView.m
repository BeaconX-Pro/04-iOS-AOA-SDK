//
//  MKBXACAccelerationHeaderView.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACAccelerationHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@interface MKBXACAccelerationHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UILabel *dataLabel;

@end

@implementation MKBXACAccelerationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self.backView addSubview:self.syncLabel];
        [self.backView addSubview:self.dataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(60.f);
    }];
    [self.syncButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    CGFloat width = (kViewWidth - 6 * 15.f) / 3;
    [self.dataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"bxa_synIconAnimationKey"];
    if ([self.delegate respondsToSelector:@selector(bxa_updateThreeAxisNotifyStatus:)]) {
        [self.delegate bxa_updateThreeAxisNotifyStatus:self.syncButton.selected];
    }
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"bxa_synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    self.syncLabel.text = @"Sync";
}

#pragma mark - public method
- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData {
    NSString *xDataString = [NSString stringWithFormat:@"X-axis:%@%@",xData,@"mg"];
    NSString *yDataString = [NSString stringWithFormat:@"Y-axis:%@%@",yData,@"mg"];
    NSString *zDataString = [NSString stringWithFormat:@"Z-axis:%@%@",zData,@"mg"];
    self.dataLabel.text = [NSString stringWithFormat:@"%@;%@;%@",xDataString,yDataString,zDataString];
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

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTarget:self
                        action:@selector(syncButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBeaconXProACTag", @"MKBXACAccelerationHeaderView", @"bxa_threeAxisAcceLoadingIcon.png");
    }
    return _synIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.textColor = DEFAULT_TEXT_COLOR;
        _dataLabel.textAlignment = NSTextAlignmentLeft;
        _dataLabel.font = MKFont(12.f);
        _dataLabel.text = @"X-axis:N/A;Y-axis:N/A;Z-axis:N/A";
    }
    return _dataLabel;
}

@end
