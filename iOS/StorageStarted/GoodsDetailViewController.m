//
//  GoodsDetailViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initUI {
    self.descriptionTextView.editable = YES;
    self.descriptionTextView.font = [UIFont systemFontOfSize:17.0f];
    self.descriptionTextView.editable = NO;
    
    // 填充商品信息
    self.titleLabel.text = [self.goods objectForKey:@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", [[self.goods objectForKey:@"price"] stringValue]];
    self.descriptionTextView.text = [self.goods objectForKey:@"description"];
    AVUser *user = [self.goods objectForKey:@"owner"];
    self.usernameLabel.text = [NSString stringWithFormat:@"来自：%@", user.username];
    
    // 获取商品图片
    NSString *imageUrl = [self.goods objectForKey:@"imageUrl"];
    
    // 缩略图 Url
    // 图片处理文档：http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html
    NSString *thumbUrl = [NSString stringWithFormat:@"%@?imageView2/2/w/%i", imageUrl, (int) self.imageView.frame.size.width];
    AVFile *file = [AVFile fileWithURL:thumbUrl];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }];
}

@end
