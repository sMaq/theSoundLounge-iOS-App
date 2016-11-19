//
//  CreateAlbumViewController.h
//  SoundLounge
//
//  Created by Shahzaib Maqbool on 04/07/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAlbumViewController : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic) BOOL checkCatPickerEnable;
@property(nonatomic) BOOL checkUpdateAlbumPickerEnable;
- (IBAction)updateAlbumBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *updateSelectAlbumPicker;
@property (weak, nonatomic) IBOutlet UIButton *updateAlbumBtnClicked;
- (IBAction)selectAlbumUpdateBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *updateSelectAlbmBtn;
@property(nonatomic) BOOL checkPricePickerEnable;
@property(nonatomic) BOOL checkDeletePickerEnable;
@property (weak, nonatomic) IBOutlet UIScrollView *mainscrollView;
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
- (IBAction)selectImageBtnClicked:(id)sender;
- (IBAction)createAlbumBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UITextField *albumNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *createAlbumBtn;
- (IBAction)categoryBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *pricebtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategory;
- (IBAction)typePricePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *typrPricepickerview;
@property (strong, nonatomic) NSMutableArray *typrPricepickerviewArr;
@property (weak, nonatomic) IBOutlet UIButton *categorybtn;
@property (strong, nonatomic) NSMutableArray *categoryPickerviewArr;
@property (weak, nonatomic) IBOutlet UIView *mainViewCreateAlbum;
@property (weak, nonatomic) IBOutlet UIButton *selectimagebtn;

@property (strong,nonatomic)NSArray * albumsDataArr;
@property (strong,nonatomic)NSArray * albumsNameArr;
@property (strong,nonatomic)NSArray * albumsIDArr;
@property (nonatomic)NSInteger albumsIDIndex;
/////////Popup/////////////
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UITextField *popAlbumname;
@property (weak, nonatomic) IBOutlet UIButton *popselectImageBtn;

- (IBAction)popSlectImageBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *popSelectedImage;
- (IBAction)popSelectCategoryPickerBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *popcatPickerView;

- (IBAction)popSelectTypeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *popSelectTypepickerView;
- (IBAction)popUpdateBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *poptypebtn;
@property (weak, nonatomic) IBOutlet UIButton *popCategoryBtn;

//////
@property (strong,nonatomic)NSArray * albumsCategoryDataArr;
@property (strong,nonatomic)NSArray * albumsCategoryNameArr;
@property (strong,nonatomic)NSArray * albumsCategoryIDArr;
//////////////delete
- (IBAction)dleteBtnCLicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *deletePickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteSelectAlbumBtn;

- (IBAction)deleteBtnSelectAlbumClicked:(id)sender;


@end
