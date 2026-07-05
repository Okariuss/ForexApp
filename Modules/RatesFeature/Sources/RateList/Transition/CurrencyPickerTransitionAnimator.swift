//
//  CurrencyPickerTransitionAnimator.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
final class CurrencyPickerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isForward = true

    func transitionDuration(
        using _: (any UIViewControllerContextTransitioning)?
    ) -> TimeInterval {
        if UIAccessibility.isReduceMotionEnabled {
            RateListAnimation.reducedMotionDuration
        } else {
            RateListAnimation.screenTransitionDuration
        }
    }

    func animateTransition(
        using context:
        any UIViewControllerContextTransitioning
    ) {
        if UIAccessibility.isReduceMotionEnabled {
            fadeAnimation(using: context)
        } else if isForward {
            pushAnimation(using: context)
        } else {
            popAnimation(using: context)
        }
    }
}

private extension CurrencyPickerTransitionAnimator {
    func pushAnimation(
        using context:
        any UIViewControllerContextTransitioning
    ) {
        guard
            let source =
            context.viewController(forKey: .from)
                as? RateListViewController,
                let destination =
                context.viewController(forKey: .to)
                    as? CurrencyPickerViewController
        else {
            context.completeTransition(false)
            return
        }

        preparePushDestination(
            destination,
            using: context
        )

        guard let elements = makePushElements(
            source: source,
            destination: destination,
            containerView: context.containerView
        ) else {
            fadeAnimation(using: context)
            return
        }

        runPushAnimation(
            elements,
            using: context
        )
    }

    func makePushElements(
        source: RateListViewController,
        destination: CurrencyPickerViewController,
        containerView: UIView
    ) -> PushTransitionElements? {
        guard
            let destinationCell =
            destination.selectedCurrencyCell(),
            let snapshot =
            source.currencyCodeSnapshot()
        else {
            return nil
        }

        return PushTransitionElements(
            source: source,
            destination: destination,
            destinationCell: destinationCell,
            snapshot: snapshot,
            sourceFrame: source.currencyCodeFrame(
                in: containerView
            ),
            destinationFrame:
            destinationCell.currencyCodeFrame(
                in: containerView
            )
        )
    }

