//
//  UploadSongDetailViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/15/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "UploadSongDetailViewController.h"
#import "HotBox.h"
#import "MBProgressHUD.h"
#import "ActionSheetPicker.h"

@interface UploadSongDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *musicNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *musicDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *musicPriceTextField;

@property (weak, nonatomic) IBOutlet UIButton *musicCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *musicAlbumButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMusicButton;

@property NSArray * musicCategories;
@property NSArray * albums;
@property NSArray <Song *> * downloadedMusic;

@end

@implementation UploadSongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadedMusic = [LocalStorage listOfAllSavedSongs];
    self.musicCategories = @[];
    self.albums = @[];
    
    [self loadDataFromServer];
}


-(void)loadDataFromServer {
    
    [WebAPI getGenereWithCompletionHandler:^(BOOL isError, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    self.musicCategories = @[];
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    return;
                }
            }
            
            self.musicCategories = [((NSDictionary *)responseData) valueForKey:@"category"];
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        
    }];

}

#pragma mark - Add Music

- (IBAction)musicCategoryButtonPressed:(UIButton *)sender {
    
    NSMutableArray * music = [[NSMutableArray alloc]init];
    
    for (NSDictionary * temp in self.musicCategories) {
        [music addObject:temp[@"name"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Category"
                                            rows:music
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           [sender setTitle:selectedValue forState:UIControlStateNormal];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];

}

- (IBAction)musicAlbumButtonPressed:(UIButton *)sender {
}

- (IBAction)selectMusicForAddButtonPressed:(UIButton *)sender {
    
    
    NSMutableArray * items = [[NSMutableArray alloc]init];
    
    for (Song * s in self.downloadedMusic) {
        [items addObject:s.fileName];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Music"
                                            rows:(items.count == 0) ? @[@"Select Music"] : items
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           [sender setTitle:selectedValue forState:UIControlStateNormal];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];

}

- (IBAction)uploadMusicButtonPressed:(UIButton *)sender {
}

#pragma mark - Update Music

- (IBAction)selectMusicForUpdateButtonPressed:(UIButton *)sender {
}

- (IBAction)updateMusic:(UIButton *)sender {
}

#pragma mark - Delete Music

- (IBAction)selectMusicForDeletionButtonPressed:(UIButton *)sender {
}

- (IBAction)deleteMusic:(UIButton *)sender {
}

#pragma mark - base methods

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
