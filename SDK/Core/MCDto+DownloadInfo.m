//
// Created by majiancheng on 2017/4/1.
// Copyright (c) 2017 poholo Inc. All rights reserved.
//

#import "MCDto+DownloadInfo.h"

#import <objc/runtime.h>

#import "MCProgressInfo.h"
#import "MCLog.h"


static char *const kStorePath = "kStorePath";
static char *const kUrlText = "kUrlText";
static char *const kCahceName = "kCahceName";
static char *const kTask = "kTask";
static char *const kOutputStream = "kOutputStream";
static char *const kProgressInfo = "kProgressInfo";
static char *const kStartTime = "kStartTime";
static char *const kAllHeaderFields = "allHeaderFields";
static char *const kAllRequestHeaderFileds = "allRequestHeaderFileds";
static char *const kDownloadState = "downloadState";
static char *const kHTTPMethod = "kHTTPMethod";
static char *const kHTTPRequestBody = "kHTTPRequestBody";

NSString *const kLinkSourceDictory = @"LinkSource";
NSString *const kVideoSourceDictory = @"VideoSourceDictory";

@implementation MCDto (DownloadInfo)

- (NSString *)storePath {
    return objc_getAssociatedObject(self, kStorePath);
}

- (void)setStorePath:(NSString *)storePath {
    objc_setAssociatedObject(self, kStorePath, storePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)urlText {
    return objc_getAssociatedObject(self, kUrlText);
}

- (void)setUrlText:(NSString *)urlText {
    objc_setAssociatedObject(self, kUrlText, urlText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cacheName {
    return objc_getAssociatedObject(self, kCahceName);
}

- (void)setCacheName:(NSString *)cacheName {
    objc_setAssociatedObject(self, kCahceName, cacheName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURLSessionTask *)task {
    return objc_getAssociatedObject(self, kTask);
}

- (void)setTask:(NSURLSessionTask *)task {
    objc_setAssociatedObject(self, kTask, task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOutputStream *)outputStream {
    return objc_getAssociatedObject(self, kOutputStream);
}

- (NSDate *)startTime {
    return objc_getAssociatedObject(self, kStartTime);
}

- (void)setStartTime:(NSDate *)startTime {
    objc_setAssociatedObject(self, kStartTime, startTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setOutputStream:(NSOutputStream *)outputStream {
    objc_setAssociatedObject(self, kOutputStream, outputStream, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MCProgressInfo *)progressInfo {
    return objc_getAssociatedObject(self, kProgressInfo);
}

- (void)setProgressInfo:(MCProgressInfo *)progressInfo {
    objc_setAssociatedObject(self, kProgressInfo, progressInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)allHeaderFields {
    return objc_getAssociatedObject(self, &kAllHeaderFields);
}

- (void)setAllHeaderFields:(NSDictionary *)allHeaderFields {
    objc_setAssociatedObject(self, &kAllHeaderFields, allHeaderFields, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)allRequestHeaderFileds {
    return objc_getAssociatedObject(self, &kAllRequestHeaderFileds);
}

- (void)setAllRequestHeaderFileds:(NSDictionary *)allRequestHeaderFileds {
    objc_setAssociatedObject(self, &kAllRequestHeaderFileds, allRequestHeaderFileds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DownloadState)downloadState {
    return (DownloadState) [objc_getAssociatedObject(self, &kDownloadState) integerValue];
}

- (void)setDownloadState:(DownloadState)downloadState {
    objc_setAssociatedObject(self, &kDownloadState, @(downloadState), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHTTPBody:(NSData *)HTTPBody {
    objc_setAssociatedObject(self, &kHTTPRequestBody, HTTPBody, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)HTTPBody {
    return objc_getAssociatedObject(self, &kHTTPRequestBody);
}

- (void)setHTTPMethod:(NSString *)HTTPMethod {
    objc_setAssociatedObject(self, &kHTTPMethod, HTTPMethod, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)HTTPMethod {
    return objc_getAssociatedObject(self, &kHTTPMethod);
}

- (NSURLSessionTaskState)state {
    return self.task.state;
}

- (void)configureDownloadInfo {
    self.cacheName = self.dtoId;
    NSString *rootDictionary;
    NSString *subpath;
//    if ([self isKindOfClass:[LinkDto class]]) {
//        self.storePath = [DraftHelper pickerVideoPath];
//        self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.storePath append:YES];
//        self.urlText = [(LinkDto *) self realURLString];
//        return;
//    } else if ([self isKindOfClass:[LinkRequestDto class]]) {
//        rootDictionary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
//                stringByAppendingPathComponent:kLinkSourceDictory];
//        subpath = [NSString stringWithFormat:@"%@.html", self.dtoId];
//        self.urlText = [(LinkRequestDto *) self url];
//    } else if ([self isKindOfClass:[VideoDto class]]) {
//        rootDictionary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
//                stringByAppendingPathComponent:kVideoSourceDictory];
//        subpath = [NSString stringWithFormat:@"videoCache.mp4"];
//        VideoDto *videoDto = self;
//        NSString *result = [CoreSignHelper parseVideo302URL:self.dtoId ak:videoDto.vk];
//        if ([KTVHTTPCache proxyIsRunning]) {
//            result = [KTVHTTPCache proxyURLStringWithOriginalURLString:result];
//        }
//        self.urlText = result;
//    }

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:rootDictionary]) {
        NSError *error;
        [fm createDirectoryAtPath:rootDictionary withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            MCLog(@"%s _ %@", __func__, error);
        }
    }

    self.storePath = [rootDictionary stringByAppendingPathComponent:subpath];
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.storePath append:YES];
}

- (NSString *)sourcePath {
    NSString *rootDictionary;
    NSString *subpath;
//    if ([self isKindOfClass:[LinkDto class]]) {
//        return [DraftHelper pickerVideoPath];
//    } else if ([self isKindOfClass:[LinkRequestDto class]]) {
//        rootDictionary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
//                stringByAppendingPathComponent:kLinkSourceDictory];
//        subpath = [NSString stringWithFormat:@"%@.html", self.dtoId];
//    } else if ([self isKindOfClass:[VideoDto class]]) {
//        rootDictionary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
//                stringByAppendingPathComponent:kVideoSourceDictory];
//        subpath = [NSString stringWithFormat:@"videoCache.mp4"];
//    }

    return [NSString stringWithFormat:@"%@/%@", rootDictionary, subpath];
}

- (BOOL)isExistSource {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *source = [self sourcePath];
    return [fm fileExistsAtPath:source];
}

- (void)removeSource {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *source = [self sourcePath];
    if ([fm fileExistsAtPath:source]) {
        NSError *error;
        [fm removeItemAtPath:source error:&error];
        if (error) {
            MCLog(@"%@", error);
        }
    }

}


@end
