//
//  AdaptiveConstructionProcotol.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/25.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#ifndef AdaptiveConstructionProcotol_h
#define AdaptiveConstructionProcotol_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ConstructionType) {
    ConstructionTypePhoto,
    ConstructionTypeLivePhoto,
    ConstructionTypeVideo,
};


@protocol AdaptiveConstructionProcotol <NSObject>

@property (nonatomic , assign) ConstructionType type;



@end


#endif /* AdaptiveConstructionProcotol_h */
