//
//  SettingViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import MessageUI
import AcknowList

final class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var menuSubject = BehaviorSubject<[Menu]>(value: [.contact, .openSource])
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
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
    
    private func movePage(_ menu: Menu) {
        switch menu {
        case .contact:
            sendEmail()
        case .openSource:
            openSource()
        }
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
                   let compseVC = MFMailComposeViewController()
                   compseVC.mailComposeDelegate = self
                   
                   compseVC.setToRecipients(["seokki0706@gmail.com"])
                   compseVC.setSubject("Message Subject")
                   compseVC.setMessageBody("개선사항 또는 발생한 버그에 대해서 적어주세요. \n ------------------------------------------", isHTML: false)
                   
                    present(compseVC, animated: true, completion: nil)
                   
               }
               else {
                   
               }
    }
    
    private func openSource() {
        let acknowList = AcknowListViewController(fileNamed: "Package.resolved")
        acknowList.navigationItem.title = "오픈소스/라이선스"
              navigationController?.pushViewController(acknowList, animated: true)
    }
    
}
