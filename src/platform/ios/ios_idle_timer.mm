// iOS-specific helper to enable/disable the idle timer (prevent screen dimming)
#import <UIKit/UIKit.h>

extern "C" void ios_setIdleTimerDisabled(bool disabled)
{
    // Ensure we touch UIKit on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = disabled ? YES : NO;
    });
}
