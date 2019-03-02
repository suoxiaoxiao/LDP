//
//  CollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        self.image = [[UIImageView alloc] init];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.image];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = self.bounds;
}

@end
