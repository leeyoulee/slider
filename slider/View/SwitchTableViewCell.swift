//
//  SwitchTableViewCell.swift
//  slider
//
//  Created by 이유리 on 10/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SliderDelegate: class {
    func sliderEnableCheck(isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sliderEnableSwitch: UISwitch!
    
    static let identifier = String(describing: SwitchTableViewCell.self)
    
    var switchIsOn = BehaviorRelay(value: false)
    var disposeBag = DisposeBag()
    weak var delegate: SliderDelegate?  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sliderEnableSwitch
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(sliderEnableSwitch.rx.value) // switch의 변경되는 값 중 가장 최근의 값을 가져옴
            .bind(to: switchIsOn)
            .disposed(by: disposeBag)
        
        switchIsOn
            .asObservable()
            .subscribe(onNext: { [weak self] value in // 변경되는 switch의 isOn 값을 넣어준 변수를 구독
                guard let `self` = self else { return }
                
                // delegate를 사용하여 MainViewController의 delegateValue 값에 변경되는 switch의 isOn 값을 넣어줌
                self.delegate?.sliderEnableCheck(isOn: value)
                
            }).disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // cell을 재사용할 때 switch의 값이 초기화되는 문제점 해결하기 위해 초기값을 지정해줌
    override func prepareForReuse() {
        sliderEnableSwitch.isOn = switchIsOn.value
    }
    
}
