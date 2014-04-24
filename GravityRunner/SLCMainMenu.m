//
//  SLCMainMenu.m
//  GravityRunner
//
//  Created by Student on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCMainMenu.h"
#import "SLCTextButtonNode.h"
#import "SLCGameScene.h"
#import "SLCLevelSelectMenu.h"

@implementation SLCMainMenu
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize: size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968627451 alpha:1.0];
        
        // Create the background frame.
        SKSpriteNode *bgFrame = [self frameWithSize:CGSizeMake(self.size.width * 0.5,
                                                               self.size.height * 0.4)];
        bgFrame.alpha = 0.5;
        [self addChild:bgFrame];
        
        
        // Create the label.
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        titleLabel.fontSize = 60;
        titleLabel.fontColor = [SKColor blackColor];
        titleLabel.text = @"Gravity Runner";
        titleLabel.position = CGPointMake(0, 175);
        [self addChild:titleLabel];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        //create the level select button
        SLCTextButtonNode *lvlSelectBtn = [[SLCTextButtonNode alloc] initWithImageNamed:@"green_button08"
                                                                  size:CGSizeMake(bgFrame.size.width  * 0.8,
                                                                                  bgFrame.size.height * 0.25)
                                                                  text:@"Level Select"];
        lvlSelectBtn.position = CGPointMake(0, 80);
        lvlSelectBtn.onTouch = ^{
            SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1];

            SKScene *scene = [[SLCLevelSelectMenu alloc] initWithSize:weakSelf.scene.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;

            [scene runAction:[SKAction playSoundFileNamed:@"button-fwd.caf" waitForCompletion:NO]];

            // Present the scene.
            [weakSelf.view presentScene:scene transition:transition];
        };
        
        //create the Credits button
        SLCTextButtonNode *creditsBtn = [[SLCTextButtonNode alloc] initWithImageNamed:@"green_button08"
                                                                                   size:CGSizeMake(bgFrame.size.width  * 0.8,
                                                                                                   bgFrame.size.height * 0.2)
                                                                                   text:@"Credits"];
        creditsBtn.position = CGPointMake(0, -10);
        creditsBtn.onTouch = ^{
            
        };
        
        // Create the quit button.
        SLCTextButtonNode *quitBtn = [[SLCTextButtonNode alloc] initWithImageNamed:@"red_button08"
                                                                size:CGSizeMake(bgFrame.size.width  * 0.8,
                                                                                bgFrame.size.height * 0.2)
                                                                text:@"Quit"];
        quitBtn.position = CGPointMake(0, -80);
        quitBtn.touchSound = @"button-fwd.caf";
        quitBtn.onTouch = ^{
            
        };
        [self addChild:lvlSelectBtn];
        [self addChild:creditsBtn];
        [self addChild:quitBtn];
    }
    return self;
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
