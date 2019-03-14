//
//  QDMyPurchaseCell.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/2/25.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDMyPurchaseCell.h"
#import "QDORDERField.h"
@implementation QDMyPurchaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.shadowColor = APP_GRAYLINECOLOR.CGColor;
        // 阴影偏移，默认(0, -3)
        _backView.layer.shadowOffset = CGSizeMake(2,3);
        // 阴影透明度，默认0
        _backView.layer.shadowOpacity = 3;
        // 阴影半径，默认3
        _backView.layer.shadowRadius = 2;
        [self.contentView addSubview:_backView];
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_shadowView];
        
        _operationTypeLab = [[UILabel alloc] init];
        _operationTypeLab.text = @"买入";
        _operationTypeLab.textColor = [UIColor colorWithHexString:@"#CAA45B"];
        _operationTypeLab.font = QDFont(15);
        [_shadowView addSubview:_operationTypeLab];
        
        _dealLab = [[UILabel alloc] init];
        _dealLab.text = @"已成交";
        _dealLab.font = QDFont(14);
        _dealLab.textColor = APP_BLUECOLOR;
        [_shadowView addSubview:_dealLab];
        
        _deal = [[UILabel alloc] init];
        _deal.text = @"0";
        _deal.font = QDFont(14);
        _deal.textColor = APP_BLUECOLOR;
        [_shadowView addSubview:_deal];
        
        _frozenLab = [[UILabel alloc] init];
        _frozenLab.text = @"冻结";
        _frozenLab.font = QDFont(14);
        _frozenLab.textColor = APP_BLUECOLOR;
        [_shadowView addSubview:_frozenLab];
        
        _frozen = [[UILabel alloc] init];
        _frozen.text = @"0";
        _frozen.font = QDFont(14);
        _frozen.textColor = APP_BLUECOLOR;
        [_shadowView addSubview:_frozen];
        
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = APP_GRAYLINECOLOR;
        _centerLine.alpha = 0.2;
        [_backView addSubview:_centerLine];
        
        _priceTextLab = [[UILabel alloc] init];
        _priceTextLab.text = @"单价";
        _priceTextLab.font = QDFont(14);
        _priceTextLab.textColor = APP_GRAYLINECOLOR;
        [_backView addSubview:_priceTextLab];
        
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"¥";
        _priceLab.font = QDBoldFont(20);
        _priceLab.textColor = APP_ORANGETEXTCOLOR;
        [_backView addSubview:_priceLab];
        
        _price = [[UILabel alloc] init];
        _price.text = @"30.00";
        _price.font = QDBoldFont(24);
        _price.textColor = APP_ORANGETEXTCOLOR;
        [_backView addSubview:_price];
        
        _status = [[UILabel alloc] init];
        _status.text = @"不可部分成交";
        _status.font = QDFont(14);
        _status.textColor = APP_BLUECOLOR;
        [_backView addSubview:_status];
        
        _amountLab = [[UILabel alloc] init];
        _amountLab.text = @"数量";
        _amountLab.textColor = APP_GRAYLINECOLOR;
        _amountLab.font = QDFont(14);
        [_backView addSubview:_amountLab];
        
        _amount = [[UILabel alloc] init];
        _amount.text = @"2000";
        _amount.font = QDFont(14);
        _amount.textColor = APP_GRAYTEXTCOLOR;
        [_backView addSubview:_amount];
        
        
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.text = @"金额";
        _balanceLab.textColor = APP_GRAYLINECOLOR;
        _balanceLab.font = QDFont(14);
        [_backView addSubview:_balanceLab];
        
        _balance = [[UILabel alloc] init];
        _balance.text = @"¥10.00";
        _balance.font = QDFont(14);
        _balance.textColor = APP_GRAYTEXTCOLOR;
        [_backView addSubview:_balance];
        
        _status = [[UILabel alloc] init];
        _status.text = @"已不可部分成交";
        _status.font = QDFont(14);
        _status.textColor = APP_GRAYLINECOLOR;
        [_backView addSubview:_status];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = APP_GRAYLINECOLOR;
        _lineView.alpha = 0.2;
        [_backView addSubview:_lineView];
        
        _orderStatusLab = [[UILabel alloc] init];
        _orderStatusLab.text = @"已部分成交";
        _orderStatusLab.font = QDFont(14);
        _orderStatusLab.textColor = APP_GRAYLINECOLOR;
        [_backView addSubview:_orderStatusLab];
        
        _withdrawBtn = [[UIButton alloc] init];
        _withdrawBtn.backgroundColor = APP_GRAYBUTTONCOLOR;
        [_withdrawBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        [_withdrawBtn setTitle:@"撤单" forState:UIControlStateNormal];
        _withdrawBtn.titleLabel.font = QDFont(16);
        _withdrawBtn.layer.cornerRadius = 10;
        _withdrawBtn.hidden = YES;
        _withdrawBtn.layer.masksToBounds = YES;
        [_backView addSubview:_withdrawBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(SCREEN_HEIGHT*0.02);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-(SCREEN_HEIGHT*0.02));
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.05);
        make.right.equalTo(self.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
    
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(_backView);
        make.height.mas_equalTo(40);
    }];
    
    [_operationTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.left.equalTo(_shadowView.mas_left).offset(SCREEN_WIDTH*0.04);
    }];
    
    [_dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_operationTypeLab);
        make.left.equalTo(_shadowView.mas_left).offset(SCREEN_WIDTH*0.44);
    }];
    
    [_deal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.left.equalTo(_dealLab.mas_right).offset(4);
    }];

    [_frozenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.left.equalTo(_deal.mas_right).offset(10);
    }];

    [_frozen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.left.equalTo(_frozenLab.mas_right).offset(4);
    }];
    
    [_priceTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shadowView.mas_bottom).offset(15);
        make.left.equalTo(_operationTypeLab);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceTextLab.mas_bottom).offset(2);
        make.left.equalTo(_shadowView.mas_left).offset(30);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price);
        make.right.equalTo(_price.mas_left).offset(-2);
    }];
    
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceTextLab);
        make.left.equalTo(_backView.mas_left).offset(180);
    }];
    
    [_amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_amountLab);
        make.left.equalTo(_amountLab.mas_right).offset(12);
    }];
    
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price);
        make.left.equalTo(_amountLab);
    }];
    
    [_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_balanceLab);
        make.left.equalTo(_amount);
    }];
    
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price.mas_bottom).offset(3);
        make.left.equalTo(_priceTextLab.mas_left).offset(3);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.bottom.equalTo(_backView.mas_bottom).offset(-(SCREEN_HEIGHT*0.07));
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH*0.81);
    }];
    
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lineView);
        make.top.equalTo(_shadowView.mas_bottom).offset(SCREEN_HEIGHT*0.02);
        make.bottom.equalTo(_lineView.mas_top).offset(-(SCREEN_HEIGHT*0.02));
        make.width.mas_equalTo(1);
    }];

    [_orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTextLab);
        make.top.equalTo(_lineView.mas_bottom).offset(6);
    }];

    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderStatusLab);
        make.left.equalTo(_balanceLab);
        make.width.mas_equalTo(SCREEN_WIDTH*0.2);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.04);
    }];
}