    func runPushAnimation(
        _ elements: PushTransitionElements,
        using context:
        any UIViewControllerContextTransitioning
    ) {
        elements.snapshot.frame = elements.sourceFrame
        context.containerView.addSubview(
            elements.snapshot
        )

        elements.source.setCurrencyCodeAlpha(0)
        elements.destinationCell.setCurrencyCodeAlpha(0)

        elements.destination.view.alpha = 0
        elements.destination.view.transform =
            horizontalTransform(
                width: context.containerView.bounds.width
            )

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: .zero,
            usingSpringWithDamping: RateListAnimation.springDamping,
            initialSpringVelocity: .zero,
            options: [.curveEaseInOut],
            animations: {
                elements.source.view.transform =
                    self.horizontalTransform(
                        width:
                        -context.containerView.bounds.width
                    )
                elements.destination.view.alpha = 1
                elements.destination.view.transform = .identity
                elements.snapshot.frame =
                    elements.destinationFrame
            },
            completion: { _ in
                elements.snapshot.removeFromSuperview()
                elements.source.setCurrencyCodeAlpha(1)
                elements.destinationCell
                    .setCurrencyCodeAlpha(1)
                elements.source.view.transform = .identity
                elements.destination.view.transform = .identity

                context.completeTransition(
                    !context.transitionWasCancelled
                )
            }
        )
    }

    func preparePushDestination(
        _ viewController: CurrencyPickerViewController,
        using context:
        any UIViewControllerContextTransitioning
    ) {
        viewController.loadViewIfNeeded()
        viewController.view.frame =
            context.finalFrame(for: viewController)

        context.containerView.addSubview(
            viewController.view
        )

        viewController.navigationController?
            .view.layoutIfNeeded()
        viewController.view.layoutIfNeeded()

        viewController.prepareCurrencyTransition()

        viewController.navigationController?
            .view.layoutIfNeeded()
        viewController.view.layoutIfNeeded()
    }

    func popAnimation(
        using context:
        any UIViewControllerContextTransitioning
    ) {
        guard
            let source =
            context.viewController(forKey: .from)
                as? CurrencyPickerViewController,
                let destination =
                context.viewController(forKey: .to)
                    as? RateListViewController
        else {
            context.completeTransition(false)
            return
        }

        preparePopDestination(
            destination,
            below: source.view,
            using: context
        )
        source.prepareCurrencyTransition()

        guard let elements = makePopElements(
            source: source,
            destination: destination,
            containerView: context.containerView
        ) else {
            fadeAnimation(using: context)
            return
        }

        runPopAnimation(
            elements,
            using: context
        )
    }

    func makePopElements(
        source: CurrencyPickerViewController,
        destination: RateListViewController,
        containerView: UIView
    ) -> PopTransitionElements? {
        guard
            let sourceCell =
            source.selectedCurrencyCell()
        else {
            return nil
        }

        return PopTransitionElements(
            source: source,
            destination: destination,
            sourceCell: sourceCell,
            snapshot: sourceCell.currencyCodeSnapshot(),
            sourceFrame: sourceCell.currencyCodeFrame(
                in: containerView
            ),
            destinationFrame:
            destination.currencyCodeFrame(
                in: containerView
            )
        )
    }

    func runPopAnimation(
        _ elements: PopTransitionElements,
        using context:
        any UIViewControllerContextTransitioning
    ) {
        elements.snapshot.frame = elements.sourceFrame
        context.containerView.addSubview(
            elements.snapshot
        )

        elements.sourceCell.setCurrencyCodeAlpha(0)
        elements.destination.setCurrencyCodeAlpha(0)

        elements.destination.view.transform =
            horizontalTransform(
                width: -context.containerView.bounds.width
            )

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: .zero,
            usingSpringWithDamping:
            RateListAnimation.springDamping,
            initialSpringVelocity: .zero,
            options: [.curveEaseInOut],
            animations: {
                elements.source.view.transform =
                    self.horizontalTransform(
                        width:
                        context.containerView.bounds.width
                    )
                elements.destination.view.transform = .identity
                elements.snapshot.frame =
                    elements.destinationFrame
            },
            completion: { _ in
                elements.snapshot.removeFromSuperview()
                elements.sourceCell.setCurrencyCodeAlpha(1)
                elements.destination.setCurrencyCodeAlpha(1)
                elements.source.view.transform = .identity
                elements.destination.view.transform = .identity

                context.completeTransition(
                    !context.transitionWasCancelled
                )
            }
        )
    }

    func preparePopDestination(
        _ viewController: RateListViewController,
        below sourceView: UIView,
        using context:
        any UIViewControllerContextTransitioning
    ) {
        viewController.view.frame =
            context.finalFrame(for: viewController)
        viewController.view.layoutIfNeeded()

        context.containerView.insertSubview(
            viewController.view,
            belowSubview: sourceView
        )
    }

    func fadeAnimation(
        using context:
        any UIViewControllerContextTransitioning
    ) {
        guard
            let fromView = context.view(forKey: .from),
            let toView = context.view(forKey: .to),
            let toViewController =
            context.viewController(forKey: .to)
        else {
            context.completeTransition(false)
            return
        }

        toView.frame = context.finalFrame(
            for: toViewController
        )

        if isForward {
            context.containerView.addSubview(toView)
        } else {
            context.containerView.insertSubview(
                toView,
                belowSubview: fromView
            )
        }

        toView.alpha = 0

        UIView.animate(
            withDuration: transitionDuration(using: context),
            animations: {
                fromView.alpha = 0
                toView.alpha = 1
            },
            completion: { _ in
                fromView.alpha = 1
                toView.alpha = 1

                context.completeTransition(
                    !context.transitionWasCancelled
                )
            }
        )
    }

    func horizontalTransform(
        width: CGFloat
    ) -> CGAffineTransform {
        CGAffineTransform(
            translationX: width,
            y: .zero
        )
    }
}

@MainActor
private struct PushTransitionElements {
    let source: RateListViewController
    let destination: CurrencyPickerViewController
    let destinationCell: CurrencyPickerCell
    let snapshot: UIView
    let sourceFrame: CGRect
    let destinationFrame: CGRect
}

@MainActor
private struct PopTransitionElements {
    let source: CurrencyPickerViewController
    let destination: RateListViewController
    let sourceCell: CurrencyPickerCell
    let snapshot: UIView
    let sourceFrame: CGRect
    let destinationFrame: CGRect
}
