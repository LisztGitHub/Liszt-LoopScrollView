//
//  LoopScrollView.m
//  LoopScrollView
//
//  Created by Liszt on 16/10/14.
//  Copyright © 2016年 https://github.com/LisztGitHub. All rights reserved.
//

#import "LoopScrollView.h"

@interface LoopScrollView()<UIScrollViewDelegate>{
    NSMutableArray *dataArray;
}
//  scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
//  pageView
@property (strong, nonatomic) UIPageControl *pageControl;
//  timer
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation LoopScrollView


-(void)setPageControlPoint:(CGPoint)pageControlPoint{
    _pageControlPoint = pageControlPoint;
    _pageControl.frame = CGRectMake(_pageControlPoint.x, _pageControlPoint.y, (self.dataArray.count-2) * 15, 20);
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(NSMutableArray *)dataArray
{
    if (!dataArray) {
        dataArray = [NSMutableArray array];
    }
    return dataArray;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.dataSource)
    {
        [NSException raise:@"请实现LoopScrollView的dataSource" format:@"否则无法使用LoopScrollView"];
    }
}

#pragma mark - UI and Data
- (void)setUpUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    [self addSubview:_pageControl];
}

- (void)createItemView{
    NSArray *tempDatas = nil;
    if([_dataSource respondsToSelector:@selector(scrollViewItemDatasInLoopScrollView:)]){
        tempDatas = [_dataSource scrollViewItemDatasInLoopScrollView:self];
    }
    
    id fristView = tempDatas.firstObject;
    id lastView = tempDatas.lastObject;
    
    [self.dataArray addObject:lastView];
    [self.dataArray addObjectsFromArray:tempDatas];
    [self.dataArray addObject:fristView];
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.dataArray.count, self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    CGPoint tempPoint = _pageControlPoint.x!=0?_pageControlPoint:CGPointMake((self.frame.size.width-(tempDatas.count * 15))/2, _scrollView.frame.origin.y + _scrollView.frame.size.height - 30);
    
    _pageControl.numberOfPages = tempDatas.count;
    _pageControl.frame = CGRectMake(tempPoint.x, tempPoint.y, tempDatas.count * 15, 20);
    
    UIColor *tempCurrentColor = _currentPageIndicatorTintColor?_currentPageIndicatorTintColor:[UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = tempCurrentColor;
    
    UIColor *tempPageColor = _pageIndicatorTintColor?_pageIndicatorTintColor:[UIColor orangeColor];
    _pageControl.pageIndicatorTintColor = tempPageColor;
    
    for(int i = 0; i < self.dataArray.count; i ++){
        UIView *tempView = [_dataSource scrollViewsItemViewsInLoopScrollView:self frame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) data:self.dataArray section:i];
        tempView.tag = i+100;
        [tempView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tempTapAction:)]];
        [_scrollView addSubview:tempView];
    }
    
    if(tempDatas.count>1){
        [self initTimer];
        self.scrollView.scrollEnabled = YES;
        _pageControl.hidden = NO;
    }
    else{
        [_timer invalidate];
        _timer = nil;
        self.scrollView.scrollEnabled = NO;
        _pageControl.hidden = YES;
    }
}

- (void)reloadData{
    if(self.scrollView.subviews.count!=0){
        for(UIView *view in self.scrollView.subviews){
            [view removeFromSuperview];
        }
    }
    [self.dataArray removeAllObjects];
    [self createItemView];
}

-(void)setDataSource:(id<LoopScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self createItemView];
}

- (void)initTimer{
    CGFloat tempTime = _scrollTimeInterval == 0?2.f:_scrollTimeInterval;
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:tempTime target:self selector:@selector(startLoopView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)startLoopView{
    
    CGFloat offsetX;
    NSInteger result = (int)self.scrollView.contentOffset.x % (int)self.bounds.size.width;
    NSInteger positionNum = (int)self.scrollView.contentOffset.x / (int)self.bounds.size.width;
    if (result != 0) {
        offsetX = self.bounds.size.width * positionNum + self.bounds.size.width;
    }else
    {
        offsetX = self.scrollView.contentOffset.x + self.bounds.size.width;
    }
    
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UITapGes Action
- (void)tempTapAction:(UITapGestureRecognizer *)recognizer{
    if([self.delegate respondsToSelector:@selector(scrollView:didSelectSection:)]){
        [self.delegate scrollView:self didSelectSection:recognizer.view.tag-100];
    }
}

#pragma mark - ScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = (scrollView.contentOffset.x + self.bounds.size.width * 0.5)/self.frame.size.width - 1;
    _pageControl.currentPage = page;
    if(scrollView.contentOffset.x>self.frame.size.width * (self.dataArray.count - 1.5)){
        _pageControl.currentPage = 0;
    }
    else if (scrollView.contentOffset.x<self.frame.size.width * 0.5){
        _pageControl.currentPage = self.dataArray.count - 3;
    }
    
    if(scrollView.contentOffset.x<=0){
        scrollView.contentOffset = CGPointMake(self.frame.size.width * (self.dataArray.count - 2), 0);
    }
    else if (scrollView.contentOffset.x>=self.frame.size.width * (self.dataArray.count - 1)){
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.dataArray.count>1){
        [self initTimer];
    }
}

@end
