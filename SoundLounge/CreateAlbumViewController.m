//
//  CreateAlbumViewController.m
//  SoundLounge
//
//  Created by Shahzaib Maqbool on 04/07/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "SWRevealViewController.h"
@interface CreateAlbumViewController ()

@end

@implementation CreateAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAlbumsCategoriesData];
    [self loadAlbumsData];
    _popupView.hidden=YES;
    _deletePickerView.delegate=self;
    _deletePickerView.dataSource=self;
    _deletePickerView.hidden=YES;
    _popSelectTypepickerView.delegate=self;
    _popSelectTypepickerView.dataSource=self;
    _popcatPickerView.delegate=self;
    _popcatPickerView.dataSource=self;
    _checkCatPickerEnable=NO;
    _checkPricePickerEnable=NO;
    _checkDeletePickerEnable=NO;
    _checkUpdateAlbumPickerEnable=NO;
    _pickerCategory.delegate=self;
    _pickerCategory.dataSource=self;
    _typrPricepickerview.delegate=self;
    _typrPricepickerview.dataSource=self;
    _typrPricepickerview.hidden=YES;
    _updateSelectAlbumPicker.delegate=self;
    _updateSelectAlbumPicker.dataSource=self;
    _updateSelectAlbumPicker.hidden=YES;
    _pickerCategory.hidden=YES;
    //CGSize scrollableSize = CGSizeMake(320, _mainscrollView.bounds.size.height);
    _mainscrollView.delegate=self;
    //[_mainscrollView setContentSize:scrollableSize];
    //_mainscrollView.directionalLockEnabled = true;
    [_mainscrollView setExclusiveTouch:YES];
    [_mainscrollView setUserInteractionEnabled:YES];
    [_mainViewCreateAlbum setExclusiveTouch:YES];
    [_mainViewCreateAlbum setUserInteractionEnabled:YES];
    [_mainscrollView bringSubviewToFront:_albumNameTextField];
    [_mainscrollView bringSubviewToFront:_pickerCategory];
    [_mainscrollView bringSubviewToFront:_typrPricepickerview];
    [_mainscrollView bringSubviewToFront:_selectedImageView];
    [_mainscrollView bringSubviewToFront:_categorybtn];
    [_mainscrollView bringSubviewToFront:_selectimagebtn];
    [_mainscrollView bringSubviewToFront:_createAlbumBtn];[_mainscrollView bringSubviewToFront:_pricebtn];
    [_mainscrollView bringSubviewToFront:_updateSelectAlbmBtn];
    [_mainscrollView bringSubviewToFront:_updateSelectAlbumPicker];
    [_mainscrollView bringSubviewToFront:_updateAlbumBtnClicked];
    [_mainscrollView bringSubviewToFront:_deletePickerView];
    [_mainscrollView bringSubviewToFront:_deleteBtn];
    _pickerCategory.backgroundColor=[UIColor grayColor];
    _typrPricepickerview.backgroundColor=[UIColor grayColor];
    _updateSelectAlbumPicker.backgroundColor=[UIColor grayColor];
    _popcatPickerView.backgroundColor=[UIColor grayColor];
    _popSelectTypepickerView.backgroundColor=[UIColor grayColor];
    _deletePickerView.backgroundColor=[UIColor grayColor];
    _categoryPickerviewArr=[[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"Three",@"Four",  nil];
    _typrPricepickerviewArr=[[NSMutableArray alloc]initWithObjects:@"free",@"paid", nil];
    [_mainViewCreateAlbum sizeToFit];
    _mainscrollView.contentSize = _mainViewCreateAlbum.bounds.size;
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // Do any additional setup after loading the view.
    // set the content size to be the size our our whole frame
    
    self.mainscrollView.contentSize = self.mainscrollView.frame.size;

}
-(void)viewWillAppear:(BOOL)animated
{
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadAlbumsCategoriesData {
    
    // [self showProgressHUD];
    [WebAPI getGenereCategoriesWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                NSLog(@"Albums Category %@",data);
                _albumsCategoryDataArr=[[NSArray alloc] init];
                _albumsCategoryDataArr=data;
                _albumsCategoryNameArr=[[NSArray alloc] init];
                //NSArray* albums=[data valueForKey:@"albums"];
                _albumsCategoryNameArr=[data valueForKey:@"name"];
                _albumsCategoryIDArr=[data valueForKey:@"category_id"];
                self.pickerCategory.delegate = self;
                self.pickerCategory.dataSource = self;
                [self.pickerCategory reloadAllComponents];
                [_mainscrollView bringSubviewToFront:_pickerCategory];
                _pickerCategory.userInteractionEnabled=YES;
                
            }
            
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
            //  [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    _selectedImageView.image=image;
    _popSelectedImage.image=image;
    // get the ref url
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    

    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void )imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectImageBtnClicked:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)createAlbumBtnClicked:(id)sender {
    if (self.albumNameTextField.text != nil &&
        ![self.albumNameTextField.text isEqualToString:@""] &&
        ![self.categorybtn.titleLabel.text isEqualToString:@"Category"] &&
        ![self.pricebtn.titleLabel.text isEqualToString:@"Type"]
        )
    {
        
        
        [SVProgressHUD show];
        
        [WebAPI addAlbumWithName:self.albumNameTextField.text category:self.categorybtn.titleLabel.text type:self.pricebtn.titleLabel.text artist_id:@"" image:[self base64String:self.selectedImageView.image]  CompletionHandler:^(BOOL isError, NSArray * data) {
            if (isError) {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
               // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                [SVProgressHUD showErrorWithStatus:@"Not Saved Data"];
                return;
            }
            
            if (data) {
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"ALbum Added Successfully" waitUntilDone:NO];
                
                [self loadAlbumsData];
            }
            [SVProgressHUD showSuccessWithStatus:@"Data Saved Successfully"];
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }];
        
        
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
    }
}
-(void)loadAlbumsData {
    
   // [self showProgressHUD];
    [WebAPI getAlbumsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                NSLog(@"Albums new %@",data);
                _albumsDataArr=[[NSArray alloc] init];
                _albumsDataArr=data;
                _albumsNameArr=[[NSArray alloc] init];
                NSArray* albums=[data valueForKey:@"albums"];
                _albumsNameArr=[albums valueForKey:@"name"];
                _albumsIDArr=[albums valueForKey:@"album_id"];
                self.updateSelectAlbumPicker.delegate = self;
                self.updateSelectAlbumPicker.dataSource = self;
                [self.deletePickerView reloadAllComponents];
                [_mainscrollView bringSubviewToFront:_deletePickerView];
                _deletePickerView.userInteractionEnabled=YES;
                [self.updateSelectAlbumPicker reloadAllComponents];
                [_mainscrollView bringSubviewToFront:_updateSelectAlbumPicker];
                _updateSelectAlbumPicker.userInteractionEnabled=YES;
               
            }
            
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
          //  [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];
    
}
- (IBAction)categoryBtnClicked:(id)sender
{
    if(_checkCatPickerEnable) {
        _pickerCategory.hidden=YES;
        [_mainscrollView bringSubviewToFront:_categorybtn];
        _checkCatPickerEnable=NO;
    }
    else
    {
        _pickerCategory.hidden=NO;
        [_mainscrollView bringSubviewToFront:_pickerCategory];
        _checkCatPickerEnable=YES;
    }
    
}
- (IBAction)typePricePicker:(id)sender
{
    if(_checkPricePickerEnable) {
        _typrPricepickerview.hidden=YES;
        [_mainscrollView bringSubviewToFront:_pricebtn];
        
        _checkPricePickerEnable=NO;
    }
    else
    {
        _typrPricepickerview.hidden=NO;
        [_mainscrollView bringSubviewToFront:_typrPricepickerview];
        _checkPricePickerEnable=YES;
    }
    
}
//////Picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView ==_typrPricepickerview || pickerView==_popSelectTypepickerView)
    {
        if (_typrPricepickerviewArr!=nil) {
            return [_typrPricepickerviewArr count];
        }
        else
        {
            return 0;
        }
    }
    else if(pickerView == _pickerCategory || pickerView==_popcatPickerView || pickerView==_deletePickerView)
    {
        if (_albumsCategoryNameArr!=nil) {
            return [_albumsCategoryNameArr count];
        }
        else
        {
            return 0;
        }
    }
    else if(pickerView == _updateSelectAlbumPicker)
    {
        if (_albumsNameArr!=nil) {
            return [_albumsNameArr count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (pickerView==_typrPricepickerview || pickerView==_popSelectTypepickerView) {
        if (_typrPricepickerviewArr!=nil) {
            return [_typrPricepickerviewArr objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
    else if (pickerView==_updateSelectAlbumPicker  || pickerView==_deletePickerView) {
        if (_albumsNameArr!=nil) {
            return [_albumsNameArr objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
    else if(pickerView==_popcatPickerView)
    {
        if (_albumsCategoryNameArr!=nil) {
            return [_albumsCategoryNameArr objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
    else
    {
        if (_albumsCategoryNameArr!=nil) {
            return [_albumsCategoryNameArr objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (thePickerView==_typrPricepickerview || thePickerView==_popSelectTypepickerView) {
        [_pricebtn setTitle:[_typrPricepickerviewArr objectAtIndex:row] forState:UIControlStateNormal];
        [_poptypebtn setTitle:[_typrPricepickerviewArr objectAtIndex:row] forState:UIControlStateNormal];
        _typrPricepickerview.hidden=YES;
        _popSelectTypepickerView.hidden=YES;
        _checkPricePickerEnable=NO;
    }
    else if (thePickerView==_updateSelectAlbumPicker) {
        
        [thePickerView reloadAllComponents];
        [_updateSelectAlbmBtn setTitle:[_albumsNameArr objectAtIndex:row] forState:UIControlStateNormal];
        
        _updateSelectAlbumPicker.hidden=YES;
        _checkUpdateAlbumPickerEnable=NO;
        _albumsIDIndex=row;
    }
    else if (thePickerView==_deletePickerView) {
        
        [thePickerView reloadAllComponents];
        [_deleteSelectAlbumBtn setTitle:[_albumsNameArr objectAtIndex:row] forState:UIControlStateNormal];
        
        _deletePickerView.hidden=YES;
        _checkDeletePickerEnable=NO;
        _albumsIDIndex=row;
    }
    else
    {
        _popcatPickerView.hidden=YES;
        [_categorybtn setTitle:[_albumsCategoryNameArr objectAtIndex:row] forState:UIControlStateNormal];
        [_popCategoryBtn setTitle:[_albumsCategoryNameArr objectAtIndex:row] forState:UIControlStateNormal];
        _pickerCategory.hidden=YES;
        _checkCatPickerEnable=NO;
    }
    
}
//////////////WebAPI /////
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


- (IBAction)selectAlbumUpdateBtnClicked:(id)sender {
    if(_checkUpdateAlbumPickerEnable) {
        _updateSelectAlbumPicker.hidden=YES;
        [_mainscrollView bringSubviewToFront:_updateSelectAlbumPicker];
        _checkUpdateAlbumPickerEnable=NO;
        
        [_updateSelectAlbmBtn setTitle:[_albumsNameArr objectAtIndex:0] forState:UIControlStateNormal];
    }
    else
    {
        _updateSelectAlbumPicker.hidden=NO;
        [_mainscrollView bringSubviewToFront:_updateSelectAlbumPicker];
        _checkUpdateAlbumPickerEnable=YES;
    }
}
- (IBAction)popSlectImageBtnClicked:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)popSelectCategoryPickerBtnClicked:(id)sender {
    {
        if(_checkCatPickerEnable) {
            _popcatPickerView.hidden=YES;
            _checkCatPickerEnable=NO;
        }
        else
        {
            _popcatPickerView.hidden=NO;
            _checkCatPickerEnable=YES;
        }
        
    }
    
}

- (IBAction)popUpdateBtnClicked:(id)sender {
    if (self.popAlbumname.text != nil &&
        ![self.popAlbumname.text isEqualToString:@""] &&
        ![self.popCategoryBtn.titleLabel.text isEqualToString:@"Category"] &&
        ![self.poptypebtn.titleLabel.text isEqualToString:@"Type"]
        )
    {
        
        
        [SVProgressHUD show];
        
        [WebAPI deleteAlbumWithAlbumID:[_albumsIDArr objectAtIndex:_albumsIDIndex] CompletionHandler:^(BOOL isError, NSArray * data) {
            if (isError) {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                [SVProgressHUD showErrorWithStatus:@"Not deleted Data"];
                return;
            }
            
            if (data) {
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"ALbum Deleted Successfully" waitUntilDone:NO];
                
                [self loadAlbumsData];
            }
            [SVProgressHUD showSuccessWithStatus:@"ALbum Deleted Successfully"];
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }];
        
        
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
    }
    
    
}
- (IBAction)updateAlbumBtnClicked:(id)sender {
    if (![self.updateSelectAlbmBtn.titleLabel.text isEqualToString:@"Select Album"]
        )
    {
        _checkCatPickerEnable=NO;
        _checkPricePickerEnable=NO;
        _popcatPickerView.hidden=YES;
        _popSelectTypepickerView.hidden=YES;
        _popupView.hidden=NO;
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Select One Album atleast." waitUntilDone:NO];
    }
    
   
}
- (IBAction)popSelectTypeBtnClicked:(id)sender {
    if(_checkPricePickerEnable) {
        _popSelectTypepickerView.hidden=YES;
        
        _checkPricePickerEnable=NO;
    }
    else
    {
        _popSelectTypepickerView.hidden=NO;
        _checkPricePickerEnable=YES;
    }
}
- (IBAction)dleteBtnCLicked:(id)sender {

    if (![self.deleteSelectAlbumBtn.titleLabel.text isEqualToString:@"Select Album"]
        )
    {
        
        
        [SVProgressHUD show];
        
        [WebAPI updateAlbumWithName:self.popAlbumname.text albumid:[_albumsIDArr objectAtIndex:_albumsIDIndex]  category:self.popCategoryBtn.titleLabel.text type:self.poptypebtn.titleLabel.text artist_id:@"" image:[self base64String:self.popSelectedImage.image]  CompletionHandler:^(BOOL isError, NSArray * data) {
            if (isError) {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                [SVProgressHUD showErrorWithStatus:@"Not Updated Data"];
                return;
            }
            
            if (data) {
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"ALbum Updated Successfully" waitUntilDone:NO];
                _popupView.hidden=YES;
                [self loadAlbumsData];
            }
            [SVProgressHUD showSuccessWithStatus:@"Data Saved Successfully"];
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }];
        
        
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
    }
}
- (IBAction)deleteBtnSelectAlbumClicked:(id)sender {
    if(_checkDeletePickerEnable) {
        _deletePickerView.hidden=YES;
        
        [_mainscrollView bringSubviewToFront:_deletePickerView];
        _checkDeletePickerEnable=NO;
        [_deleteSelectAlbumBtn setTitle:[_albumsNameArr objectAtIndex:0] forState:UIControlStateNormal];
    }
    else
    {
        [_mainscrollView bringSubviewToFront:_deletePickerView];
        _deletePickerView.hidden=NO;
        _checkDeletePickerEnable=YES;
    }
}
@end
