//
// Created by 赵江明 on 15/11/17.
// Copyright (c) 2015 poholo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCProgressInfo;

@interface MCDownloadInfo : NSObject {
    NSString * _storePath;
}

/**
 * 保存文件的路径
 */
@property(nonatomic, copy, readonly) NSString *storePath;

/**
 *  进度信息
 */
@property(nonatomic, strong) MCProgressInfo *progressInfo;

/**
 *  下载链接
 */
@property(nonatomic, copy) NSString *urlText;

/**
 *  保存文件名
 */
@property(nonatomic, copy) NSString *cacheName;

/**
 *  通知显示的文件名
 */
@property(nonatomic, copy) NSString *fileName;

/**
 *  下载任务
 */
@property(nonatomic, strong) NSURLSessionDataTask *dataTask;
/**
 *  下载开始时间
 */
@property(nonatomic, strong) NSDate *startTime;

/**
 * 是否有通知提醒
 */
@property(nonatomic, strong) NSNumber *offline;

/**
 *  下载时候的流对象
 */
@property(nonatomic, strong) NSOutputStream *outputStream;

/**
 *  当前请求状态
 */
- (NSURLSessionTaskState)state;

- (void)clear;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToInfo:(MCDownloadInfo *)info;

- (NSUInteger)hash;

@end