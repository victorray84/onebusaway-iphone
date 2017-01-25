//
//  FloatingMenuController.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/19/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import SnapKit
import UIKit

@objc protocol FloatingMenuDataSource {
    func rowsFor(_ floatingMenu: FloatingMenuController) -> [FloatingMenuAction]?
}

class FloatingMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    static let blurStyle: UIBlurEffectStyle = .dark

    private var actions: [FloatingMenuAction] = []
    public weak var dataSource: FloatingMenuDataSource?

    public lazy var backgroundEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: blurStyle)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return effectView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()

    private var floatingActionButton: FloatingButton = {
        let button = FloatingButton.init(frame: CGRect.zero)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        return button
    }()

    class func floatingMenu(dataSource: FloatingMenuDataSource) -> FloatingMenuController {
        let menu = FloatingMenuController.init()
        menu.dataSource = dataSource
        menu.modalTransitionStyle = .crossDissolve
        menu.providesPresentationContextTransitionStyle = true
        menu.definesPresentationContext = true
        menu.modalPresentationStyle = .overFullScreen
        //         menu.modalPresentationStyle = .overCurrentContext ???
        menu.transitioningDelegate = menu

        return menu
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundEffectView.frame = self.view.bounds
        self.view.addSubview(self.backgroundEffectView)

        self.backgroundEffectView.contentView.addSubview(self.floatingActionButton)
        self.backgroundEffectView.contentView.addSubview(self.tableView)

        self.floatingActionButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(64)
        }

        self.tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.floatingActionButton.snp.top).offset(-2 * OBATheme.defaultPadding())
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }

        self.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateContentInset()
    }

    // MARK: - Display

    func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Data Loading

    public func reloadData() {
        self.actions = self.dataSource?.rowsFor(self) ?? []
        self.tableView.reloadData()
    }

    // MARK: - UITableView

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")

        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "identifier")
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.textAlignment = .right

            let backgroundView = UIView.init()
            backgroundView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
            cell?.selectedBackgroundView = backgroundView
        }

        let action = self.actions[indexPath.row]

        let imageView = UIImageView.init(image: action.image)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit

        let accessoryView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 38, height: 32))
        accessoryView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }

        cell?.accessoryView = accessoryView
        cell?.textLabel?.text = action.text

        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuAction = self.actions[indexPath.row]

        guard let target = menuAction.target, let action = menuAction.action else {
            return
        }

        tableView.deselectRow(at: indexPath, animated: false)

        self.dismiss(animated: true) { 
            _ = target.perform(action, with: self)
        }
    }

    private func updateContentInset() {
        let height = self.tableView.bounds.height
        let contentSize = self.tableView.contentSize.height
        let maxTop = max(0.0, height - contentSize)
        self.tableView.contentInset = UIEdgeInsetsMake(maxTop, 0, 0, 0)
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation.init()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation.init();
    }
}

class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return UIView.inheritedAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController: FloatingMenuController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? FloatingMenuController else {
            return;
        }

        let container = transitionContext.containerView
        container.addSubview(toController.view)

        toController.backgroundEffectView.effect = nil
        UIView.animate(withDuration: UIView.inheritedAnimationDuration, animations: {
            toController.backgroundEffectView.effect = UIBlurEffect(style: FloatingMenuController.blurStyle)
        }) { (complete) in
            transitionContext.completeTransition(complete)
        }
    }
}

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return UIView.inheritedAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController: FloatingMenuController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? FloatingMenuController else {
            return
        }

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        let container = transitionContext.containerView
        container.addSubview(toView)

        UIView.animate(withDuration: UIView.inheritedAnimationDuration, animations: {
            fromController.backgroundEffectView.effect = nil
        }) { (complete) in
            transitionContext.completeTransition(complete)
        }
    }
}
