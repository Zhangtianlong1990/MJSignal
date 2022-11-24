//
//  MJCombineSignal.h
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import <Foundation/Foundation.h>
#import "MJSignal.h"

@interface MJCombineSignal : NSObject
- (void)observe:(void(^)(NSArray *values))block;
- (instancetype)initWithSignals:(NSArray<MJSignal *> *)signals;
@end

