//
//  BigImageViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/29.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "BigImageViewController.h"
#import <PhotosUI/PhotosUI.h>

@interface BigImageViewController ()

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UIImageView *image;

@property (nonatomic , strong) AVPlayer *player;

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.item isKindOfClass:[CorePhotoItem class]]) {
        
        CorePhotoItem *obj = (CorePhotoItem *)self.item;
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.image = image;
        image.contentMode = UIViewContentModeScaleAspectFit;
        [obj gainLargeImage:^(UIImage * _Nonnull large) {
            [self.image setImage:large];
        }];
        
        [self.view addSubview:image];
        
    } else if ([self.item isKindOfClass:[CoreVideoItem class]]) {
        
        CoreVideoItem *obj = (CoreVideoItem *)self.item;
        //播放视频
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:obj.videoAsset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord
                 withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                       error:nil];
        AVPlayerLayer *layer = [[AVPlayerLayer alloc] init];
        layer.frame = self.view.bounds;
        layer.player = player;
        self.player = player;
        [self.view.layer addSublayer:layer];
        [player play];
        
    } else if (@available(iOS 9.1, *)) {
        
        if ([self.item isKindOfClass:[CoreLivePhotoItem class]]) {
            CoreLivePhotoItem *obj = (CoreLivePhotoItem *)self.item;
            PHLivePhotoView *live = [[PHLivePhotoView alloc] initWithFrame:self.view.bounds];
            [obj gainLive:^(PHLivePhoto *livePhoto) {
                live.livePhoto = livePhoto;
            }];
            [self.view addSubview:live];
        }
        
    } else {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    
}

- (void)dealloc
{
    NSLog(@"BigImageViewController dealloc");
}

@end
