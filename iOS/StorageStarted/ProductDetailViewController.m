//
//  ProductDetailViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupUI {
    self.descriptionTextView.editable = YES;
    self.descriptionTextView.font = [UIFont systemFontOfSize:17.0f];
    self.descriptionTextView.editable = NO;
    
    // 填充商品信息
    self.titleLabel.text = [self.product objectForKey:@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", [[self.product objectForKey:@"price"] stringValue]];
    self.descriptionTextView.text = [self.product objectForKey:@"description"];
    AVUser *user = [self.product objectForKey:@"owner"];
    self.usernameLabel.text = [NSString stringWithFormat:@"来自：%@", user.username];
    
    // 获取商品图片
    AVFile *file = [self.product objectForKey:@"image"];
    
    // 由于 LeanCloud 国内节点上传到了七牛，此处可以使用七牛的图片处理
    // 图片处理文档：http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html
    NSString *thumbUrl = [NSString stringWithFormat:@"%@?imageView2/2/w/%i", file.url, (int) self.imageView.frame.size.width];
    AVFile *thumbfile = [AVFile fileWithURL:thumbUrl];
    [thumbfile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }];
}

@end
