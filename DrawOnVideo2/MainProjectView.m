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



@interface MainProjectView (){
    id _timeObserver;

}


@end

@implementation MainProjectView
@synthesize videoView;
@synthesize drawView;
@synthesize tempDrawImage;
@synthesize newVid;
@synthesize videoUrl;
@synthesize videoUrl2;
@synthesize player;
@synthesize thumbnailScrollView;
//@synthesize moviePath;
//@synthesize currentTime;
//@synthesize timeView;

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieDurationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    
    
    
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
    
    
    
}


- (IBAction)addVideo:(id)sender{

    ///S TESTING
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath =
    [bundle
     pathForResource:@"BigBuckBunny_640x360"
     ofType:@"m4v"];
    
    videoUrl=[NSURL fileURLWithPath:moviePath];
    ///E TESTING
    
    
    player = [[MPMoviePlayerController alloc] init];
    player.contentURL=videoUrl;
    
    thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [player setMovieSourceType:MPMovieSourceTypeFile];
    [player.view setFrame:self.videoView.bounds];
    
    [self.videoView addSubview:player.view];
    
    
       
//    player.controlStyle = MPMovieControlStyleFullscreen;
    player.controlStyle = MPMovieControlStyleNone;

//        [player play:self];
    [player prepareToPlay];
    
    [player play];
    
    
}
- (void) movieDurationAvailable:(NSNotification*)notification {
	float duration = [self.player duration];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playerThumbnailImageRequestDidFinish:)
	 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
	 object:nil];
	
	NSMutableArray *times = [[NSMutableArray alloc] init];
    [times addObject:[NSNumber numberWithInt:1.0]];
	for(int i = 1; i < 20; i++) {
		float playbackTime = i * duration/20;
		NSLog(@"playbackTime %f", playbackTime);
		[times addObject:[NSNumber numberWithInt:playbackTime]];
	}
	[self.player requestThumbnailImagesAtTimes:times timeOption: MPMovieTimeOptionExact];
	
    
}

-(void)playerThumbnailImageRequestDidFinish:(NSNotification*)notification {
    NSDictionary *userInfo=[notification userInfo];
    
    NSError* value = [userInfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    NSNumber *timecode;
    UIImage *image;
    
    
    if(value != nil){
        NSLog(@"Error: %@", [value debugDescription]);
    }else{
        timecode = [userInfo objectForKey: MPMoviePlayerThumbnailTimeKey];
        image =[userInfo objectForKey: MPMoviePlayerThumbnailImageKey];
        NSLog(@"What?? width");
    }
    
    ImageViewWithTime *imageView = [self makeThumbnailImageViewFromImage:image andTimeCode:timecode];
    
    
    [thumbnailScrollView addSubview:imageView];
    
//    UITapGestureRecognizer *tapRecognizer =
//    [[UITapGestureRecognizer alloc]
//     initWithTarget:self action:@selector(handleTapFrom:)];
//	[tapRecognizer setNumberOfTapsRequired:1];
//	
//	[imageView addGestureRecognizer:tapRecognizer];
    
}

- (ImageViewWithTime *)makeThumbnailImageViewFromImage:(UIImage *)image andTimeCode:(NSNumber *)timecode {
	float timeslice = self.player.duration / 20.0;
	float pos = [timecode intValue] / (int)timeslice;

	float width = 50 * ((float)image.size.width / (float)image.size.height);
    
	self.thumbnailScrollView.contentSize = CGSizeMake((width + 2) * 100, 50);
//
	ImageViewWithTime *imageView =
	[[ImageViewWithTime alloc] initWithImage:image];
	[imageView setUserInteractionEnabled:YES];
//    [imageView setFrame:CGRectMake(0, 0, 20, 20.0)];
	[imageView setFrame:CGRectMake(pos * 20 + 2,0,20,50)];
    
	imageView.time = [[NSNumber alloc] initWithFloat:(pos * timeslice)];
	return imageView;
}
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	ImageViewWithTime *imageView = (ImageViewWithTime *)recognizer.self.view;
	self.player.currentPlaybackTime = [imageView.time floatValue];
}





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
        myButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        myButton.frame = CGRectMake(276, 25, 73, 71); // position in the parent view and set the size of the button
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


@end
