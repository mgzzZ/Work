//
//  DanmakuView.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DanmakuView.h"
#import "DanmakuCell.h"

static NSString *Identifier = @"danmakuIdentifier";
@implementation DanmakuView
{
    NSArray *_randomColorArr;
    BOOL _isAutoScrollDanmaku;
    NSInteger _unReadMesCount;
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableArray *)danmakuDataArr
{
    if (_danmakuDataArr) {
        return _danmakuDataArr;
    }
    _danmakuDataArr = [NSMutableArray array];
    return _danmakuDataArr;
}

#pragma mark - xib init
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DanmakuView class]) owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self.danmakuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DanmakuCell class]) bundle:nil] forCellReuseIdentifier:Identifier];
    [NotificationCenter addObserver:self selector:@selector(didReceiveDanmakuMessage:) name:DidReceiveDanmakuFormLeanCloudCusstomMessage object:nil];
    _randomColorArr = @[
                        [Color colorWithHex:@"f5bf39"],
                        [Color colorWithHex:@"39b54a"],
                        [Color colorWithHex:@"ec008c"],
                        [Color colorWithHex:@"fc6342"],
                        [Color colorWithHex:@"0dd8ca"],
                        [Color colorWithHex:@"C638BC"],
                        [Color colorWithHex:@"00AEEF"],
                        ];
    _unReadMesCount = 0;
    _isAutoScrollDanmaku = YES;
}

#pragma mark - 收到弹幕消息
- (void)didReceiveDanmakuMessage:(NSNotification *)object
{
    WS(weakSelf);
    NSDictionary *dic = object.object;
    if (dic) {
        self.danmakuModel = [DanmakuModel new];
        [weakSelf.danmakuModel setName:[dic safe_objectForKey:@"name"]];
        [weakSelf.danmakuModel setDanmaku:[dic safe_objectForKey:@"message"]];
        [weakSelf.danmakuModel setUserId:[dic safe_objectForKey:@"uID"]];
        [weakSelf.danmakuDataArr addObject:[self randomColorWithDanmakuMessage:self.danmakuModel]];
        
        [weakSelf.danmakuTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.danmakuDataArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        if (!_isAutoScrollDanmaku) {
            _unReadMesCount++;
            self.nMesRemindBgView.hidden = NO;
            self.nMesRemindL.text = [NSString stringWithFormat:@"%ld条新消息         ", (long)_unReadMesCount];
        }else {
            _unReadMesCount = 0;
            [weakSelf.danmakuTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.danmakuDataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.danmakuDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DanmakuCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.tempDanmaku = self.danmakuDataArr[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:Identifier configuration:^(DanmakuCell *cell) {
        cell.tempDanmaku = weakSelf.danmakuDataArr[indexPath.row];
    }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isAutoScrollDanmaku = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isAutoScrollDanmaku) {
        NSArray *visibleArr = [self.danmakuTableView visibleCells];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (DanmakuCell *cell in visibleArr) {
            [indexPaths addObject:cell.indexPath];
        }
        _isAutoScrollDanmaku = NO;
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:self.danmakuDataArr.count - 2 inSection:0];
        if ([indexPaths containsObject: bottomIndexPath]) {
            _isAutoScrollDanmaku = YES;
            self.nMesRemindBgView.hidden = YES;
        }
    }
}

#pragma mark - Private Method
- (NSAttributedString *)randomColorWithDanmakuMessage:(DanmakuModel *)model
{
    if (model.name) {
        NSString *danmakuString = [NSString stringWithFormat:@"%@: %@", model.name, model.danmaku];
        NSRange range = [danmakuString rangeOfString:model.name];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:danmakuString];
        [attStr addAttribute:NSForegroundColorAttributeName value:_randomColorArr[arc4random() % _randomColorArr.count] range:range];
        return attStr;
    }else {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.danmaku];
        [attStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"E4393C"] range:NSMakeRange(0, attStr.length)];
        return attStr;
    }
}
- (IBAction)seeNewMessageAction:(UIButton *)sender {
    [self.danmakuTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.danmakuDataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];;
}

- (void)layoutSubviews
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
