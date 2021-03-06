//
// Created by 赵江明 on 15/11/17.
// Copyright (c) 2015 poholo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface MCProgressInfo : NSObject

/**
 *  下载进度
 */
@property(nonatomic, assign) CGFloat progress;

/**
 *  下载速度
 */
@property(nonatomic, assign) CGFloat speed;

/**
 *  文件总大小
 */
@property(nonatomic, assign) unsigned long long expectedLength;

/**
 *  已下载大小
 */
@property(nonatomic, assign) unsigned long long finishedLength;

/**
 *  未下载大小
 */
@property(nonatomic, assign) unsigned long long remainingLength;

/**
 *  已下载用时
 */
@property(nonatomic, assign) NSTimeInterval downloadTime;

/**
 *  预计剩余下载时间
 */
@property(nonatomic, assign) NSTimeInterval remainingTime;

@end
