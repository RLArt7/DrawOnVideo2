//
//  MainProjectView.m
//  DrawOnVideo
//
//  Created by Harel Avikasis on 02/04/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import "MainProjectView.h"
#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>



@interface MainProjectView ()


@end

@implementation MainProjectView
@synthesize videoView;
@synthesize drawView;
@synthesize tempDrawImage;
@synthesize newVid;
@synthesize videoUrl;
@synthesize videoUrl2;
@synthesize player;
//@synthesize moviePath;

@synthesize viewController;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
//    videoUrl=nil;
    [scroller setScrollEnabled:YES];
//    [scroller ]
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    brush = 10.0;
    opacity = 1.0;
    drawArray =[[NSMutableArray alloc]init];
    thumbnail=NULL;
    
//    CGRect firstRect = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? CGRectMake(140, 40, 500, 400) : CGRectMake(0, 0, 500, 242);
//    pushPopPressView_ = [[PSPushPopPressView alloc] initWithFrame:firstRect];
//    pushPopPressView_.pushPopPressViewDelegate = self;
//    [pushPopPressVideoView_ setBackgroundColor:NULL];
//    [self.view addSubview:pushPopPressView_];
//    
    
    
//    UITapGestureRecognizer *tapTwice=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTwice:)];
//    tapTwice.numberOfTapsRequired=2;
//    [self.view addGestureRecognizer:tapTwice];
    [scroller setContentSize:CGSizeMake(66, 242)];
    
    
	// Do any additional setup after loading the view.
}
//-(void) tapTwice(UITapGestureRecognizer*)gesture{
//    [self.videoView zoomToRect:rectToZoomInTo animated:NO];
//}

