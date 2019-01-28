//
// Created by majiancheng on 2017/4/1.
// Copyright (c) 2017 poholo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCDto;

@protocol DtoDownloadServiceDelegate <NSObject>

@optional

- (void)downloadStarted:(id)download;

- (void)downloadChange:(id)download;

- (void)downloadCancel:(id)download;

- (void)downloadFinish:(id)download;

- (void)downloadFail:(id)download;

- (void)downloading:(id)download;

@end


@interface MCDtoDownloadService : NSObject

@property(nonatomic, readonly) NSMutableDictionary<NSString *, MCDto *> *downloadList;

- (void)addDownload:(MCDto *)download;

- (void)startDownload;

- (void)cancelAllDownload;

- (void)addDelegate:(id <DtoDownloadServiceDelegate>)delegate;

- (void)removeDelegate:(id <DtoDownloadServiceDelegate>)delegate;

@end