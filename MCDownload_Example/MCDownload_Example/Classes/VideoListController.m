//
// Created by majiancheng on 2019/2/19.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "VideoListController.h"
#import "VideoListDataVM.h"
#import "VideoDto.h"
#import "MCDtoDownloadService.h"
#import "../../../SDK/Core/MCDto+DownloadInfo.h"


@interface VideoListController () <DtoDownloadServiceDelegate>

@property(nonatomic, strong) VideoListDataVM *dataVM;

@property(nonatomic, strong) MCDtoDownloadService *downloadService;

@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    VideoDto *dto = self.dataVM.dataList[indexPath.row];
    cell.textLabel.text = dto.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoDto *dto = self.dataVM.dataList[indexPath.row];
    [self.downloadService addDownload:dto];
    [self.downloadService startDownload];
}

#pragma mark - DtoDownloadServiceDelegate

- (void)downloadStarted:(id)download {

}

- (void)downloadChange:(id)download {

}

- (void)downloadCancel:(id)download {

}

- (void)downloadFinish:(id)download {

}

- (void)downloadFail:(id)download {

}

- (void)downloading:(id)download {

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