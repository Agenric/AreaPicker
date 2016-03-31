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
}

- (void)areaPickerView:(AreaPickerView *)areaPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    [self.selectedAreaShowLabel setText:[NSString stringWithFormat:@"%@ %@ %@", province, city, district]];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.areaPickerView == nil) {
        self.areaPickerView = [AreaPickerView new];
        self.areaPickerView.delegate = self;
    }
    [self.areaPickerView show];
}

@end
