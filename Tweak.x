#import "TapTapTipTapTime.h"

static NSString *dateStringFactory() {

	NSMutableString *format = [NSMutableString stringWithString:@""];
	if (dateShowing) {
		dayBeforeMonth ? [format appendString:@"d M"] : [format appendString:@"M d"];
		if (showYear) [format appendString:@" Y"];
		[format replaceOccurrencesOfString:@" " withString:separator options:NSLiteralSearch range:NSMakeRange(0, [format length])];
	} else {
		twentyFourHourTime ? [format appendString:@"H:mm"] : [format appendString:@"h:mm"];
		if (showAMPM) [format appendString:@" a"];
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	return [formatter stringFromDate:[NSDate date]];
	
}

@implementation DimitarStatusBarTimeStringView

- (void)didMoveToWindow {

	[super didMoveToWindow];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTapTipTapTimeGestureRecognizerDidFire)];
	[self setUserInteractionEnabled:YES];
	[self addGestureRecognizer:tapGestureRecognizer];

}

- (void)setText:(NSString *)text {

	[super setText:dateStringFactory()];

}

- (void)tapTapTipTapTimeGestureRecognizerDidFire {

	dateShowing = !dateShowing; // Toggle
	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.taptaptiptaptime.plist"];
	[preferences setObject:[NSNumber numberWithBool:dateShowing] forKey:@"_dateShowing"];

	NSDictionary *userInfo = @{ @"dateShowing": [NSNumber numberWithBool:dateShowing] };
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
	[preferences writeToFile:@"/var/mobile/Library/Preferences/com.yulkytulky.taptaptiptaptime.plist" atomically:YES];

}

@end

%hook _UIStatusBarTimeItem

- (void)_create_timeView {

	%orig;

	_UIStatusBarStringView *view = [self timeView];
	object_setClass(view, [DimitarStatusBarTimeStringView class]);
	[view setText:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeDateShowing:) name:notificationName object:nil];

}

- (void)_create_shortTimeView {

	%orig;

	_UIStatusBarStringView *view = [self shortTimeView];
	object_setClass(view, [DimitarStatusBarTimeStringView class]);
	[view setText:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeDateShowing:) name:notificationName object:nil];

}

%new
- (void)handleChangeDateShowing:(NSNotification *)notification {

	dateShowing = [[[notification userInfo] valueForKey:@"dateShowing"] boolValue];
	[[self timeView] setText:nil];
	[[self shortTimeView] setText:nil];

}

%end

static void loadPrefs() {

	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.taptaptiptaptime.plist"];

	enabled = [preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : YES; // Default: Enabled

	showAMPM = [preferences objectForKey:@"showAMPM"] ? [[preferences objectForKey:@"showAMPM"] boolValue] : YES;
	twentyFourHourTime = [preferences objectForKey:@"twentyFourHourTime"] ? [[preferences objectForKey:@"twentyFourHourTime"] boolValue] : NO;

	separator = [preferences objectForKey:@"separator"] ? [preferences objectForKey:@"separator"] : @"/";
	showYear = [preferences objectForKey:@"showYear"] ? [[preferences objectForKey:@"showYear"] boolValue] : YES;
	dayBeforeMonth = [preferences objectForKey:@"dayBeforeMonth"] ? [[preferences objectForKey:@"dayBeforeMonth"] boolValue] : NO;

	NSDictionary *userInfo = @{ @"dateShowing": [NSNumber numberWithBool:dateShowing] };
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];

}

%ctor {

	loadPrefs(); // Load preferences into variables
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.yulkytulky.taptaptiptaptime/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce); // Listen for preference changes

	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.taptaptiptaptime.plist"];
	dateShowing = [preferences objectForKey:@"_dateShowing"] ? [[preferences objectForKey:@"_dateShowing"] boolValue] : NO;

	if (enabled) {
		%init;
	}

}