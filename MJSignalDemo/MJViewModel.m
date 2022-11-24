//
//  MJViewModel.m
//  KVO封装
//
//  Created by 张天龙 on 2022/11/23.
//

#import "MJViewModel.h"

@implementation MJViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = [[MJSignal alloc] init];
//        self.name.isIgnoreNil = YES;
        self.name.untilDistinctChange = YES;
        self.ID = [[MJSignal alloc] init];
        self.ID.isIgnoreNil = YES;
        self.ID.untilDistinctChange = YES;
        self.name_ID = [[MJCombineSignal alloc] initWithSignals:@[self.name,self.ID]];
    }
    return self;
}
- (void)updateTheName:(NSString *)name{
    [self.name send:name];
}
- (void)updateTheID:(int)ID{
    [self.ID send:[NSNumber numberWithInt:ID]];
}

- (void)dealloc{
    
}
@end
