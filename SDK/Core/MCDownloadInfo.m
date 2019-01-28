//
// Created by 赵江明 on 15/11/17.
// Copyright (c) 2015 poholo Inc. All rights reserved.
//

#import "MCDownloadInfo.h"

#import "MCProgressInfo.h"

@interface MCDownloadInfo ()

@property(nonatomic, copy) NSString *storePath;

@end

@implementation MCDownloadInfo

- (void)dealloc {
    [self clear];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToInfo:other];
}

- (BOOL)isEqualToInfo:(MCDownloadInfo *)info {
    if (self == info)
        return YES;
    if (info == nil)
        return NO;
    return !(self.cacheName != info.cacheName && ![self.cacheName isEqualToString:info.cacheName]);
}

- (NSUInteger)hash {
    return [self.cacheName hash];
}


- (MCProgressInfo *)progressInfo {
    if (!_progressInfo) {
        _progressInfo = [MCProgressInfo new];
    }

    return _progressInfo;
}

- (NSOutputStream *)outputStream {
    if (!_outputStream) {
        _outputStream = [NSOutputStream outputStreamToFileAtPath:self.storePath append:YES];
    }

    return _outputStream;
}

- (NSString *)storePath {
    if (!_storePath) {
        //TODO:: fix me now @!!!!
//        _storePath = [FileUtil getPath:self.cacheName];
    }

    return _storePath;
}

- (NSURLSessionTaskState)state {
    return self.dataTask.state;
}

- (void)clear {
}

@end

