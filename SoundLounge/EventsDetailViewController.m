//
//  EventsDetailViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
@interface EventsDetailViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;

@property NSDictionary * selectedEvent;

@property UIImagePickerController * imagePicker;
@property UIImage * selectedImage;
@property NSArray * eventsData;

@property BAAlertController * alert;

@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // by default add event
    operationType = kEventAdd;
    
    [self loadEventsData];
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    
}

-(void)loadEventsData {
    
    //[self showProgressHUD];
    [WebAPI getEventsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ( [((NSDictionary *)data).allKeys containsObject:@"msg"] ){
                        self.eventsData = @[];
                        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        return;
                    }
                }
                
                self.eventsData = data;
            }
            
           // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
           // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];

}


#pragma - mark Image Picker

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * pickedImage = (UIImage *) info[UIImagePickerControllerOriginalImage];
    
    if (pickedImage) {
        
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.image = pickedImage;
        _selectedImage = pickedImage;
        
    }
    
}


- (IBAction)uploadImageButtonPressed:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - Table view data source

- (IBAction)selectDateButtonPressed:(UIButton *)sender {
    
    BAAlertController * dateAlert = [[BAAlertController alloc]initWithDatePickerAndCallBackBlock:^(NSString *text) {
        [sender setTitle:text forState:UIControlStateNormal];
    }];
    
    [self presentViewController:dateAlert animated:YES completion:nil];
}


- (IBAction)addEventButtonPressed:(UIButton *)sender {
    
    if (self.eventNameTextField.text != nil &&
        ![self.eventNameTextField.text isEqualToString:@""] &&
        self.locationTextField.text != nil &&
        ![self.locationTextField.text isEqualToString:@""] &&
        self.locationTextField.text != nil &&
        ![self.locationTextField.text isEqualToString:@""] &&
        self.selectedImage != nil &&
        ![self.startDateButton.titleLabel.text isEqualToString:@"Select Date"] &&
        ![self.endDateButton.titleLabel.text isEqualToString:@"Select Date"]
        ){
        
        //[self showProgressHUD];
        [SVProgressHUD show];
        
        [WebAPI addEventWithName:self.eventNameTextField.text eventDescription:self.descriptionTextField.text location:self.locationTextField.text startDate:self.startDateButton.titleLabel.text endDate:self.endDateButton.titleLabel.text image:[self base64String:self.selectedImage] CompletionHandler:^(BOOL isError, NSArray * data) {
            if (isError) {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                return;
            }
            
            if (data) {
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Event Added Successfully" waitUntilDone:NO];
                
                [self loadEventsData];
            }
            
           // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [SVProgressHUD dismiss];
            
        }];
        
        
        
    }
    else {
        [self showInfoAlert:@"Please enter all the details before creating an event"];
    }
    
    
    // add new event
    // show message
    
}
- (IBAction)updateEvent:(UIButton *)sender {
    if (self.eventNameTextField.text != nil &&
        ![self.eventNameTextField.text isEqualToString:@""] &&
        self.locationTextField.text != nil &&
        ![self.locationTextField.text isEqualToString:@""] &&
        self.locationTextField.text != nil &&
        ![self.locationTextField.text isEqualToString:@""] &&
        self.selectedImage != nil &&
        ![self.startDateButton.titleLabel.text isEqualToString:@"Select Date"] &&
        ![self.endDateButton.titleLabel.text isEqualToString:@"Select Date"]
        ){
    NSString * eventID = self.selectedEvent[@"event_id"];
    [WebAPI updateEventWithEventID:eventID name:self.eventNameTextField.text eventDescription:self.descriptionTextField.text location:self.locationTextField.text startDate:self.startDateButton.titleLabel.text endDate:self.endDateButton.titleLabel.text image: [self base64String:self.selectedImage]  CompletionHandler:^(BOOL error, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    return;
                }
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Event Updated Successfully" waitUntilDone:NO];
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }


    }];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
    }
    
}
- (IBAction)deleteEvent:(UIButton *)sender {
    NSString * eventID = self.selectedEvent[@"event_id"];
    [WebAPI deleteEvent:eventID CompletionHandler:^(BOOL error, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    return;
                }
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Event Deleted Successfully" waitUntilDone:NO];
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
 
    }];
    
}

- (IBAction)selectEventForUpdate:(id)sender {
    // show list
    if (self.eventsData != nil || self.eventsData.count > 0) {
        _alert = [[BAAlertController alloc]initWithPickerWithData:self.eventsData CallBackBlock:^(NSDictionary *event) {
            self.selectedEvent = event;
            operationType = kEventUpdate;
            
            //populate data
            self.eventNameTextField.text = event[@"name"];
            self.descriptionTextField.text = event[@"description"];
            self.locationTextField.text = event[@"location"];
            [self.startDateButton setTitle:event[@"start_date"] forState:UIControlStateNormal];
            [self.endDateButton setTitle:event[@"end_date"] forState:UIControlStateNormal];
        }];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    
    
}

- (IBAction)selectEventForDeletion:(id)sender {
    // show list
    if (self.eventsData != nil || self.eventsData.count > 0) {
        _alert = [[BAAlertController alloc]initWithPickerWithData:self.eventsData CallBackBlock:^(NSDictionary *event) {
            self.selectedEvent = event;
            operationType = kEventUpdate;
            
            self.eventNameTextField.text = event[@"name"];
            self.descriptionTextField.text = event[@"description"];
            self.locationTextField.text = event[@"location"];
            [self.startDateButton setTitle:event[@"start_date"] forState:UIControlStateNormal];
            [self.endDateButton setTitle:event[@"end_date"] forState:UIControlStateNormal];
            
        }];
        [self presentViewController:_alert animated:YES completion:nil];
    }

}


- (NSString *)base64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


#pragma mark - helper methods

-(void)showSuccessAlert:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertSuccess withDelegate:nil duration:3];
    
}

-(void)showInfoAlert:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertWarning withDelegate:nil duration:3];
}

-(void)showErrorAlert:(NSString*)text{
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertError withDelegate:nil duration:3];
}


-(void)showProgressHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgressHUB{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
