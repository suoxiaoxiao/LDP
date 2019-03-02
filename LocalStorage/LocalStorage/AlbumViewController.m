//
//  AlbumViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/29.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "AlbumViewController.h"
#import "CollectionViewCell.h"
#import "BigImageViewController.h"
#import "UIImage+compression.h"

@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;
@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation AlbumViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCellID"];
    
    [self.view addSubview:self.collection];
    
    [[CorePhotoAsset sharedInstance] gainPhotosFromAlbum:self.item complate:^(NSArray<CoreAssetBaseItem *> * _Nonnull params,NSError *error) {
        
        if (error) {
            NSLog(@"error%@",error);
            return ;
        }
        [self.dataArray addObjectsFromArray:params];
        [self.collection reloadData];
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCellID" forIndexPath:indexPath];
    
    CoreAssetBaseItem *item = self.dataArray[indexPath.row];
    
    if ([item isKindOfClass:[CorePhotoItem class]]) {
        CorePhotoItem *obj = (CorePhotoItem *)item;
        [cell.image setImage:obj.thumbnailImage.sx_image];
    }
    
    if ([item isKindOfClass:[CoreVideoItem class]]) {
        CoreVideoItem *obj = (CoreVideoItem *)item;
        [cell.image setImage:obj.coverImage.sx_image];
    }
    if (@available(iOS 9.1, *)) {
        if ([item isKindOfClass:[CoreLivePhotoItem class]]) {
            CoreLivePhotoItem *obj = (CoreLivePhotoItem *)item;
            [cell.image setImage:obj.coverImage.sx_image];
        }
    } else {
       
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageViewController *vc = [BigImageViewController new];
    
    CoreAssetBaseItem *item = self.dataArray[indexPath.row];
    
    vc.item = item;
    
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
