//
//  MJSinal.h
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import <Foundation/Foundation.h>

@interface MJSignal<T> : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL isIgnoreNil;
@property (nonatomic,assign) BOOL untilDistinctChange;
- (void)observe:(void(^)(T value))block;
- (void)send:(T)value;
@end


