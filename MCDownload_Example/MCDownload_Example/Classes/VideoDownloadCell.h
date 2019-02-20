//
// Created by majiancheng on 2019/2/20.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoDto;

@interface VideoDownloadCell : UITableViewCell

- (void)loadData:(VideoDto *)data;

+ (CGFloat)height;

+ (NSString *)identifier;

@end