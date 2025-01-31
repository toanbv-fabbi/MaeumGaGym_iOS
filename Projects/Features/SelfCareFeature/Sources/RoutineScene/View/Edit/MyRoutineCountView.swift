import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

import Core
import DSKit

public class MyRoutineCountView: BaseView {

    private var countTextLabel = UILabel().then {
        $0.font = UIFont.Pretendard.bodyMedium
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 4.0
        $0.layer.borderColor = DSKitAsset.Colors.gray100.color.cgColor
        $0.backgroundColor = DSKitAsset.Colors.gray25.color
        $0.layer.borderWidth = 1
    }

    private var minusButton = MGImageButton(image: DSKitAsset.Assets.blackMinus.image)

    private var plusButtonn = MGImageButton(image: DSKitAsset.Assets.blackPlus.image)

    private var numberTextField = UITextField().then {
        $0.font = UIFont.Pretendard.bodyMedium
        $0.keyboardType = .numberPad
        $0.backgroundColor = .white
        $0.layer.borderColor = DSKitAsset.Colors.gray100.color.cgColor
        $0.layer.borderWidth = 1
        $0.textAlignment = .center
    }

    public override func layout() {
        addSubviews([countTextLabel, containerView])
        containerView.addSubviews([minusButton, numberTextField, plusButtonn])

        countTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview()
            $0.width.equalTo(64.0)
            $0.height.equalTo(20.0)
        }

        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(countTextLabel.snp.trailing).offset(12.0)
        }

        minusButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(36.0)
        }

        numberTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(minusButton.snp.trailing)
            $0.trailing.equalTo(plusButtonn.snp.leading)
        }

        plusButtonn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(36.0)
        }
    }

    public override func bind() {
        minusButton.rx.tap.subscribe(onNext: { [self] _ in
            self.numberTextField.text = "\((Int(numberTextField.text!) ?? 0) - 1)"
        }).disposed(by: disposeBag)

        plusButtonn.rx.tap.subscribe(onNext: { [self] _ in
            self.numberTextField.text = "\((Int(numberTextField.text!) ?? 0) + 1)"
        }).disposed(by: disposeBag)
    }
}

public extension MyRoutineCountView {
    func setup(text: String) {
        countTextLabel.text = text
    }

    func textFieldData(number: Int) {
        numberTextField.text = "\(number)"
    }
}
