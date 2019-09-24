//
//  PullRefreshVC.swift
//  CustomViewDemo
//
//  Created by admin on 2019/9/10.
//  Copyright © 2019 ios@Taipei. All rights reserved.
//

import UIKit

final class PullRefreshVC: BaseVC {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var header: PullRefreshHeader = .init(with: RefreshFooterLoadingView())
    private var footer: PullRefreshFooter = .init(with: RefreshFooterLoadingView())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        guard parent == nil else { return }
        header.invalidate()
        footer.invalidate()
    }
}

extension PullRefreshVC {
    
    private func initSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: DemoCell.self)
        
        header
            .register(on: tableView)
            .setRefreshAction {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.header.endRefresh()
            })
        }
        footer
            .register(on: tableView)
            .setRefreshAction {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.footer.endRefresh()
                })
        }
    }
}


extension PullRefreshVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(with: DemoCell.self, for: indexPath)
        cell.titleLabel.text = "這是第\(indexPath.item + 1)個Cell"
        cell.titleLabel.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 8
    }
}
