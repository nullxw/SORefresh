# SORefresh
适用于自定义刷新界面的上下拉刷新

## 一睹为快
```objc
__weak typeof(self) ws = self;
[self.tableView addSORefreshNormalHeaderWithRefreshBlock:^{
    [ws prepareSomeData];
}];
[self.tableView addSORefreshNormalFooterWithRefreshBlock:^{
    [ws loadMoreData];
}];
self.tableView.scrollObserver.headerRefreshing = YES;
```objc

## Useage
### 刷新控制
如你所见，与上下拉刷新控件的交互需要通过UIScrollView及其子类对象的scrollObserver（SORefreshScrollObserver对象）对象来进行。
刷新控制的接口在SORefreshScrollObserver.h中定义，如下：
```objc
@property (nonatomic, getter=isHeaderRefreshing) BOOL headerRefreshing;// 控制header的刷新与否
@property (nonatomic, getter=isFooterRefreshing) BOOL footerRefreshing;// 控制footer的刷新与否
@property (nonatomic) BOOL hasMoreData;// 如果没有更多数据需要刷新，可设置此属性为NO；
```objc
Demo:
```objc
self.tableView.scrollObserver.headerRefreshing = YES;// 使header开始刷新
self.tableView.scrollObserver.headerRefreshing = NO;// 使header停止刷新
```objc

### 为UIScrollView或其子类对象创建header、footer
```objc
/*!
    @brief 为UIScrollView或其子类对象通过block参数创建SORefresh默认提供的header。
    @param header刷新时将会执行的block。
 */
- (void)addSORefreshNormalHeaderWithRefreshBlock:(SORefreshingBlock)refreshBlock;
/*!
    @brief 为UIScrollView或其子类对象通过block参数创建SORefresh默认提供的footer。
    @param footer刷新时将会执行的block。
 */
- (void)addSORefreshNormalFooterWithRefreshBlock:(SORefreshingBlock)refreshBlock;

/*!
     @brief 为UIScrollView或其子类对象通过block参数创建自定义的header。
     @param 由用户自定义的header对象
     @param header刷新时将会执行的block。
 */
- (void)addHeaderView:(UIView<SORefreshHeaderContent> *)headerView refreshBlock:(SORefreshingBlock)refreshBlock;
/*!
     @brief 为UIScrollView或其子类对象通过block参数创建自定义的footer。
     @param 由用户自定义的footer对象
     @param footer刷新时将会执行的block。
 */
- (void)addFooterView:(UIView<SORefreshFooterContent> *)footerView refreshBlock:(SORefreshingBlock)refreshBlock;
```objc