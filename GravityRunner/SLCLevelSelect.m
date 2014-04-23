//
//  SLCLevelSelect.m
//  GravityRunner
//
//  Created by Student on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCLevelSelect.h"

@implementation SLCLevelSelect

-(id)initWithsize:(CGSize)size{
    
    if(self = [super initWithSize: size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968262741 alpha:1.0];
        
        //create background frame
        SKSpriteNode *bgFrame = [self frameWithSize:CGSizeMake(self.size.width * 0.4,
                                                               self.size.height * 0.6)];
        
        bgFrame.alpha = 0.5;
        [self addChild:bgFrame];
        
        //Create the label
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        titleLabel.fontSize = 40;
        titleLabel.fontColor = [SKColor blackColor];
        titleLabel.text = @"Level Select";
        titleLabel.position = CGPointMake(0,100);
        [self addChild:titleLabel];
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
