//
//  MJViewModel.h
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import <Foundation/Foundation.h>
#import "MJSignal.h"
#import "MJCombineSignal.h"

@interface MJViewModel : NSObject
@property (nonatomic,strong) MJSignal<NSString *> *name;
@property (nonatomic,strong) MJSignal<NSNumber *> *ID;
@property (nonatomic,strong) MJCombineSignal *name_ID;
- (void)updateTheName:(NSString *)name;
- (void)updateTheID:(int)ID;
@end


