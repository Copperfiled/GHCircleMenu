//
//  GHCircleMenu.swift
//  Pods
//
//  Created by KENNEDJACK on 10/10/2016.
//
//

import UIKit
import SnapKit

//圆形展开菜单
//这里的角度坐标  逆时针 [0, 2π]

public enum GHCircleMenuDirection: Int {
    //决定角度变化的正负值
    case ClockWise = 1 //顺时针
    case AntiClockWise = -1 //逆时针
}

public class GHCircleMenu: UIView {
    /* 中心视图 */
    public let centerView: UIView
    public weak var dataSource: GHCircleMenuDataSource?
    public weak var delegate: GHCircleMenuDelegate?
    
    private var items = [UIView]()
    
    public var isOpen = false
    public var itemSize = CGSizeMake(40, 40)
    public var startAngle = 0 //开始角度(0, 2π)
    public var itemSpaceAngle = 45 //各个item间距的角度
    public var animationDuration = 0.5
    public var dely = 0.05 //各个item出现的时间差
    public var direction = GHCircleMenuDirection.AntiClockWise //默认逆时针转动
    public var radius = 80.0

    convenience public override init(frame: CGRect) {
        let defaultCenterView = UIView(frame: frame)
        self.init(frame: frame, centerView: defaultCenterView)
        defaultCenterView.layer.cornerRadius = self.frame.size.width / 2
        defaultCenterView.layer.shadowColor = UIColor.blueColor().CGColor
        defaultCenterView.layer.shadowOpacity = 0.8
        defaultCenterView.layer.shadowRadius = 2.0
        defaultCenterView.layer.shadowOffset = CGSizeMake(0, 3)
        defaultCenterView.backgroundColor = UIColor.blueColor()
        defaultCenterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GHCircleMenu.actionForTap(_:))))
    }
    
    public init(frame: CGRect, centerView custome: UIView) {
        centerView = custome
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        //中心视图
        self.addSubview(self.centerView)
        self.centerView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(frame.size)
        }
    }
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //设置子菜单
        self.setupItems()
    }
    //MARK: public methods
    public func open(handler: (complete: Bool) -> Void) {
        //展开
        for item in self.items {
            if let index = items.indexOf(item) {
                UIView.animateWithDuration(self.animationDuration,
                                           delay: Double(index) * self.dely,
                                           usingSpringWithDamping: 0.7,
                                           initialSpringVelocity: 0.4,
                                           options: UIViewAnimationOptions.AllowUserInteraction,
                                           animations: { 
                                            item.alpha = 1
                                            item.transform = self.transformForItemAtIndex(index)
                    },
                                           completion: {
                                            if $0 {
                                                self.isOpen = true
                                                if ((self.delegate?.respondsToSelector(#selector(GHCircleMenuDelegate.didOpenCircleMenu(_:)))) != nil) {
                                                    self.delegate?.didOpenCircleMenu!(self)
                                                }
                                            }
                                            handler(complete: $0)
                })
            }
        }
    }
    func close(handler: (complete: Bool) -> Void) {
        //关闭
        for item in self.items {
            if let index = items.indexOf(item) {
                UIView.animateWithDuration(self.animationDuration,
                                           delay: Double(index) * self.dely,
                                           usingSpringWithDamping: 0.7,
                                           initialSpringVelocity: 0.4,
                                           options: UIViewAnimationOptions.AllowUserInteraction,
                                           animations: { 
                                            item.transform = CGAffineTransformIdentity
                                            item.alpha = 0
                    },
                                           completion: {
                                            if $0 {
                                                self.isOpen = false
                                                if (self.delegate != nil && (self.delegate?.respondsToSelector(#selector(GHCircleMenuDelegate.didCloseCircleMenu(_:))))!) {
                                                    self.delegate?.didCloseCircleMenu!(self)
                                                }

                                            }
                                            handler(complete: $0)
                })
            }
        }
    }

    //MARK: private methods
    private func setupItems() {
        var number = 0
        if dataSource != nil && (dataSource?.respondsToSelector(#selector(GHCircleMenuDataSource.numberOfItemsInCircleMenu(_:))))! {
            number = (dataSource?.numberOfItemsInCircleMenu(self))!
        }
        for index in 0 ..< number {
            //向datasource要子视图
            if let view = dataSource?.circleMenu(self, itemAtIndex: index) {
                var size = itemSize
                if delegate != nil && (delegate?.respondsToSelector(#selector(GHCircleMenuDelegate.circleMenu(_:sizeForItemAtIndex:))))! {
                    if let tmpSize = delegate?.circleMenu!(self, sizeForItemAtIndex: index) {
                        size = tmpSize
                    }
                }
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GHCircleMenu.actionForTap(_:))))
                items.append(view)
                self.insertSubview(view, atIndex: index)
                view.snp_makeConstraints(closure: { (make) in
                    make.center.equalTo(self)
                    make.size.equalTo(size)
                })
            }
        }
    }
    func transformForItemAtIndex(index: Int) -> CGAffineTransform {
        let newAngle = self.startAngle + self.direction.rawValue * self.itemSpaceAngle * index
        let deltaX = self.radius * cos(Double(newAngle) / 360.0 * 2.0 * M_PI)
        let deltaY = self.radius * sin(Double(newAngle) / 360.0 * 2.0 * M_PI)
        return CGAffineTransformMakeTranslation(CGFloat(deltaX), CGFloat(deltaY))
    }
    func actionForTap(tap: UITapGestureRecognizer) {
        weak var weakSelf = self
        if tap.view == self.centerView {
            //点击中心
            if self.isOpen {
                self.close{ if $0 {  } }
            } else {
                self.open { weakSelf?.isOpen = $0 }
            }
        } else {
            //点击item
            if let index = self.items.indexOf(tap.view!) {
                if (self.delegate != nil && (delegate?.respondsToSelector(#selector(GHCircleMenuDelegate.circleMenu(_:didSelectAtIndex:))))!) {
                    delegate?.circleMenu!(self, didSelectAtIndex: index)
                    self.close({ (complete) in
                        //
                    })
                }
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //保证弹出的子菜单也能被点击
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(self.bounds, point) {
            return true
        }
        for item in items {
            if CGRectContainsPoint(item.frame, point) {
                return true
            }
        }
        return false
    }
}

//菜单数据源
@objc public protocol GHCircleMenuDataSource: NSObjectProtocol {
    //展开子菜单选项个数
    func numberOfItemsInCircleMenu(circleMenu: GHCircleMenu) -> Int
    
    //子选项
    func circleMenu(circleMenu: GHCircleMenu, itemAtIndex index: Int) -> UIView
}
//菜单事务代理
@objc public protocol GHCircleMenuDelegate: NSObjectProtocol {
    //子选项的大小
    optional func circleMenu(circleMenu: GHCircleMenu, sizeForItemAtIndex index: Int) -> CGSize
    //点击事件处理
    optional func circleMenu(circleMenu: GHCircleMenu, didSelectAtIndex index: Int) -> Void
    //菜单展开后
    optional func didOpenCircleMenu(circleMenu: GHCircleMenu)
    //菜单关闭后
    optional func didCloseCircleMenu(circleMenu: GHCircleMenu)
}
