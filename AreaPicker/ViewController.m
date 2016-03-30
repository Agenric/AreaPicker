//
//  ViewController.m
//  AreaPicker
//
//  Created by Agenric on 16/3/30.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "ViewController.h"
#import "AreaPickerView.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define kAreaPickerViewHeight 216
@interface ViewController ()<AreaPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectedAreaShowLabel;
@property (nonatomic, strong) AreaPickerView *areaPickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.areaPickerView];
}

- (void)areaPickerView:(AreaPickerView *)areaPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    [self.selectedAreaShowLabel setText:[NSString stringWithFormat:@"%@ %@ %@", province, city, district]];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect oldFrame = CGRectMake(0, SCREEN_HEIGHT - kAreaPickerViewHeight, SCREEN_WIDTH, kAreaPickerViewHeight);
        self.areaPickerView.frame = oldFrame;
    }];
}

- (IBAction)hiddenButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect oldFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAreaPickerViewHeight);
        self.areaPickerView.frame = oldFrame;
    }];
}

- (AreaPickerView *)areaPickerView {
    if (_areaPickerView == nil) {
        _areaPickerView = [AreaPickerView new];
        _areaPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAreaPickerViewHeight);
        _areaPickerView.delegate = self;
    }
    return _areaPickerView;
}

@end
