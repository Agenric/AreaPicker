//
//  AreaPickerView.h
//  AreaPicker
//
//  Created by Agenric on 16/3/30.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaPickerView;
@protocol AreaPickerViewDelegate <NSObject>
- (void)areaPickerView:(AreaPickerView *)areaPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end

@interface AreaPickerView : UIView
@property (weak, nonatomic) id<AreaPickerViewDelegate> delegate;
- (void)show;
@end
