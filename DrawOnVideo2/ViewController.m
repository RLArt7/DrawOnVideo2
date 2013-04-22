//
//  ViewController.m
//  DrawOnVideo2
//
//  Created by Harel Avikasis on 02/04/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import "ViewController.h"
//#import "AppDelegateProtocol.h"
//#import "AppDataObject.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize newVid;
//@synthesize myDelegate;
@synthesize videoUrl;
@synthesize videoUrl2;


//- (AppDataObject*) theAppDataObject;
//{
//	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
//	AppDataObject* theDataObject;
//	theDataObject = (AppDataObject*) theDelegate.theAppDataObject;
//	return theDataObject;
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [scroller setScrollEnabled:YES];
//    [scroller setContentSize:CGSizeMake(568, 500)];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didFinishLaunchingWithOptions
{
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/myMovie.m4v"]];
//    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}


- (IBAction)newProject:(id)sender {
    UIActionSheet *actionSheet2 = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Capture Video", @"Choose Existing", @"Cancel", nil];
    actionSheet2.tag=21;
    [actionSheet2 showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 21) {
        if (buttonIndex == 0){
            newVid=YES;
            [self startCameraControllerFromViewController:self usingDelegate:self];
        }
        if (buttonIndex == 1){
            newVid=NO;
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            
            
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//            AppDataObject* theDataObject = [self theAppDataObject];
//            theDataObject.videoUrl = videoUrl;
            //            NSString *moviePath = [[NSBundle mainBundle]pathForResource:@"IMG_1990" ofType:@"MOV"];
            //            videoUrl=[NSURL fileURLWithPath:moviePath];
            
            
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            //            [self.delegate addVideo:self];
            
        }
    }
}

#pragma Capture Vid
////////////////////////////////////////////////////////////////////////////////
/////////////////////////Captrure VID///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    // 1 - Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}
- (void)textFieldDidEndEditing:(NSURL *)info
{
//	AppDataObject* theDataObject = [self theAppDataObject];
//	theDataObject.videoUrl = videoUrl;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:nil];
    //    [self dismissModalViewControllerAnimated:NO];
    // Handle a movie capture
    if(newVid){
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                    @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
        
    }
    // For responding to the user accepting a newly-captured picture or movie
    else{
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo)
        {
            
            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
            videoUrl=[NSURL fileURLWithPath:moviePath];
            //            AppDataObject* theDataObject = [self theAppDataObject];
            //            theDataObject.videoUrl = videoUrl;
            NSLog(@"view controller: %@",videoUrl);
            
        }
        
        ViewController *view = [self.storyboard
                                instantiateViewControllerWithIdentifier:@"MainProjectView"];
        view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //    NSLog(@"VIEW LOOOOOOOOKKKKKEEEE HEEREEEE: %@",view);
        
        [self presentViewController:view animated:YES completion:nil];
        
        //        [self performSegueWithIdentifier:@"mySegue" sender:sender];
        //        [self dismissViewControllerAnimated:YES completion:nil];
        //        [self ]
        
        
        //        [picker release];
    }
}

///Change that to TOast!
-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Library"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma VID from Library
////////////////////////////////////////////////////////////////////////////////
/////////////////////////VID FROM LIBRARY///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    //    [controller presentModalViewController: mediaUI animated: YES];
    [controller  presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
    
}
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    //    [self dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];
    // Release the movie instance created in playMovieAtURL:
}



@end