- (void)loadPurchaseDataWithModel:(BiddingPostersDTO *)DTO{
    //单价
    if (DTO.price == nil) {
        self.price.text = @"--";
    }else{
        self.price.text= DTO.price;
    }
    //剩余数量
    if (DTO.surplusVolume == nil) {
        self.amount.text = @"--";
    }else{
        self.amount.text= DTO.surplusVolume;
    }
    if (DTO.price == nil || [DTO.price isEqualToString:@""] || DTO.surplusVolume == nil || [DTO.surplusVolume isEqualToString:@""]) {
        self.balance.text = @"--";
    }else{
        self.balance.text = [NSString stringWithFormat:@"%.2lf", [DTO.price doubleValue] * [DTO.surplusVolume doubleValue]];
    }
    if ([DTO.isPartialDeal isEqualToString:@"0"]) {
        self.status.text = @"不可部分成交";
        self.status.textColor = APP_GRAYLINECOLOR;
    }else{
        self.status.text = @"可部分成交";
        self.status.textColor = APP_BLUECOLOR;
    }
    
    //未成交与部分成交的时候 并且
    switch ([DTO.postersStatus integerValue]) {
        case QD_ORDERSTATUS_NOTTRADED:
            self.orderStatusLab.text = @"未成交";
            self.withdrawBtn.hidden = NO;
            break;
        case QD_ORDERSTATUS_PARTTRADED:
            self.orderStatusLab.text = @"部分成交";
            self.withdrawBtn.hidden = NO;
            break;
        case QD_ORDERSTATUS_ALLTRADED:
            self.orderStatusLab.text = @"全部成交";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_ORDERSTATUS_ALLCANCELED:
            self.orderStatusLab.text = @"全部撤单";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_ORDERSTATUS_PARTCANCELED:
            self.orderStatusLab.text = @"全成部撤";
            self.withdrawBtn.hidden = NO;
            break;
        case QD_ORDERSTATUS_ISCANCELED:
            self.orderStatusLab.text = @"已取消";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_ORDERSTATUS_INTENTION:
            self.orderStatusLab.text = @"意向单";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_ORDERSTATUS_WAITPAY:
            self.orderStatusLab.text = @"待付款";
            self.withdrawBtn.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)loadMyPickPurchaseDataWithModel:(QDMyPickOrderModel *)model{
    if (model.amount == nil) {
        self.price.text = @"--";
    }else{
        self.price.text= model.price;
    }
    if (model.number == nil) {
        self.amount.text = @"--";
    }else{
        self.amount.text= model.number;
    }
    self.balance.text = model.amount;
    self.transfer.text = model.poundage;
    
    switch ([model.state integerValue]) {
        case QD_WaitForPurchase:
            self.orderStatusLab.text = @"待付款";
            self.withdrawBtn.hidden = NO;
            break;
        case QD_HavePurchased:
            self.orderStatusLab.text = @"已付款";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_HaveFinished:
            self.orderStatusLab.text = @"已完成";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_OverTimeCanceled:
            self.orderStatusLab.text = @"超时取消";
            self.withdrawBtn.hidden = YES;
            break;
        case QD_ManualCanceled:
            self.orderStatusLab.text = @"手工取消";
            self.withdrawBtn.hidden = YES;
            break;
        default:
            break;
    }
}
@end
