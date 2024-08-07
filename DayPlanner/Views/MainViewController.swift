//
//  MainViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/25/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxAppState

final class MainViewController: UIViewController {
    // MARK: - Propertis
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var shadowView: UIView!
   
    @IBOutlet weak var navButton: UIButton!
    
    private let filterSubject = BehaviorSubject<Filter>(value: .all)
    private let bag = DisposeBag()
    
    private var pageViewController: UIPageViewController!
    
    var viewModel: MainViewModel!
    
    private lazy var subViewControllers: [UIViewController] = {
        // binding
        var memoListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoList") as! MemoListViewController
        
        var calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoCalender") as! CalenderViewController
        
        let listViewModel = MemoListViewModel(storage: viewModel.storage, store: viewModel.store)
        let calendarViewModel = CalendarViewModel(storage: viewModel.storage)
        
        memoListVC.bind(viewModel: listViewModel)
        calendarVC.bind(viewModel: calendarViewModel)
        
        return [
            memoListVC,
            calendarVC
        ]
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setPageViewLayout()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 2
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 16
        shadowView.layer.backgroundColor = UIColor.white.cgColor
        
        let all = UIAction(title: "전체 일정", handler: { [weak self] _ in
            self?.filterSubject.onNext(.all)
        })
        let upcomming = UIAction(title: "다가오는 일정", handler: { [weak self] _ in
            self?.filterSubject.onNext(.upcomming)
        })
        
        let last = UIAction(title: "지난 일정", handler: { [weak self] _ in
            self?.filterSubject.onNext(.last)
        })
        
        let Items = [all, upcomming, last]
        
        navButton.menu = UIMenu(children: Items)
    }
    
    private func setPageViewLayout() {
        // pageViewController Setting
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParent: self)
        
        pageViewController.setViewControllers([subViewControllers[0]], direction: .forward, animated: true)
    }
    
    private func goToSettingVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingVC = storyboard.instantiateViewController(withIdentifier: "Setting") as? SettingViewController else {
            fatalError()
        }
        
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private func setPage(_ index: Int) {
        var direction: UIPageViewController.NavigationDirection
        let willShownViewController = subViewControllers[index]
        if let _ = willShownViewController as? MemoListViewController {
            direction = .reverse
        } else {
            direction = .forward
        }
        pageViewController.setViewControllers([subViewControllers[index]], direction: direction, animated: true)
    }
}

// MARK: - Bind
extension MainViewController: BindableType {
    
    func bindViewModel() {
        // binding
        let input = MainViewModel.Input(settingButtonTap: settingButton.rx.tap,
                                        segmentSeleted: segmentedControl.rx.selectedSegmentIndex,
                                        filterSubject: filterSubject,
                                        viewWillAppear: self.rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        output.goToSettingVC
            .subscribe(onNext: goToSettingVC)
            .disposed(by: bag)
        
        output.movePage
            .drive(onNext: setPage)
            .disposed(by: bag)
        
        output.movePage
            .map { $0 == 0 ? "전체 일정" : "캘린더" }
            .drive(navButton.rx.title())
            .disposed(by: bag)
                
        output.selecteFilter
            .map { $0.rawValue }
            .bind(to: navButton.rx.title())
            .disposed(by: bag)
        
        output.segmentSelected
            .map { $0 == 0 ? true : false }
            .bind(to: navButton.rx.isEnabled)
            .disposed(by: bag)
    }
}


