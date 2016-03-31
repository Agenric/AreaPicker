//
//  AreaPickerView.m
//  AreaPicker
//
//  Created by Agenric on 16/3/30.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "AreaPickerView.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define KAnimationTimeInterval 0.2f

@interface AreaPickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, strong) NSDictionary *totalDatas;
@end

@implementation AreaPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AreaPickerView" owner:self options:nil] lastObject];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        [self loadData];
    }
    return self;
}

#pragma mark UIPickerViewDataSource
// 设置分组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
// 设置各分组的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) { // 第一组
        return [self.totalDatas count];
    } else if (component == 1) { // 第二组
        // 省级父类的字典
        NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
        // 省字典
        NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
        return [provinceDictionary count];
    } else { // 第三组
        // 省级父类的字典
        NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
        // 省字典
        NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
        // 市字典
        NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:1]]];
        // 区数组
        NSArray *districtArray = [cityDictionary valueForKey:[[cityDictionary allKeys] firstObject]];
        return [districtArray count];
    }
}
#pragma mark UIPickerViewDelegate
// 设置分组的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH / 3.0f;
//    return component == 0 ? SCREEN_WIDTH * 0.3 : (component == 1 ? SCREEN_WIDTH * 0.3 : SCREEN_WIDTH * 0.4);
}

// 设置单元格的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

//设置显示普通字符串
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    // 省级父类的字典
//    NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
//    // 省字典
//    NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
//    // 市字典
//    NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:1]]];
//    // 区数组
//    NSArray *districtArray = [cityDictionary valueForKey:[[cityDictionary allKeys] firstObject]];
//    
//    if (component == 0) { // 第一组
//        return [[[self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject];
//    } else if (component == 1) { // 第二组
//        return [[[provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject];
//    } else { // 第三组
//        return districtArray[row];
//    }
//}

//设置显示属性字符串，如果该方法和普通字符串方法都实现了，效果是属性字符串
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}

//自定义显示视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3.0f, 30)];
    [desLabel setBackgroundColor:[UIColor clearColor]];
    [desLabel setTextAlignment:NSTextAlignmentCenter];
    [desLabel setFont:[UIFont systemFontOfSize:14]];
    
    // 省级父类的字典
    NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
    // 省字典
    NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
    // 市字典
    NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:1]]];
    // 区数组
    NSArray *districtArray = [cityDictionary valueForKey:[[cityDictionary allKeys] firstObject]];
    
    if (component == 0) { // 第一组
        [desLabel setText:[[[self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject]];
        return desLabel;
    } else if (component == 1) { // 第二组
        [desLabel setText:[[[provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject]];
        return desLabel;
    } else { // 第三组
        if (districtArray.count <= row) {
            return nil;
        }
        [desLabel setText:districtArray[row]];
        return desLabel;
    }
}

// 单元格选中时的委托方法，需要注意的是，单元格的值改变后停止滚动动画停止即调用这个方法，不需要手点击
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 更改第一组的省份之后要更新该省份的市/区
        [self.myPickerView reloadComponent:1];
        [self.myPickerView reloadComponent:2];
        [self.myPickerView selectRow:0 inComponent:1 animated:YES];
        [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1){ // 更改第二组的市之后要更新该市的区
        [self.myPickerView reloadComponent:2];
        [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    }
}

- (IBAction)sureButtonAction:(UIButton *)sender {
    /***********  核心代码区  ************/
    /* 省 */
    NSInteger provinceIndex = [self.myPickerView selectedRowInComponent:0];
    /* 市 */
    NSInteger cityIndex = [self.myPickerView selectedRowInComponent:1];
    /* 区 */
    NSInteger districtIndex = [self.myPickerView selectedRowInComponent:2];
    
    // 省级父类的字典
    NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)provinceIndex]];
    // 省的名字
    NSString *selectedProvinceName = [[provinceFather allKeys] firstObject];
    // 省字典
    NSDictionary *provinceDictionary = [provinceFather valueForKey:selectedProvinceName];
    // 市字典
    NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)cityIndex]];
    // 市的名字
    NSString *selectedCityName = [[cityDictionary allKeys] firstObject];
    // 区数组
    NSArray *districtArray = [cityDictionary valueForKey:selectedCityName];
    // 区名字
    NSString *selectedDistrictName = districtArray[districtIndex];
    /***********  核心代码区  ************/
    
    if ([self.delegate respondsToSelector:@selector(areaPickerView:didFinishedSelectWithProvince:city:district:)]) {
        [self.delegate areaPickerView:self didFinishedSelectWithProvince:selectedProvinceName city:selectedCityName district:selectedDistrictName];
    }
    [self closeAnimation];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self closeAnimation];
}

- (void)closeAnimation {
    [UIView animateWithDuration:KAnimationTimeInterval animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        CGRect frame = self.contentView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark UIPickerView
- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.totalDatas = [NSDictionary dictionaryWithContentsOfFile:path];
    [self.myPickerView selectRow:0 inComponent:0 animated:YES];
    [self.myPickerView selectRow:0 inComponent:1 animated:YES];
    [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    [self.myPickerView reloadAllComponents];
}

#pragma show
- (void)show {
    self.frame = [[UIScreen mainScreen] bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    CGRect frame = self.contentView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    self.contentView.frame = frame;
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [UIView animateWithDuration:KAnimationTimeInterval animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        CGRect frame = self.contentView.frame;
        frame.origin.y = SCREEN_HEIGHT - frame.size.height;
        self.contentView.frame = frame;
    }];
}
@end
