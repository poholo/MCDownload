//
// Created by majiancheng on 2017/4/1.
// Copyright (c) 2017 poholo Inc. All rights reserved.
//

#import "MCDto.h"

typedef NS_OPTIONS(NSUInteger, DownloadState) {
    Downloading,
    DownloadWait,
    DownloadPause,
    DownloadFail,
    DownloadFinished,
    DownloadInQueue
};


@class MCProgressInfo;

extern NSString *const kARSourceDictory;

extern NSString *const kSnapSourceDictory;


@protocol StoreDelegate <NSObject>

- (void)configureDownloadInfo;

- (NSString *)sourcePath;

- (BOOL)isExistSource;

- (void)removeSource;

@end

@interface MCDto (DownloadInfo) <StoreDelegate>

@property(nonatomic, copy) NSString *storePath;
@property(nonatomic, copy) NSString *urlText;
@property(nonatomic, copy) NSString *cacheName;
@property(nonatomic, strong) NSURLSessionTask *task;
@property(nonatomic, strong) NSOutputStream *outputStream;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) MCProgressInfo *progressInfo;
@property(nonatomic, strong) NSDictionary *allHeaderFields;
@property(nonatomic, strong) NSDictionary *allRequestHeaderFileds;
@property(nonatomic, strong) NSString *HTTPMethod;
@property(nonatomic, strong) NSData *HTTPBody;

@property(nonatomic, assign) DownloadState downloadState;

- (NSURLSessionTaskState)state;

- (void)configureDownloadInfo;

- (NSString *)sourcePath;

- (BOOL)isExistSource;

- (void)removeSource;

@end
