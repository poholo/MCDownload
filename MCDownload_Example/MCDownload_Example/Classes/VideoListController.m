//
// Created by majiancheng on 2019/2/19.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "VideoListController.h"
#import "VideoListDataVM.h"
#import "VideoDto.h"
#import "MCDtoDownloadService.h"
#import "MCDto+DownloadInfo.h"
#import "VideoDownloadCell.h"


@interface VideoListController () <DtoDownloadServiceDelegate>

@property(nonatomic, strong) VideoListDataVM *dataVM;

@property(nonatomic, strong) MCDtoDownloadService *downloadService;

@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"MCDownload";

    [self.tableView registerClass:[VideoDownloadCell class] forCellReuseIdentifier:NSStringFromClass([VideoDownloadCell class])];

    [self.dataVM refresh];
    __weak typeof(self) weakSelf = self;
    [self.dataVM reqVideos:^(BOOL success, NSArray<VideoDto *> *dataList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoDownloadCell class]) forIndexPath:indexPath];
    VideoDto *dto = self.dataVM.dataList[indexPath.row];
    [cell loadData:dto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [VideoDownloadCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoDto *dto = self.dataVM.dataList[indexPath.row];
    [self.downloadService addDownload:dto];
    [self.downloadService startDownload];
}

#pragma mark - DtoDownloadServiceDelegate

- (void)downloadStarted:(id)download {
    [self __downloadInfo:download];
}

- (void)downloadChange:(id)download {
    [self __downloadInfo:download];
}

- (void)downloadCancel:(id)download {
    [self __downloadInfo:download];
}

- (void)downloadFinish:(id)download {
    [self __downloadInfo:download];
}

- (void)downloadFail:(id)download {
    [self __downloadInfo:download];
}

- (void)downloading:(id)download {
    [self __downloadInfo:download];
}

- (void)__downloadInfo:(id)download {
    NSInteger idx = [self.dataVM.dataList indexOfObject:download];
    VideoDownloadCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    [cell loadData:download];
}

#pragma mark - getter

- (VideoListDataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [VideoListDataVM new];
    }
    return _dataVM;
}

- (MCDtoDownloadService *)downloadService {
    if (!_downloadService) {
        _downloadService = [MCDtoDownloadService new];
        [_downloadService addDelegate:self];
    }
    return _downloadService;
}


@end