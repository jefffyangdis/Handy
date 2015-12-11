//
//  JAlbumView.m
//  handy
//
//  Created by 方阳 on 15/5/17.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumView.h"
#import "JAlbumCollectionViewCell.h"
#import "JAlbumCollectionViewLayout.h"
#import "JImageScrollView.h"
#import "JImage.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
@interface JAlbumView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JAlbumCollectionViewLayoutDelegate,UIActionSheetDelegate,GLKViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewNavigationBalls;
@property (weak, nonatomic) IBOutlet UICollectionView *viewImageCollection;
@property (strong,nonatomic) IBOutlet GLKView* viewGL;

@end

@implementation JAlbumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
BOOL CheckForExtension(NSString *searchName)
{
    // Create a set containing all extension names.
    // (For better performance, create the set only once and cache it for future use.)
    int max = 0;
    glGetIntegerv(GL_NUM_EXTENSIONS, &max);
    NSMutableSet *extensions = [NSMutableSet set];
    for (int i = 0; i < max; i++) {
        [extensions addObject: @( (char *)glGetStringi(GL_EXTENSIONS, i) )];
    }
    return [extensions containsObject: searchName];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _viewImageCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_viewImageCollection registerClass:[JAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"JAlbumCell"];
    UINib* nib = [UINib nibWithNibName:@"JAlbumCollectionViewCell" bundle:nil];
    [_viewImageCollection registerNib:nib forCellWithReuseIdentifier:@"JAlbumCell"];
    JAlbumCollectionViewLayout* layout = [[JAlbumCollectionViewLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _viewImageCollection.collectionViewLayout = layout;
    layout.layoutDelegate = self;
    _viewImageCollection.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //    [_viewImageCollection addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UILongPressGestureRecognizer* menuRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:menuRecognizer];
    
    
    self.viewGL.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.viewGL.delegate = self;
    self.viewGL.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.viewGL.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    self.viewGL.drawableMultisample = GLKViewDrawableMultisample4X;
    [self.viewGL display];
    CheckForExtension(@"iewo");
}

- (void)createGLProgram
{
    GLuint program = glCreateProgram(),vertShader;
    
//    glUniform1f(glGetUniformLocation(program, "CoolestTemp"), 0.0f);
    
    GLenum error = glGetError();
    
    vertShader = glCreateShader(GL_VERTEX_SHADER);
    const GLchar* source =
    "out vec4 vColor;out float vLightIntensity;void main( ) {const vec3 LIGHTPOS = vec3( 3., 5., 10. );vec3 TransNorm = normalize( uNormalMatrix * aNormal ); vec3 ECposition= ( uModelViewMatrix * aVertex ).xyz; vLightIntensity= dot(normalize(LIGHTPOS - ECposition),TransNorm); vLightIntensity = abs( vLightIntensity );vColor = aColor;gl_Position = uModelViewProjectionMatrix * aVertex;}";
    glShaderSource(vertShader, 1, &source, NULL);
    glCompileShader(vertShader);
    
    GLint status;
    glGetShaderiv(vertShader, GL_COMPILE_STATUS, &status);
    if ( status != GL_TRUE ) {
        GLint logLength;
        glGetShaderiv(vertShader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0)
        {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(vertShader, logLength, &logLength, log);
            [NSString stringWithFormat:@"%s", log];
            
            free(log);
        }
    }
    
    glAttachShader(program, vertShader);
    glUseProgram(program);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    [self createGLProgram];
    glClearColor(0.0, 0.3, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    GLfloat vertex[]={{10,20},{10,30},{20,25}};
//    glEnableVertexAttribArray(<#GLuint index#>)
//    glDrawArrays(GL_LINES, 0, <#GLsizei count#>)
}

- (void)longPress:(UILongPressGestureRecognizer*)sender
{
    if( sender.state == UIGestureRecognizerStateCancelled )
    {
        return;
    }
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructive" otherButtonTitles:@"other", nil];
    [sheet showInView:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged
{
}

- (void)sizeWillChange
{
    [_viewImageCollection.collectionViewLayout invalidateLayout];
    [_viewImageCollection reloadData];
}

#pragma mark - collectionviewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_assets count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAlbumCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JAlbumCell" forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    CGFloat f = representation.scale;
    UIImage* img = [UIImage imageWithCGImage:[representation fullScreenImage]
                                             scale:f
                                       orientation:UIImageOrientationUp];
//    cell.viewImg.image = img;
    [cell.scrollViewImg removeFromSuperview];
    CGSize size = [self collectionView:collectionView layout:nil sizeForItemAtIndexPath:indexPath];
    cell.scrollViewImg = [[JImageScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [cell.scrollViewImg setImage:img];
    [cell.contentView addSubview:cell.scrollViewImg];
    return cell;
}

#pragma mark - uicollectionviewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = _viewImageCollection.bounds.size.height - _viewImageCollection.contentInset.top - _viewImageCollection.contentInset.bottom;
    
    return CGSizeMake(width, height);
}

#pragma mark - JAlbumCollectionViewLayoutDelegate
- (NSInteger)iCurrentIndex
{
    return _iCurrentOffsetIndex;
}

- (void)setICurrentIndex:(NSInteger)index
{
    _iCurrentOffsetIndex = index;
}

#pragma mark - albumview interface
- (void)reloadAlbum
{
    [_viewImageCollection reloadData];
}

#pragma mrak - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        JAlbumCollectionViewCell* cell = (JAlbumCollectionViewCell*)[_viewImageCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_iCurrentOffsetIndex inSection:0]];
        
//        ALAsset *asset = self.assets[_iCurrentOffsetIndex];
//        ALAssetRepresentation* representation = [asset defaultRepresentation];
//        CGFloat f = representation.scale;
        
        CIImage* image = [CIImage imageWithCGImage:[cell.scrollViewImg.image CGImage]];//[CIImage imageWithCGImage:[representation fullScreenImage]];
        EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        CIContext* cContext = [CIContext contextWithEAGLContext:context];
        CIFilter* filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey,image,kCIInputAngleKey, @1,nil];
        CIImage* output = [filter valueForKey:kCIOutputImageKey];
        
        CIFilter *bumpDistortion = [CIFilter filterWithName:@"CIBumpDistortion"];    // 1
        
        [bumpDistortion setDefaults];                                                // 2
        
        [bumpDistortion setValue: output forKey: kCIInputImageKey];
        
        [bumpDistortion setValue: [CIVector vectorWithX:200 Y:150]
         
                          forKey: kCIInputCenterKey];                              // 3
        
        [bumpDistortion setValue: @100.0f forKey: kCIInputRadiusKey];                // 4
        
        [bumpDistortion setValue: @3.0f forKey: kCIInputScaleKey];                  // 5
        
        output = [bumpDistortion valueForKey: kCIOutputImageKey];
        
        CGImageRef oImg = [cContext createCGImage:output fromRect:[output extent]];
        UIImage* rImg = [UIImage imageWithCGImage:oImg];
        if ( cell ) {
            [cell.scrollViewImg setImage:rImg];
        }
        float rgb[3],hsv[3];
        rgb[0]= 1;
        [JImage rgbToHsv:rgb hsv:hsv];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

@end



