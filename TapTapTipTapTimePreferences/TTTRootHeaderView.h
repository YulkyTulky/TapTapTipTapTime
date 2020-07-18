#import <Preferences/PSSpecifier.h>
#import <Preferences/PSHeaderFooterView.h>

@interface TTTRootHeaderView : UITableViewHeaderFooterView <PSHeaderFooterView> {

	UIImageView *_headerImageView;
	CGFloat _currentWidth;
	CGFloat _aspectRatio;

}
@end