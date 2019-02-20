//
// Created by majiancheng on 2019/2/19.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "VideoListDataVM.h"

#import "VideoDto.h"


@implementation VideoListDataVM

- (void)refresh {
    [self.dataList removeAllObjects];
}

- (void)reqVideos:(void (^)(BOOL success, NSArray<VideoDto *> *dataList))callBack {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VideoList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    for (NSDictionary *tmDict in dictionary[@"data"]) {
        VideoDto *dto = [VideoDto createDto:tmDict];
        [self.dataList addObject:dto];
    }
    if (callBack) {
        callBack(YES, self.dataList);
    }
}

- (NSMutableArray<VideoDto *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

@end