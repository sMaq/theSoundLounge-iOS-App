//
//  BADatePickerAlert.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/7/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BAAlertController.h"

@interface BAAlertController()
@property UIDatePicker * datePicker;
@property NSString * selectedText;
@property UIViewController * controller;
@property UIPickerView * dataPicker;
@property NSArray * data;

@property NSDictionary * selectedEvent;

@property (nonatomic, copy) void (^callBackBlock)(void);

@end

@implementation BAAlertController

-(instancetype)initWithDatePickerAndCallBackBlock:(void (^)(NSString * text))callback{
    
    self = [super init];
    
    if (self) {

        
        self = [BAAlertController alertControllerWithTitle:@"Select Date" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        CGRect rect = CGRectMake(0, 0, 272, 250);
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:rect];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:10];
        NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        [offsetComponents setYear:00];
        NSDate *minDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        [self.datePicker setMaximumDate:maxDate];
        [self.datePicker setMinimumDate:minDate];
        [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        
        _controller = [[UIViewController alloc]init];
        [_controller setPreferredContentSize:rect.size];

        _controller.view.backgroundColor = [UIColor clearColor];
        
        [_controller.view addSubview:self.datePicker];
        
        [self.datePicker setFrame:rect];
        
        [_controller.view bringSubviewToFront:self.datePicker];
        [_controller.view setUserInteractionEnabled:YES];
        [self.datePicker setUserInteractionEnabled:YES];
        
        
        
        [self setValue:_controller forKey:@"contentViewController"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedText = self.message;
            callback(self.message);
//            [self.delegate dateSelected:self.message withAlert:self];
            
        }];
        
        [self addAction:cancelAction];
        [self addAction:okAction];

    }
    
    return self;
}

-(instancetype)initWithPickerWithData:(NSArray *)data CallBackBlock:(void (^)(NSDictionary * event))callback{
    
    self = [super init];
    if (self) {
        
        self = [BAAlertController alertControllerWithTitle:@"Select Event" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        self.data = data == nil ? @[] : data;
        
        CGRect rect = CGRectMake(0, 0, 272, 250);
        
        self.dataPicker = [[UIPickerView alloc]initWithFrame:rect];
        self.dataPicker.delegate = self;
        self.dataPicker.dataSource = self;
        
        _controller = [[UIViewController alloc]init];
        [_controller setPreferredContentSize:rect.size];
        //    controller.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.80, 0.80);
        _controller.view.backgroundColor = [UIColor clearColor];
        
        [_controller.view addSubview:self.dataPicker];
        
        [self.datePicker setFrame:rect];
        
        [_controller.view bringSubviewToFront:self.dataPicker];
        [_controller.view setUserInteractionEnabled:YES];
        [self.dataPicker setUserInteractionEnabled:YES];
        
        
        
        [self setValue:_controller forKey:@"contentViewController"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.selectedEvent) {
                callback(self.selectedEvent);
//                [self.delegate eventSelected:self.selectedEvent withAlert:self];
            }
            
            
        }];
        
        [self addAction:cancelAction];
        [self addAction:okAction];
        
    }
    
    return self;
}


-(void)datePickerValueChanged{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.message = [dateFormatter stringFromDate:[self.datePicker date]];
}


#pragma mark - pickerview delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.data.count > 0) {
        self.selectedEvent = self.data[row];
    }
    
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.data[row][@"name"];
}




@end
