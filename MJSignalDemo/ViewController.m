//
//  ViewController.m
//  KVO封装
//
//  Created by 张天龙 on 2022/5/30.
//

#import "ViewController.h"
#import "MJViewModel.h"

@interface ViewController ()
@property (nonatomic,strong) MJViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    nameButton.backgroundColor = [UIColor blueColor];
    [nameButton setTitle:@"updateName" forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(nameButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nameButton];
    
    UIButton *IDButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    IDButton.backgroundColor = [UIColor purpleColor];
    [IDButton setTitle:@"updateID" forState:UIControlStateNormal];
    [IDButton addTarget:self action:@selector(IDButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:IDButton];
    
    self.viewModel = [[MJViewModel alloc] init];
    [self.viewModel.name observe:^(NSString *value) {
        NSLog(@"value: %@",value);
    }];
    
//    [self.viewModel.name observe:^(NSString *value) {
//        NSLog(@"value2: %@",value);
//    }];
    
    [self.viewModel.ID observe:^(NSNumber *value) {
        NSLog(@"ID: %@",value);
    }];
    
//    [self.viewModel.ID observe:^(NSNumber *value) {
//        NSLog(@"ID2: %@",value);
//    }];
    
    [self.viewModel.name_ID observe:^(NSArray *values) {
        
        NSLog(@"observeCombineSignals: %@",values);
        
        if ([values[0] isEqual:[NSNull null]]) {
            NSLog(@"name 值为空");
        }
        
        
    }];
    
//    [self.viewModel.name_ID observe:^(NSArray *values) {
//
//        NSLog(@"observeCombineSignals2: %@",values);
//
//    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //测试多线程情况
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int name = 1;
        [self.viewModel updateTheName:[NSString stringWithFormat:@"name1(%d)",name]];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int name = 2;
        [self.viewModel updateTheName:[NSString stringWithFormat:@"name2(%d)",name]];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int name = 3;
        [self.viewModel updateTheName:[NSString stringWithFormat:@"name3(%d)",name]];
    });
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int ID = 100;
        [self.viewModel updateTheID:ID];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int ID = 120;
        [self.viewModel updateTheID:ID];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int ID = 130;
        [self.viewModel updateTheID:ID];
    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.viewModel = nil;
//    });
    
}

- (void)nameButtonClick{
    int name = arc4random()%100;
    [self.viewModel updateTheName:[NSString stringWithFormat:@"name(%d)",name]];
}

- (void)IDButtonClick{
    int ID = arc4random()%100;
    [self.viewModel updateTheID:ID];
    
}


@end
