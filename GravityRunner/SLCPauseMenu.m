//
//  SLCPauseScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCPauseMenu.h"
#import "SLCButtonNode.h"

@interface SLCPauseMenu()

@property (assign, nonatomic, readwrite) BOOL isVisible;

@property (strong, nonatomic) SLCButtonNode *resumeBtn;
@property (strong, nonatomic) SLCButtonNode *quitBtn;

@end

@implementation SLCPauseMenu

-(id)initWithParentNode:(SKNode *)parent {
    if (self = [super init]) {
        self.isVisible = NO;
        self.uiElementsToHide = [NSMutableArray array];

        // Create the background frame.
        SKSpriteNode *bgFrame = [self frameWithSize:CGSizeMake(parent.scene.size.width * 0.35,
                                                               parent.scene.size.height * 0.40)];
        [self addChild:bgFrame];

        // Create the label.
        SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        pauseLabel.fontSize = 40;
        pauseLabel.fontColor = [SKColor blackColor];
        pauseLabel.text = @"Game Paused";
        pauseLabel.position = CGPointMake(0, 75);
        [self addChild:pauseLabel];


        // Create a weak reference to self to avoid a retain cycle compiler warning.
        // Used for the button OnClick blocks.
        __unsafe_unretained typeof(self) weakSelf = self;


        // Create the resume button.
        self.resumeBtn = [[SLCButtonNode alloc] initWithImageNamed:@"green_button08"
                                                              size:CGSizeMake(bgFrame.size.width  * 0.45,
                                                                              bgFrame.size.height * 0.18)
                                                              text:@"Resume"];
        self.resumeBtn.position = CGPointMake(65, -75);
        self.resumeBtn.touchSound = @"button-fwd.caf";
        self.resumeBtn.onTouch = ^{
            [weakSelf hideWithFadeDuration:0.25];
        };

        // Create the quit button.
        self.quitBtn = [[SLCButtonNode alloc] initWithImageNamed:@"red_button08"
                                                            size:CGSizeMake(bgFrame.size.width  * 0.30,
                                                                             bgFrame.size.height * 0.18)
                                                            text:@"Quit"];
        self.quitBtn.position = CGPointMake(-95, -75);
        self.quitBtn.touchSound = @"button-fwd.caf";
        self.quitBtn.onTouch = ^{
            // TODO: This should quit to level select.
            [weakSelf hideWithFadeDuration:0.25];
        };

        // Add the buttons to the menu.
        [self addChild:self.resumeBtn];
        [self addChild:self.quitBtn];
    }
    return self;
}

- (void)hideWithFadeDuration:(NSTimeInterval)sec {
    for (SKNode *uiElement in self.uiElementsToHide) {
        [uiElement runAction:[SKAction fadeInWithDuration:sec]];
    }

    // To avoid restarting gameplay before the menu is fully hidden, set the
    // isVisible property in the completion block.
    [self runAction:[SKAction fadeOutWithDuration:sec] completion:^{ self.isVisible = NO; }];
}

- (void)showWithFadeDuration:(NSTimeInterval)sec {
    self.isVisible = YES;

    for (SKNode *uiElement in self.uiElementsToHide) {
        [uiElement runAction:[SKAction fadeOutWithDuration:sec]];
    }

    [self runAction:[SKAction fadeInWithDuration:sec]];
}

/**
 *  Creates a background frame of the given size.
 *
 *  @param size The frame size.
 *
 *  @return The initialized frame node.
 */
- (SKSpriteNode *)frameWithSize:(CGSize)size {
    SKSpriteNode *frame = [SKSpriteNode spriteNodeWithImageNamed:@"grey_panel"];

    frame.xScale = size.width  / frame.size.width;
    frame.yScale = size.height / frame.size.height;

    return frame;
}

@end