- (void)viewWillAppear:(BOOL)animated
{
    videoUrl=videoUrl2;

}
- (void)viewDidLayoutSubviews
{
//    [super viewDidLayoutSubViews];
    [scroller setContentSize:CGSizeMake(70, 400)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
    if(count==1){
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
//    [redoArray removeAllObjects];
    UIGraphicsBeginImageContext(self.drawView.frame.size);
    [self.drawView.image drawInRect:CGRectMake(0, 0, self.drawView.frame.size.width, self.drawView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.drawView.image = UIGraphicsGetImageFromCurrentImageContext();
    [drawArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
    //    NSLog(@"hey im here %i array:%@",[drawArray count],drawArray);
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    [self drawView];
//     [pushPopPressView_ addSubview:drawView];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ViewController *vcDelegate =(ViewController *)segue.destinationViewController;
//    vcDelegate.myDelegate = self;
//    vcDelegate.videoUrl=videoUrl;
//    
//}
- (IBAction)addVideo:(id)sender{
//    NSString *moviePath = [[NSBundle mainBundle]pathForResource:@"IMG_1990" ofType:@"mov"];
//    videoUrl=[NSURL fileURLWithPath:moviePath];
//    NSLog(@"MainProject: %@",videoUrl2);
    
    
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
//    NSLog(@"the path:%@",videoUrl);
    thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [player setMovieSourceType:MPMovieSourceTypeFile];
    [player.view setFrame:self.videoView.bounds];
    
    [self.videoView addSubview:player.view];
    
    player.controlStyle = MPMovieControlStyleNone;
//        [player play:self];
    [player prepareToPlay];
    
    [player play];
    
    
}
//-(IBAction)sliding:(id)sender{
//    CMTime newTime= CMTimeMakeWithSeconds(seeker.value,1);
//    [self.player seekToTime:newTime];
//}
//-(void)setSlider{
//    sliderTime =[[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo: repeats:<#(BOOL)#>];
//    
//}

//- (void) monitorPlaybackTime
//{
//    self.progressIndicator.value = self.mpMoviePlayerController.currentPlaybackTime / self.totalVideoTime;
//    //constantly keep checking if at the end of video:
//    if (self.totalVideoTime != 0 && videoPlayer.currentPlaybackTime >= totalVideoTime - 0.1)
//    {
//        //-------- rewind code:
//        self.mpMoviePlayerController.currentPlaybackTime = 0;
//        [self.mpMoviePlayerController pause];
//    }
//    else
//    {
//        [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:kVideoPlaybackUpdateTime];
//    }
//}
//-(IBAction)onTimeSliderChange:(UISlider *)sender{
//    self.mpMoviePlayerController.currentPlaybackTime=totalVideoTime*timeLineSlider.value;
//    [self monitorPlaybackTime];
//}


- (IBAction)pauseVideo:(id)sender {
    [player pause];
}

- (IBAction)undoButton:(id)sender {
    //    NSLog(@"hey im here 1 %i",[drawArray count]);
    
    if([drawArray count]==0 ){
        return;
    }else{
        //        NSLog(@"hey im here %i",[drawArray count]);
//        [redoArray addObject:[drawArray lastObject]];
        [drawArray removeLastObject];
        UIGraphicsBeginImageContext(self.drawView.frame.size);
        [self.drawView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.drawView.image = [drawArray lastObject];
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
        
        [self drawView];
    }
}

- (IBAction)resetButton:(id)sender {
     self.drawView.image = nil;
//    self.videoView=nil;
}

//- (IBAction)newVideo:(id)sender {
//    UIActionSheet *actionSheet2 = [[UIActionSheet alloc] initWithTitle:@""
//                                                              delegate:self
//                                                     cancelButtonTitle:nil
//                                                destructiveButtonTitle:nil
//                                                     otherButtonTitles:@"Capture Video", @"Choose Existing", @"Cancel", nil];
//    actionSheet2.tag=21;
//    [actionSheet2 showInView:self.view];
//}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 21) {
//        if (buttonIndex == 0){
//            newVid=YES;
//            [self startCameraControllerFromViewController:self usingDelegate:self];
//        }
//        if (buttonIndex == 1){
//            newVid=NO;
//            if ([UIImagePickerController isSourceTypeAvailable:
//                 UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
//                [alert show];
//            }else{
////                isSelectingAssetOne = TRUE;
//                [self startMediaBrowserFromViewController: self
//                                            usingDelegate: self];
//            }
//
//            
//        }
//    }
//}
//- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
//                               usingDelegate: (id <UIImagePickerControllerDelegate,
//                                               UINavigationControllerDelegate>) delegate {
//    if (([UIImagePickerController isSourceTypeAvailable:
//          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
//        || (delegate == nil)
//        || (controller == nil))
//        return NO;
//    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
//    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//    
//    // Hides the controls for moving & scaling pictures, or for
//    // trimming movies. To instead show the controls, use YES.
//    mediaUI.allowsEditing = YES;
//    
//    mediaUI.delegate = delegate;
//    
//    //    [controller presentModalViewController: mediaUI animated: YES];
//    [controller  presentViewController:mediaUI animated:YES completion:nil];
//    return YES;
//}
//#pragma Capture Vid
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////Captrure VID///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//
//
//-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
//                                 usingDelegate:(id )delegate {
//    // 1 - Validattions
//    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
//        || (delegate == nil)
//        || (controller == nil)) {
//        return NO;
//    }
//    // 2 - Get image picker
//    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
//    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
//    // Displays a control that allows the user to choose movie capture
//    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//    // Hides the controls for moving & scaling pictures, or for
//    // trimming movies. To instead show the controls, use YES.
//    cameraUI.allowsEditing = NO;
//    cameraUI.delegate = delegate;
//    // 3 - Display image picker
//    [controller presentViewController:cameraUI animated:YES completion:nil];
//    return YES;
//}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    [self dismissViewControllerAnimated:NO completion:nil];
//    //    [self dismissModalViewControllerAnimated:NO];
//    // Handle a movie capture
//    if(newVid){
//        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
//            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//            videoUrl=[NSURL fileURLWithPath:moviePath];
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
//                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
//                                                    @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//        }
//        
//    }
//    // For responding to the user accepting a newly-captured picture or movie
//    else{
//        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//        
//        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
//            == kCFCompareEqualTo)
//        {
//            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//            videoUrl=[NSURL fileURLWithPath:moviePath];
//            
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (mediaType)) {
//                UISaveVideoAtPathToSavedPhotosAlbum (mediaType, nil, nil, nil);
//            }
//        }
//        
//        
////        [self dismissViewControllerAnimated:YES completion:nil];
//        
//        
//        //        [picker release];
//    }
//}
//
/////Change that to TOast!
//-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Library"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//}







- (IBAction)save:(id)sender {
    
//    create button in the ViewController
    //create Instanse of ViewController
    
    [player pause];
    MainProjectView *view = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"ViewController"];
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.viewController=view;
    //need to edit that to screenShot of the screen
    UIImage * defaultImage = [UIImage imageNamed:@"pictures.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UILabel *myLabel=[[UILabel alloc] initWithFrame:CGRectMake(289,116,72,21)];
    UITextField *myTextFiled=[[UITextField alloc] initWithFrame:CGRectMake(262,104,100,21)];
    [myTextFiled setTextColor:[UIColor blackColor]];
    [myTextFiled setTextAlignment:NSTextAlignmentCenter];
    [myTextFiled setBackgroundColor:[UIColor clearColor]];
    [myTextFiled setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0]];
    myTextFiled.text=@"Untiteld2";
//    myTextFiled.text=moviePathddsdd;
    [myTextFiled addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
//    myTextFiled.enabled;

    
    myButton.frame = CGRectMake(276, 25, 73, 71); // position in the parent view and set the size of the button
    if(thumbnail!=NULL){
        [myButton setImage:thumbnail forState:UIControlStateNormal];
    }else{
        [myButton setImage:defaultImage forState:UIControlStateNormal];
    }
    // add targets and actions
    [myButton addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    
    MainProjectView *saveWindow;
    saveWindow.videoUrl=self.videoUrl;
    saveWindow.videoView=self.videoView;
    saveWindow.drawView=self.drawView;
    saveWindow.viewController=self.viewController;
    NSUserDefaults *userData =[NSUserDefaults standardUserDefaults];
    [userData setObject:saveWindow forKey:@"userDate"];
    [self.viewController.view addSubview:myTextFiled];
    [self.viewController.view addSubview:myButton];
    
     [self presentViewController:view animated:YES completion:nil];
    
}
-(IBAction)loadData:(id)sender{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"work" message:@"ThatSUCKS!!!" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//    [alert show];
    NSUserDefaults *userData =[NSUserDefaults standardUserDefaults];
    MainProjectView *loadWindow=[userData objectForKey:@"userData"];
//    ViewController *loadWin;
    loadWindow=[userData objectForKey:@"userData"];
//    loadWindow.viewController=[self.storyboard
//                               instantiateViewControllerWithIdentifier:@"MainProjectView"];
//    ViewController *view=loadWindow.viewController;
    MainProjectView *view=[self.storyboard
                          instantiateViewControllerWithIdentifier:@"ViewController"];
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:view animated:YES completion:nil];

}
//-(IBAction)testMethod:(id)sender{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"work" message:@"work" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//    [alert show];
//}

@end
