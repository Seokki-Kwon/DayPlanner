//
//  SettingViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var menuSubject = BehaviorSubject<[Menu]>(value: [.contact, .openSource])
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        menuSubject
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) {tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")!
                cell.textLabel?.text = element.title
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(Menu.self)
            .bind(onNext: movePage)
            .disposed(by: bag)
    }
    
    func movePage(_ menu: Menu) {
        
    }
    
}
