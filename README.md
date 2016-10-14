# Liszt-LoopScrollView
无限轮播滚动试图
#
## 兼容性
### 1.兼容网络图片 
### 2.无限轮播 
### 3.任意设置page位置  
### 4.数据刷新ReloadData  
### 5.扩展性极强
<img src="https://github.com/LisztGitHub/Liszt-LoopScrollView/blob/master/Liszt.gif" />
      #import <UIKit/UIKit.h>
    @class LoopScrollView;

    @protocol LoopScrollViewDataSource <NSObject>
    @required
    /**
     *  设置滚动视图的数据长度
     */
    - (NSArray *)scrollViewItemDatasInLoopScrollView:(LoopScrollView *)scrollView;
    /**
     *  设置每页显示的视图
     *  @param frame    当前视图创建的Frame
     *  @param data     数据源
     *  @param section  当前的列
     */
    - (UIView *)scrollViewsItemViewsInLoopScrollView:(LoopScrollView *)scrollView frame:(CGRect)frame data:(NSArray *)data section:(NSInteger)section;
    @end
    
    @protocol LoopScrollViewDelegate <NSObject>
    @optional
    /**
     *  单击手势
     *  @param  section 选中的页
     */
    - (void)scrollView:(LoopScrollView *)scrollView didSelectSection:(NSInteger)section;
    @end

    @interface LoopScrollView : UIView
    //  dataSource
    @property (assign, nonatomic) id<LoopScrollViewDataSource> dataSource;
    //  delegate
    @property (assign, nonatomic) id<LoopScrollViewDelegate> delegate;
    //  pageFrame   设置翻页标识的位置
    @property (assign, nonatomic) CGPoint pageControlPoint;
    //  翻页时间
    @property (assign, nonatomic) CGFloat scrollTimeInterval;
    //  currentPageIndicatorTintColor
    @property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;
    //  pageIndicatorTintColor
    @property (strong, nonatomic) UIColor *pageIndicatorTintColor;

    /**
     *  刷新数据
     */
    - (void)reloadData;
    @end
