//
// Created by majiancheng on 2019/2/19.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoDto;


@interface VideoListDataVM : NSObject

@property(nonatomic, strong) NSMutableArray<VideoDto *> *dataList;

- (void)refresh;

- (void)reqVideos:(void (^)(BOOL success, NSArray<VideoDto *> *dataList))callBack;

@end