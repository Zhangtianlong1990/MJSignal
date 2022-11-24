//
//  MJCombineSignal.m
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import "MJCombineSignal.h"

typedef void(^HandleBlock)(id value);

@interface MJCombineSignal()

@property (nonatomic,copy) NSArray *signals;
@property (nonatomic,strong) NSMutableArray *haveNotifyNames;
@property (nonatomic,strong) NSMutableArray *haveNotifyValues;
@property (nonatomic,strong) NSMutableArray *blocks;
@end

@implementation MJCombineSignal{
    dispatch_semaphore_t _sema;
}

- (instancetype)initWithSignals:(NSArray<MJSignal *> *)signals{
    self = [super init];
    if (self) {
        NSAssert(signals!=nil, @"监听信号量不能为空");
        NSAssert(signals.count!=0, @"监听信号量不能为空");
        _sema = dispatch_semaphore_create(1);
        self.signals = signals;
        self.haveNotifyNames = [NSMutableArray array];
        self.haveNotifyValues = [NSMutableArray array];
        self.blocks = [NSMutableArray array];
        for (MJSignal *signal in self.signals) {
            NSString *signalDes = [signal description];
            __weak MJCombineSignal *weakSelf = self;
            [signal observe:^(id value) {
                NSLog(@"MJCombineSignal 监听到的:%@ 值为 %@",signalDes,value);
                [weakSelf handleValue:value signalDes:signalDes];
                
            }];
            
        }
    }
    return self;
}
- (void)observe:(void (^)(NSArray *))block{

    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    [self.blocks addObject:[block copy]];
    dispatch_semaphore_signal(_sema);
    
}

- (void)handleValue:(id)value signalDes:(NSString *)signalDes{
    
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    
//    NSLog(@"combine-send: %@, thread: %@",value,[NSThread currentThread]);
    
    if (![self.haveNotifyNames containsObject:signalDes]) {
        [self.haveNotifyNames addObject:signalDes];
        [self.haveNotifyValues addObject:value];
    }else{
        
        NSInteger index = [self.haveNotifyNames indexOfObject:signalDes];
        if (value) {
            [self.haveNotifyValues replaceObjectAtIndex:index withObject:value];
        }else{
            [self.haveNotifyValues replaceObjectAtIndex:index withObject:[NSNull null] ];
        }
    }
    
    BOOL isCanNotify = YES;
    for (MJSignal *signal in self.signals) {
        NSString *description = [signal description];
        if (![self.haveNotifyNames containsObject:description]) {
            isCanNotify = NO;
            break;
        }
        
    }
    
    if (isCanNotify) {
        for (HandleBlock block in self.blocks) {
            HandleBlock tBlock = [block copy];
            NSArray *haveNotifyValues = [self.haveNotifyValues copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                tBlock(haveNotifyValues);
            });
        }
    }
    
    dispatch_semaphore_signal(_sema);
    
}

- (void)dealloc{
    
}
@end
