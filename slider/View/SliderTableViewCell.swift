//
//  SliderTableViewCell.swift
//  slider
//
//  Created by 이유리 on 10/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SliderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    
    static let identifier = String(describing: SliderTableViewCell.self)
    
    var sliderEnabel = BehaviorRelay(value: false)
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        slider.rx.value
            .map{ String(Int($0)) } // slider의 값을 실시간으로 받아와서 Float -> Int -> String으로 변경
            .bind(to: valueLabel.rx.text) // String으로 변경된 값을 Lable에 display
            .disposed(by: disposeBag)
        
        sliderEnabel
            .asObservable()
            .bind(to: slider.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
