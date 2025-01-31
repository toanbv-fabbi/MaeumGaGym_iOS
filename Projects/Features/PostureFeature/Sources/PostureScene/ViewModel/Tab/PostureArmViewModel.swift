import Foundation

import RxFlow
import RxCocoa
import RxSwift

import Core
import Domain
import MGLogger

public enum ArmToggleButtonState {
    case checked
    case unChecked
}

public enum PostureArmModelState {
    case all
    case body
    case machine
}

public class PostureArmViewModel: BaseViewModel {
    
    public typealias ViewModel = PostureArmViewModel

    private let disposeBag = DisposeBag()

    private let useCase: PostureUseCase

    public struct Input {
        let firstButtonTapped: Driver<Void>
        let secondButtonTapped: Driver<Void>
        let getChestData: Driver<Void>
    }

    public struct Output {
        let firstButtonState: Observable<ChestToggleButtonState>
        let secondButtonState: Observable<ChestToggleButtonState>
        let chestModelState:
        Observable<PostureChestModelState>
        var chestData: Observable<PosePartModel>
    }

    private let firstButtonStateSubject = BehaviorSubject<ChestToggleButtonState>(value: .unChecked)
    private let secondButtonStateSubject = BehaviorSubject<ChestToggleButtonState>(value: .unChecked)
    private let chestModelStateSubject = BehaviorSubject<PostureChestModelState>(value: .all)

    private let chestDataSubject = PublishSubject<PosePartModel>()

    public init(useCase: PostureUseCase) {
        self.useCase = useCase
    }

    public func transform(_ input: Input, action: (Output) -> Void) -> Output {
        let output = Output(
            firstButtonState: firstButtonStateSubject.asObservable(),
            secondButtonState:
                secondButtonStateSubject.asObservable(),
            chestModelState: chestModelStateSubject.asObservable(),
            chestData: chestDataSubject.asObservable()
        )

        action(output)

        self.bindOutput(output: output)

        input.firstButtonTapped
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let currentState = try? owner.firstButtonStateSubject.value()

                switch currentState {
                case .unChecked:
                    owner.firstButtonStateSubject.onNext(.checked)
                    owner.secondButtonStateSubject.onNext(.unChecked)
                    owner.chestModelStateSubject.onNext(.body)
                case .checked:
                    owner.firstButtonStateSubject.onNext(.unChecked)
                    owner.chestModelStateSubject.onNext(.all)
                case .none:
                    break
                }
            }).disposed(by: disposeBag)

        input.secondButtonTapped
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let currentState = try? owner.secondButtonStateSubject.value()

                switch currentState {
                case .unChecked:
                    owner.secondButtonStateSubject.onNext(.checked)
                    owner.firstButtonStateSubject.onNext(.unChecked)
                    owner.chestModelStateSubject.onNext(.machine)
                case .checked:
                    owner.secondButtonStateSubject.onNext(.unChecked)
                    owner.chestModelStateSubject.onNext(.all)
                case .none:
                    break
                }
            }).disposed(by: disposeBag)

        input.getChestData
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.useCase.getArmData()
            }).disposed(by: disposeBag)

        return output
    }

    private func bindOutput(output: Output) {
        useCase.categoryArmData
            .subscribe(onNext: { partData in
                self.chestDataSubject.onNext(partData)
            }).disposed(by: disposeBag)
    }
}
