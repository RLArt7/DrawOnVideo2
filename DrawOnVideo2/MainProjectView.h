//
//  MainProjectView.h
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
#import "PSPushPopPressView.h"


//#import "ViewController.h"


@interface MainProjectView : UIViewController <PSPushPopPressViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UIScrollView *scroller;
    NSURL *videoUrl;
    NSURL *videoUrl2;
    UIViewController *viewController;
    
    
    MPMoviePlayerController *player;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    NSMutableArray *drawArray;
    UIImage *thumbnail;
    
    NSUInteger *activeCount_;
    
    
    
    PSPushPopPressView *pushPopPressView_;
    PSPushPopPressView *pushPopPressVideoView_;

}
- (IBAction)addVideo:(id)sender;
- (IBAction)pauseVideo:(id)sender;
- (IBAction)undoButton:(id)sender;
- (IBAction)resetButton:(id)sender;
//-(IBAction)onTimeSliderChange:(UISlider *)sender;
//- (IBAction)newVideo:(id)sender;
- (IBAction)save:(id)sender;

@property (nonatomic, retain) UIViewController *viewController;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property MPMoviePlayerController *player;

@property BOOL newVid;
@property NSURL  *videoUrl;
@property NSURL  *videoUrl2;
//@property NSString *moviePath;

//- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
//                               usingDelegate: (id <UIImagePickerControllerDelegate,
//                                               UINavigationControllerDelegate>) delegate;


@end
