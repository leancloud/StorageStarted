//
//  NewProductViewController.h
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import <UIKit/UIKit.h>

@interface NewProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSString *name;
@end
