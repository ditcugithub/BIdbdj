#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

// Global variables for window and UI elements
NSWindow *floatingWindow;
NSButton *hideShowButton;
NSButton *loadButton;
NSTextField *urlTextField;
WKWebView *webView;
BOOL isWindowVisible = YES;

// Function to toggle window visibility
void toggleWindowVisibility() {
    if (isWindowVisible) {
        [floatingWindow orderOut:nil];
        [hideShowButton setTitle:@"Show"];
        isWindowVisible = NO;
    } else {
        [floatingWindow makeKeyAndOrderFront:nil];
        [hideShowButton setTitle:@"Hide"];
        isWindowVisible = YES;
    }
}

// Function to load the URL from the text field
void loadURL() {
    NSString *urlString = [urlTextField stringValue];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    } else {
        NSLog(@"Invalid URL");
    }
}

// Event handler to allow window dragging
@interface DraggableWindow : NSWindow
@end

@implementation DraggableWindow
- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint initialLocation = [event locationInWindow];
    
    while (true) {
        NSEvent *nextEvent = [self nextEventMatchingMask:(NSEventMaskLeftMouseDragged | NSEventMaskLeftMouseUp)];
        if ([nextEvent type] == NSEventTypeLeftMouseUp) {
            break;
        }
        
        NSPoint currentLocation = [nextEvent locationInWindow];
        NSPoint newOrigin = [self frame].origin;
        newOrigin.x += (currentLocation.x - initialLocation.x);
        newOrigin.y += (currentLocation.y - initialLocation.y);
        
        [self setFrameOrigin:newOrigin];
    }
}
@end

__attribute__((constructor))
void initialize() {
    @autoreleasepool {
        // Create a window frame
        NSRect frame = NSMakeRect(0, 0, 800, 600);
        
        // Create the floating window
        floatingWindow = [[DraggableWindow alloc] initWithContentRect:frame
                                                           styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO];
        [floatingWindow setTitle:@"Floating Browser"];
        [floatingWindow setLevel:NSFloatingWindowLevel];
        
        // Create the WebView (WebKit browser)
        webView = [[WKWebView alloc] initWithFrame:NSMakeRect(0, 50, 800, 550)];
        [floatingWindow.contentView addSubview:webView];
        
        // Create the URL input text field
        urlTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 600, 30)];
        [floatingWindow.contentView addSubview:urlTextField];
        
        // Create the Load button
        loadButton = [[NSButton alloc] initWithFrame:NSMakeRect(620, 10, 80, 30)];
        [loadButton setTitle:@"Load"];
        [loadButton setTarget:[NSApplication sharedApplication]];
        [loadButton setAction:@selector(loadURL)];
        [floatingWindow.contentView addSubview:loadButton];
        
        // Create the Hide/Show button
        hideShowButton = [[NSButton alloc] initWithFrame:NSMakeRect(710, 10, 80, 30)];
        [hideShowButton setTitle:@"Hide"];
        [hideShowButton setTarget:[NSApplication sharedApplication]];
        [hideShowButton setAction:@selector(toggleWindowVisibility)];
        [floatingWindow.contentView addSubview:hideShowButton];
        
        // Make the window key and visible
        [floatingWindow makeKeyAndOrderFront:nil];
    }
}
