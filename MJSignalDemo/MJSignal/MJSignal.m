//
//  MJSinal.m
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import "MJSignal.h"

typedef void(^HandleBlock)(id value);

@interface MJSignal ()
@property (nonatomic,copy) void(^callBack)(id value);
@property (nonatomic,strong) NSMutableArray *blocks;
@property (nonatomic,strong) id value;
@end

@implementation MJSignal{
    dispatch_semaphore_t _sema;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sema = dispatch_semaphore_create(1);
        _blocks = [NSMutableArray array];
    }
    return self;
}

- (void)observe:(void (^)(id))block{
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    [_blocks addObject:[block copy]];
    dispatch_semaphore_signal(_sema);
}
- (void)send:(id)value{
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"signal-send: %@, thread: %@",value,[NSThread currentThread]);
    id lastValue = self.value;
    self.value = value;
    
    if (self.isIgnoreNil && !value) {
        NSLog(@"数据为空不回调");
        return;
    }
    
    if (self.untilDistinctChange && [lastValue isEqual:value]) {
        NSLog(@"数据没改变，不回调");
        return;
    }
    
    for (HandleBlock block in self.blocks) {
        HandleBlock tBlock = [block copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            tBlock(value);
        });
    }
    dispatch_semaphore_signal(_sema);
}

- (void)dealloc{
    
}

@end
