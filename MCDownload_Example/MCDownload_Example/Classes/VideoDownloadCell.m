//
// Created by majiancheng on 2019/2/20.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoDownloadCell.h"
#import "VideoDto.h"
#import "../../../SDK/Core/MCDto+DownloadInfo.h"
#import "../../../SDK/Core/MCProgressInfo.h"

@interface VideoDownloadCell ()

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UILabel *stateLabel;
@property(nonatomic, strong) UILabel *totalLabel;

@end

@implementation VideoDownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)loadData:(VideoDto *)data {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:NULL];
    self.titleLabel.text = data.name;
    self.progressView.progress = data.progressInfo.progress;
    if (data.downloadState == Downloading) {
        self.stateLabel.text = [NSString stringWithFormat:@"%lf", data.progressInfo.speed];
    } else {
        NSString *info = @"";
        if (data.downloadState == DownloadWait) {
            info = @"wait";
        } else if (data.downloadState == DownloadFail) {
            info = @"Fail";
        } else if (data.downloadState == DownloadFinished) {
            info = @"Finished";
        } else if (data.downloadState == DownloadInQueue) {
            info = @"InQueue";
        } else if (data.downloadState == DownloadPause) {
            info = @"pause";
        }
        self.stateLabel.text = info;
    }
    self.totalLabel.text = [NSString stringWithFormat:@"%lld", data.progressInfo.expectedLength];
}


- (void)createViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.totalLabel];
}

- (void)addLayout {
    self.iconImageView.frame = CGRectMake(10, 10, 60, 40);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5,
            10,
            CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.iconImageView.frame) - 20, 12);
    self.progressView.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 4, CGRectGetWidth(self.titleLabel.frame), 5);
    self.stateLabel.frame = CGRectMake(CGRectGetMinX(self.progressView.frame), CGRectGetMaxY(self.progressView.frame) + 4, CGRectGetWidth(self.progressView.frame) / 2.0f, 12);
    self.totalLabel.frame = CGRectMake(CGRectGetMaxX(self.stateLabel.frame), CGRectGetMinY(self.stateLabel.frame), CGRectGetWidth(self.stateLabel.frame), 12);
}

#pragma mark -getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor grayColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = [UIColor grayColor];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.text = @"--";
    }
    return _stateLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.font = [UIFont systemFontOfSize:12];
        _totalLabel.textColor = [UIColor grayColor];
        _totalLabel.text = @"--";
        _totalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalLabel;
}

+ (CGFloat)height {
    return 60.0f;
}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}


@end