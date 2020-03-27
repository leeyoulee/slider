//
//  ViewController.swift
//  slider
//
//  Created by 이유리 on 10/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var sliderCell: SliderTableViewCell?
    var delegateValue = BehaviorRelay(value: false)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        registerCells()
        
        delegateValue.asObservable().subscribe(onNext:{[weak self] _ in
            guard let `self` = self else { return }
                self.mainTableView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension MainViewController {
    
    // xib 파일로 만들어진 cell을 tableView에 붙여줌
    func registerCells() {
        self.mainTableView.register(UINib(nibName: SwitchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.identifier)
        self.mainTableView.register(UINib(nibName: SliderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SliderTableViewCell.identifier)
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
            
            // switch의 값을 변수에 담아줌 -> cell이 재구성될 때 switch값이 초기화되는 것을 막기 위해
            cell.sliderEnableSwitch.isOn = cell.switchIsOn.value
            
            cell.delegate = self
            
            return cell
            
        default:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
            cell.sliderEnabel.accept(self.delegateValue.value)
            return cell
        }
    }
    
}

extension MainViewController: SliderDelegate { // delegate 채택
    
    func sliderEnableCheck(isOn: Bool) {
        self.delegateValue.accept(isOn) // delegateValue에 SwitchTableViewCell에서 받아온 SwitchIsOn 값을 넣어줌
    }
    
}
