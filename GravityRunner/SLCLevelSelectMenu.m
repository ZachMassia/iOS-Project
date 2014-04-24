//
//  SLCLevelSelect.m
//  GravityRunner
//
//  Created by Student on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCLevelSelectMenu.h"
#import "SLCTextButtonNode.h"
#import "SLCGameScene.h"

@implementation SLCLevelSelectMenu

-(id)initWithSize:(CGSize)size{
    
    if(self = [super initWithSize: size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968627451 alpha:1.0];
        
        //create background frame
        SKSpriteNode *bgFrame = [self frameWithSize:CGSizeMake(self.size.width * 0.6,
                                                               self.size.height * 0.6)];
        
        //bgFrame.alpha = 0.5;
        [self addChild:bgFrame];
        
        //Create the label
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        titleLabel.fontSize = 55;
        titleLabel.fontColor = [SKColor blackColor];
        titleLabel.text = @"Level Select";
        titleLabel.position = CGPointMake(0,125);
        [self addChild:titleLabel];
        
        __unsafe_unretained typeof(self) weakSelf = self;

        for(NSUInteger i = 1; i <= 4; i++) {
        
            //create the level select button
            SLCTextButtonNode *button = [[SLCTextButtonNode alloc] initWithImageNamed:@"green_button08"
                                                                                 size:CGSizeMake(bgFrame.size.width  * 0.27,
                                                                                                 bgFrame.size.height * 0.27)
                                                                                 text:[NSString stringWithFormat:@"%i", i]];

            if ([[SLCDataManager sharedInstance].data[@"current-level"] integerValue] >= i || i == 1) {
                button.alpha = 1;
            } else {
                button.alpha = 0.4;
            }


            NSUInteger offset = 35;
            switch (i)
            {
                case 1:
                    button.position = CGPointMake(((bgFrame.size.width / 4) * -1) + offset, 25);
                    break;
                case 2:
                    button.position = CGPointMake((bgFrame.size.width / 4) - offset, 25);
                    break;
                case 3:
                    button.position = CGPointMake(((bgFrame.size.width / 4) * -1) + offset, -125);
                    break;
                case 4:
                    button.position = CGPointMake((bgFrame.size.width / 4) - offset, -125);
                    break;
            }

            button.onTouch = ^{

                SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1];

                SKScene *scene = [[SLCGameScene alloc] initWithSize:weakSelf.scene.size level:i];
                scene.scaleMode = SKSceneScaleModeAspectFill;

                [scene runAction:[SKAction playSoundFileNamed:@"button-fwd.caf" waitForCompletion:NO]];
                
                // Present the scene.
                [weakSelf.view presentScene:scene transition:transition];
            };
            
            [self addChild:button];
        }
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
