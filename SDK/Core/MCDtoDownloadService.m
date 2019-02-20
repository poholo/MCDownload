//
// Created by majiancheng on 2017/4/1.
// Copyright (c) 2017 poholo Inc. All rights reserved.
//

#import "MCDtoDownloadService.h"

#import "GCDMulticastDelegate.h"
#import "MCProgressInfo.h"
#import "MCDto+DownloadInfo.h"

@interface MCDtoDownloadService () <NSURLSessionDelegate>

@property(nonatomic, strong) NSMutableDictionary<NSString *, MCDto *> *downloadList;

@property(nonatomic, strong) GCDMulticastDelegate <DtoDownloadServiceDelegate> *multicastDelegate;


@end

@implementation MCDtoDownloadService

- (NSMutableDictionary<NSString *, MCDto *> *)downloadList {
    if (_downloadList == nil) {
        _downloadList = [NSMutableDictionary<NSString *, MCDto *> new];
    }
    return _downloadList;
}

- (GCDMulticastDelegate <DtoDownloadServiceDelegate> *)multicastDelegate {
    if (_multicastDelegate == nil) {
        _multicastDelegate = (GCDMulticastDelegate <DtoDownloadServiceDelegate> *) [GCDMulticastDelegate new];
    }
    return _multicastDelegate;
}

- (void)addDownload:(MCDto *)download {
    if (!download.dtoId)
        return;
    if (self.downloadList[download.dtoId] != nil)
        return;
    self.downloadList[download.dtoId] = download;
    [self startDownload];
}

- (void)addDelegate:(id <DtoDownloadServiceDelegate>)delegate {

    [self.multicastDelegate addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id <DtoDownloadServiceDelegate>)delegate {
    [self.multicastDelegate removeDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}


- (void)startDownload {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 5;
    configuration.sessionSendsLaunchEvents = YES;
    configuration.timeoutIntervalForRequest = 20.0;//请求超时时间
    configuration.allowsCellularAccess = YES; //是否允许蜂窝网络下载（2G/3G/4G）
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue new]];

    [self.downloadList.allValues enumerateObjectsUsingBlock:^(MCDto *dto, NSUInteger idx, BOOL *stop) {
        [dto removeSource];
        [dto configureDownloadInfo];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dto.urlText]];
        if (dto.allRequestHeaderFileds) {
            [request setAllHTTPHeaderFields:dto.allRequestHeaderFileds];
        }
        if (dto.HTTPMethod) {
            request.HTTPMethod = dto.HTTPMethod;
        }
        if (dto.HTTPBody.length > 0) {
            request.HTTPBody = dto.HTTPBody;
        }
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
        dto.task = task;
        dto.downloadState = Downloading;
        [task resume];
    }];
}

- (void)cancelAllDownload {
    [self.downloadList.allValues enumerateObjectsUsingBlock:^(MCDto *dto, NSUInteger idx, BOOL *stop) {
        @try {
            if (dto.outputStream) {
                [dto.outputStream streamError];
                [dto.outputStream close];
                dto.outputStream = nil;
            }
            if (dto.task) {
                [dto.task cancel];
                dto.task = nil;
            }
            //finish
            [self.multicastDelegate downloadFinish:dto];
        } @catch (NSException *exception) {
            //error
        }
    }];

    [self.downloadList removeAllObjects];
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler {
    NSLog(@"[Credential]%s--%d", __func__, __LINE__);
    // 如果是请求证书信任，我们再来处理，其他的不需要处理
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 调用block
        completionHandler(NSURLSessionAuthChallengeUseCredential, cre);
    }
}


// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    NSLog(@"[1.Receive]");
    NSHTTPURLResponse *httpurlResponse = (NSHTTPURLResponse *) response;
    for (MCDto *dto in self.downloadList.allValues) {
        if (dto.task == dataTask) {
            unsigned long long expectedLength = [httpurlResponse.allHeaderFields[@"Content-Length"] integerValue] + 0; //];
            if (httpurlResponse.statusCode >= 400) {
                [self.multicastDelegate downloadFail:dto];
                [self.downloadList removeObjectForKey:dto.dtoId];
            } /*else if (expectedLength != -1) {
//                    && [FileUtils freeDiskSpace] < expectedLength) {
                //download error
                [self.multicastDelegate downloadFail:dto];
                [self.downloadList removeObjectForKey:dto.dtoId];
                completionHandler(NSURLSessionResponseCancel);
            }*/ else {
                [self.multicastDelegate downloadStarted:dto];
                dto.allHeaderFields = httpurlResponse.allHeaderFields;
                if (dto.outputStream == nil) {
                    dto.outputStream = [NSOutputStream outputStreamToFileAtPath:dto.storePath append:YES];
                }
                [dto.outputStream open];
                dto.startTime = [NSDate date];
                // 获得已经下载的长度
                if (dto.progressInfo == nil) {
                    dto.progressInfo = [MCProgressInfo new];
                }

                MCProgressInfo *progressInfo = dto.progressInfo;

                NSFileManager *defaultManager = [NSFileManager defaultManager];
                BOOL exist = [defaultManager fileExistsAtPath:dto.storePath];
                if (!exist) {
                    progressInfo.finishedLength = 0;
                }

                NSDictionary *fileAttribute = [defaultManager attributesOfItemAtPath:dto.storePath error:nil];
                if (fileAttribute) {
                    unsigned long long finishedLength = [fileAttribute[NSFileSize] unsignedLongLongValue];
                    progressInfo.finishedLength = finishedLength;
                }

                progressInfo.expectedLength = [httpurlResponse.allHeaderFields[@"Content-Length"] integerValue] + progressInfo.finishedLength;

                // 把文件长度存进列表文

                completionHandler(NSURLSessionResponseAllow);
            }
            return;
        }
    }
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    NSLog(@"[2.DtoDownload]%s--%d", __func__, __LINE__);
    __weak typeof(self) weakSelf = self;
    [self.downloadList.allValues enumerateObjectsUsingBlock:^(MCDto *dto, NSUInteger idx, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (dto.task == dataTask) {
            NSUInteger length = [data length];
            NSInteger result;
            NSOutputStream *outputStream;
            @try {
                if (dto.outputStream == nil) {
                    dto.outputStream = [NSOutputStream outputStreamToFileAtPath:dto.storePath append:YES];
                }
                outputStream = dto.outputStream;
                result = [outputStream write:data.bytes maxLength:data.length];
            } @catch (NSException *exception) {
                result = -1;
            }

            if (result == -1) {
                if (dto.outputStream) {
                    [outputStream streamError];
                    [dto.outputStream close];
                    dto.outputStream = nil;
                }
                if (dto.task) {
                    [dto.task cancel];
                    dto.task = nil;
                }

                [strongSelf.downloadList removeObjectForKey:dto.dtoId];
            } else {
                if (dto.progressInfo == nil) {
                    dto.progressInfo = [MCProgressInfo new];
                }

                MCProgressInfo *progressInfo = dto.progressInfo;
                progressInfo.finishedLength += length;

                [strongSelf executeInMainQueue:^{
                    __strong typeof(strongSelf) st1 = strongSelf;
                    progressInfo.progress = 1.0f * progressInfo.finishedLength / progressInfo.expectedLength;
                    progressInfo.downloadTime = -1 * [dto.startTime timeIntervalSinceNow];
                    progressInfo.speed = (CGFloat) (progressInfo.finishedLength / progressInfo.downloadTime);
                    progressInfo.remainingLength = progressInfo.expectedLength - progressInfo.finishedLength;
                    progressInfo.remainingTime = progressInfo.remainingLength / progressInfo.speed;
                    [st1.multicastDelegate downloading:dto];
                }];
            }
            return;
        }
    }];
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"[3.DtoDownload]%s--%d--%@", __func__, __LINE__, error);
    __weak typeof(self) weakSelf = self;
    [self.downloadList.allValues enumerateObjectsUsingBlock:^(MCDto *dto, NSUInteger idx, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (dto.task == task) {
            if (error || dto.progressInfo.finishedLength < 100) {
                NSInteger errorReasonCode = [error.userInfo[@"NSURLErrorBackgroundTaskCancelledReasonKey"] integerValue];
                if (errorReasonCode == NSURLErrorCancelledReasonUserForceQuitApplication || errorReasonCode == NSURLErrorCancelledReasonBackgroundUpdatesDisabled
                        || error.code == NSURLErrorCancelled || error.code == NSURLErrorTimedOut) {
                    dto.downloadState = DownloadFail;
                    [strongSelf.multicastDelegate downloadFail:dto];
                } else {
                    dto.downloadState = DownloadFail;
                    [strongSelf.multicastDelegate downloadFail:dto];
                }
            } else {
                @try {
                    [dto.outputStream close];
                    dto.outputStream = nil;
                    //finish
                    dto.downloadState = DownloadFinished;
                    [strongSelf.multicastDelegate downloadFinish:dto];
                } @catch (NSException *exception) {
                    //error
                    dto.downloadState = DownloadFail;
                    [strongSelf.multicastDelegate downloadFail:dto];
                }

            }
            [strongSelf.downloadList removeObjectForKey:dto.dtoId];
            return;
        }
    }];
}

- (void)executeInMainQueue:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        if (block) {
            block();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    }
}
@end
