//
//  BADatePickerAlert.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/7/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef enum : int {
    kAlertControllerTypeDatePicker,
    kAlertControllerTypeList
} kAlertControllerType;

@protocol BAAlertControllerDelegate <NSObject>
-(void)dateSelected:(NSString * )date withAlert:(id)alert;
-(void)eventSelected:(NSDictionary *)event withAlert:(id)alert;
@end

@interface BAAlertController : UIAlertController <UIPickerViewDelegate, UIPickerViewDataSource>

@property id<BAAlertControllerDelegate> delegate;

-(instancetype)initWithDatePickerAndCallBackBlock:(void (^)(NSString * text))callback;
-(instancetype)initWithPickerWithData:(NSArray *)data CallBackBlock:(void (^)(NSDictionary * event))callback;

@end
