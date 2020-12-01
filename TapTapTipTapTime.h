#import <UIKit/UIKit.h>

//--Preferences Variables--//
BOOL enabled;

BOOL showAMPM;
BOOL twentyFourHourTime;

NSString *separator;
BOOL showYear;
BOOL dayBeforeMonth;

BOOL autoResetEnabled;

//--Globally Accessible Variables--//
static BOOL dateShowing;
static NSString *notificationName = @"com.yulkytulky.taptaptiptaptime/changedateshowing";
static NSTimer *timer;

//--Interface Declarations--//
@interface _UIStatusBarStringView: UILabel
@end

@interface _UIStatusBarTimeItem
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *timeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *shortTimeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *pillTimeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *dateView;
@end

@interface DimitarStatusBarTimeStringView : _UIStatusBarStringView
@end
