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
```

## Useage
### 刷新控制
如你所见，与上下拉刷新控件的交互需要通过UIScrollView及其子类对象的scrollObserver（SORefreshScrollObserver对象）对象来进行。
刷新控制的接口在SORefreshScrollObserver.h中定义，如下：
```objc
@property (nonatomic, getter=isHeaderRefreshing) BOOL headerRefreshing;// 控制header的刷新与否
@property (nonatomic, getter=isFooterRefreshing) BOOL footerRefreshing;// 控制footer的刷新与否
@property (nonatomic) BOOL hasMoreData;// 如果没有更多数据需要刷新，可设置此属性为NO；
```
Demo:
```objc
self.tableView.scrollObserver.headerRefreshing = YES;// 使header开始刷新
self.tableView.scrollObserver.headerRefreshing = NO;// 使header停止刷新
```

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
```

### 自定义刷新控件
SORefresh旨在提供对自定义刷新界面的便捷支持。
任何遵循了SORefreshContent协议的UIView对象都可以作为刷新控件使用，其中自定义的header需要遵循SORefreshHeaderContent协议，自定义的footer需要遵循SORefreshFooterContent协议。SORefreshContent协议的定义见SORefreshContent.h文件。
SORefresh默认提供的下拉刷新控件SORefreshNormalHeader、上拉刷新控件SORefreshNormalFooter可作为您自定义上下拉刷新控件时的参考。

## 建议与反馈
* 在[Issue](https://github.com/scfhao/SORefresh/issues)中提建议。
* 联系scfhaoQQ:2945214949