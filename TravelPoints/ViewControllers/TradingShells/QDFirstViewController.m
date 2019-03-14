//
//  QDTradingShellsVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFirstViewController.h"
#import "QDTradeShellsSectionHeaderView.h"
#import "MyTableCell.h"
#import "TFDropDownMenu.h"
#import "SnailQuickMaskPopups.h"
#import "QDFilterTypeOneView.h"
#import "QDFilterTypeTwoView.h"
#import "QDFilterTypeThreeView.h"
#import "QDShellRecommendVC.h"
#import "QDMySaleOrderCell.h"
#import "QDPickUpOrderCell.h"
#import "QDOrderDetailVC.h"
#import <TYAlertView/TYAlertView.h>
#import "BiddingPostersDTO.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "RootCollectionCell.h"
#import "WaterLayou.h"
#define K_T_Cell @"t_cell"
#define K_C_Cell @"c_cell"

// 要玩贝  转玩贝  我的报单  我的摘单
typedef enum : NSUInteger {
    QDPlayShells = 0,
    QDTradeShells = 1,
    QDMyOrders = 2,
    QDPickUpOrders = 3
} QDShellType;

@interface QDFirstViewController ()<UITableViewDelegate, UITableViewDataSource, SnailQuickMaskPopupsDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UICollectionViewDelegate, UICollectionViewDataSource>{
    QDTradeShellsSectionHeaderView *_sectionHeaderView;
    QDShellType _shellType;
    UIView *_backView;
    UIButton *_optionBtn;    //要玩贝操作按钮
    NSMutableArray *_ordersArr;
    int _pageNum;
    int _pageSize;
    int _totalPage;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, strong) SnailQuickMaskPopups *popups;
@property (nonatomic, strong) QDFilterTypeOneView *typeOneView;
@property (nonatomic, strong) QDFilterTypeTwoView *typeTwoView;
@property (nonatomic, strong) QDFilterTypeThreeView *typeThreeView;




@end

@implementation QDFirstViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _pageNum = 1;
    _pageSize = 10;
    _totalPage = 0; //总页数默认为1
    _ordersArr = [[NSMutableArray alloc] init];
    [self initTableView];
    _optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.31, SCREEN_HEIGHT*0.72, SCREEN_WIDTH*0.37, SCREEN_HEIGHT*0.06)];
    [_optionBtn addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.37, SCREEN_HEIGHT*0.06);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [_optionBtn.layer addSublayer:gradientLayer];
    [_optionBtn setTitle:@"要玩贝" forState:UIControlStateNormal];
    _optionBtn.backgroundColor = [UIColor redColor];
    _optionBtn.layer.cornerRadius = SCREEN_HEIGHT*0.03;
    _optionBtn.layer.masksToBounds = YES;
    _optionBtn.titleLabel.font = QDFont(17);
    [self.view addSubview:_optionBtn];

    [self requestYWBData];
}

/**
 NO_TRADED(0,"未成交"), // 未成交
 PART_TRADED(1,"部分成交"), // 部分成交
 ALL_TRADED(2,"全部成交"), // 全部成交
 ALL_CANCELED(3,"全部撤单"), // 全部撤单
 PART_CANCELED(4,"部分成交部分撤单"), // 部分成交部分撤单
 IS_CANCELED(5,"已取消"), // 已取消
 INTENTION(6,"意向单") ; // 意向单
 */
