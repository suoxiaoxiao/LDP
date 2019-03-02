//
//  FMResultSet+DBResult.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "FMResultSet.h"

@interface FMResultSet (DBResult)

- (id)resultObjectForClass:(Class)cls;

@end
