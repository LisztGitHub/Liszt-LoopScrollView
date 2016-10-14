//
//  ViewController.m
//  LoopScrollView
//
//  Created by Liszt on 16/10/14.
//  Copyright © 2016年 https://github.com/LisztGitHub. All rights reserved.
//

#import "ViewController.h"
#import "LoopScrollView.h"

@interface ViewController ()<LoopScrollViewDelegate,LoopScrollViewDataSource>{
    NSArray *images;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) LoopScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    images = @[[[NSBundle mainBundle] pathForResource:@"img0.jpg" ofType:nil],[[NSBundle mainBundle] pathForResource:@"img1.jpg" ofType:nil],[[NSBundle mainBundle] pathForResource:@"img2.jpg" ofType:nil],[[NSBundle mainBundle] pathForResource:@"img3.jpg" ofType:nil]];
    [self.view addSubview:self.scrollView];
    
    
    self.titleLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.titleLabel.layer.shadowOpacity = 0.9f;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.titleLabel.layer.shadowRadius = 2.0f;
    
    self.textView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.shadowOpacity = 0.9f;
    self.textView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.textView.layer.shadowRadius = 2.0f;
}
- (IBAction)buttonAction:(id)sender {
    NSInteger count = arc4random_uniform(4);
    
    NSMutableArray *tempData = [[NSMutableArray alloc]initWithCapacity:0];
    for(NSInteger i = 0;i< count; i ++){
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img%li.jpg",i] ofType:nil];
        [tempData addObject:path];
    }
    
    images = [tempData copy];
    
    if(images.count){
        [self.scrollView reloadData];
    }
}

#pragma mark - <LoopScrollViewDelegate><LoopScrollViewDataSource>
-(NSArray *)scrollViewItemDatasInLoopScrollView:(LoopScrollView *)scrollView{
    return images;
}
-(UIView *)scrollViewsItemViewsInLoopScrollView:(LoopScrollView *)scrollView frame:(CGRect)frame data:(NSArray *)data section:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imageView.image = [UIImage imageWithContentsOfFile:data[section]];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
    view1.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [view addSubview:view1];
    
    return view;
}
-(void)scrollView:(LoopScrollView *)scrollView didSelectSection:(NSInteger)section{
    NSLog(@"当前选中页:%li",section);
}

#pragma mark - 懒加载
- (LoopScrollView *)scrollView{
    if(!_scrollView){
        CGSize size = [UIScreen mainScreen].bounds.size;
        _scrollView = [[LoopScrollView alloc]initWithFrame:CGRectMake(5, 20, size.width - 10, size.height * 0.25)];
        _scrollView.dataSource = self;
        _scrollView.delegate = self;
        _scrollView.pageIndicatorTintColor = [UIColor lightGrayColor];
        _scrollView.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
