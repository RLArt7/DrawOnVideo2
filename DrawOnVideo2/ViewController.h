//
//  ViewController.h
//  DrawOnVideo
//
//  Created by Harel Avikasis on 02/04/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "MainProjectView.h"




//
@protocol ViewControllerDelegate <NSObject>//,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


- (IBAction)addVideo:(id)sender;
@end
//@class MainProjectView;

@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL newMedia;
    IBOutlet UIScrollView *scroller;
    MainProjectView *mainProjectView;
    
    
    
}
//- (IBAction)blablatest:(id)sender;

- (IBAction)newProject:(id)sender;
//- (IBAction)addVideo:(id)sender;


-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;
// For opening UIImagePickerController
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;
@property BOOL newVid;
//@property (nonatomic, weak) id<ViewControllerDelegate> myDelegate;

@property NSURL *videoUrl;
@property NSURL *videoUrl2;
@property (nonatomic, retain) MainProjectView *mainProjectView;




@end