#pragma 要玩贝数据与上拉刷新数据请求
- (void)requestYWBData{
    if (_totalPage != 0) {
        if (_pageNum >= _totalPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    NSDictionary * dic1 = @{@"postersStatus":@"",
                            @"postersType":@"1",
                            @"pageNum":[NSNumber numberWithInt:_pageNum],
                            @"pageSize":[NSNumber numberWithInt:_pageSize],
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindCanTrade params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            _totalPage = [[dic objectForKey:@"totalPage"] intValue];
            if (hotelArr.count) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in hotelArr) {
                    BiddingPostersDTO *infoModel = [BiddingPostersDTO yy_modelWithDictionary:dic];
                    [arr addObject:infoModel];
                }
                if (arr) {
                    if (arr.count < _pageSize) {   //不满10个
                        [_ordersArr addObjectsFromArray:arr];
                        [self.tableView reloadData];
                        if ([self.tableView.mj_footer isRefreshing]) {
                            [self endRefreshing];
                            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                        }
                    }else{
                        [_ordersArr addObjectsFromArray:arr];
                        [self.tableView reloadData];
                        self.tableView.mj_footer.state = MJRefreshStateIdle;
                        QDLog(@"count = %ld", (long)_ordersArr.count);
                    }
                }
            }else{
                [self endRefreshing];
                [_tableView.mj_footer endRefreshingWithNoMoreData];

            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

#pragma mark - 下拉刷新数据  只请求第一页的数据
- (void)requestHeaderTopData{
    if (_ordersArr.count) {
        [_ordersArr removeAllObjects];
    }
    NSDictionary * dic1 = @{@"postersStatus":@"",
                            @"postersType":@"1",
                            @"pageNum":@1,
                            @"pageSize":[NSNumber numberWithInt:_pageSize],
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindCanTrade params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            _totalPage = [[dic objectForKey:@"totalPage"] intValue];
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in hotelArr) {
                    BiddingPostersDTO *infoModel = [BiddingPostersDTO yy_modelWithDictionary:dic];
                    [arr addObject:infoModel];
                }
                if (arr) {
                    if (arr.count < _pageSize) {   //不满10个
                        [_ordersArr addObjectsFromArray:arr];
                        [self.tableView reloadData];
                    }else{
                        [_ordersArr addObjectsFromArray:arr];
                        [self.tableView reloadData];
                    }
                    if ([self.tableView.mj_header isRefreshing]) {
                        [self.tableView.mj_header endRefreshing];
                    }
                }
            }else{
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 110, 0);
//    self.view = _tableView;
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.23)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, SCREEN_WIDTH*0.03, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.225)];
    imgView.image = [UIImage imageNamed:@"shellBanner"];
    [headerView addSubview:imgView];
    
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        QDLog(@"下拉刷新");
        [self requestHeaderTopData];
    }];
    
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        QDLog(@"上拉刷新");
        _pageNum++;
        [self requestYWBData];
    }];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_ordersArr.count % 2 == 0) {
        return _ordersArr.count /2  * SCREEN_HEIGHT * 0.33 + _ordersArr.count/2 * 10 + 10;
    }else{
        return (_ordersArr.count /2 + 1) * SCREEN_HEIGHT * 0.33 + (_ordersArr.count/2 + 1) * 10 + 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建瀑布流布局
        WaterLayou *layou = [[WaterLayou alloc] init];
        //创建collectionView
        CGFloat y = 0;
        if (_ordersArr.count % 2 == 0) {
            y = _ordersArr.count /2  * SCREEN_HEIGHT * 0.33 + _ordersArr.count/2 * 10 + 10;
        }else{
            y = (_ordersArr.count /2 + 1) * SCREEN_HEIGHT * 0.33 + (_ordersArr.count/2 + 1) * 10 + 10;
        }
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, y) collectionViewLayout:layou];
        self.collectionView.backgroundColor = APP_WHITECOLOR;
        self.collectionView.scrollEnabled = NO;
        //注册单元格
        [_collectionView registerClass:[RootCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    return _collectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = APP_WHITECOLOR;
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat y = 0;
    if (_ordersArr.count % 2 == 0) {
        y = _ordersArr.count /2  * SCREEN_HEIGHT * 0.33 + _ordersArr.count/2 * 10 + 10;
    }else{
        y = (_ordersArr.count /2 + 1) * SCREEN_HEIGHT * 0.33 + (_ordersArr.count/2 + 1) * 10 + 10;
    }
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, y);
    if (_ordersArr.count) {
        [self.collectionView reloadData];
    }
    [cell.contentView addSubview:self.collectionView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionHeaderView = [[QDTradeShellsSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [_sectionHeaderView.filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    _sectionHeaderView.backgroundColor = APP_WHITECOLOR;
    return _sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_shellType == QDMyOrders) {
        QDOrderDetailVC *detailVC = [[QDOrderDetailVC alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//点击UICollectionViewCell的代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (QDFilterTypeOneView *)typeOneView{
    if (_typeOneView) {
        _typeOneView = [[QDFilterTypeOneView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
        _typeOneView.backgroundColor = APP_WHITECOLOR;
    }
    return _typeOneView;
}

- (void)confirmOptions:(UIButton *)sender{
    [_popups dismissAnimated:YES completion:nil];
}


#pragma mark - 要/转玩贝操作按钮
- (void)operateAction:(UIButton *)sender{
    
    QDShellRecommendVC *recommendVC = [[QDShellRecommendVC alloc] init];
    if (_shellType == QDPlayShells) {
        recommendVC.recommendType = 0;
    }else if (_shellType == QDTradeShells){
        recommendVC.recommendType = 1;
    }
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (void)filterAction:(UIButton *)sender{
    QDLog(@"filter");
    if (_shellType == QDPlayShells || _shellType == QDTradeShells) {
        if (!_typeOneView) {
            //            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            _typeOneView = [[QDFilterTypeOneView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeOneView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeOneView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeOneView];
        _popups.presentationStyle = PresentationStyleCentered;
        
        _popups.delegate = self;
        [_popups presentInView:self.view animated:YES completion:NULL];
    }else if(_shellType == QDMyOrders){
        if (!_typeTwoView) {
            _typeTwoView = [[QDFilterTypeTwoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeTwoView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeTwoView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeTwoView];
        _popups.presentationStyle = PresentationStyleBottom;
        _popups.delegate = self;
        [_popups presentInView:self.tableView animated:YES completion:NULL];
    }else{
        if (!_typeThreeView) {
            _typeThreeView = [[QDFilterTypeThreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeThreeView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeThreeView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeThreeView];
        _popups.presentationStyle = PresentationStyleBottom;
        _popups.delegate = self;
        [_popups presentInView:self.view animated:YES completion:NULL];
    }
}

- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups{
    QDLog(@"snailQuickMaskPopupsWillPresent");
}

- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups{
    QDLog(@"snailQuickMaskPopupsWillDismiss");
}

- (void)snailQuickMaskPopupsDidPresent:(SnailQuickMaskPopups *)popups{
    QDLog(@"snailQuickMaskPopupsDidPresent");
}

- (void)snailQuickMaskPopupsDidDismiss:(SnailQuickMaskPopups *)popups{
    QDLog(@"snailQuickMaskPopupsDidDismiss");
}

#pragma mark - DZNEmtpyDataSet Delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"emptySource"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"未找到相关数据,请重试";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ordersArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RootCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDataWithDataArr:_ordersArr[indexPath.row] andTypeStr:@"0" andTag:1];
    [cell.sell addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QDLog(@"%ld", (long)indexPath.row);
}

- (void)test:(UIButton *)sender{
    QDLog(@"test");
}
@end