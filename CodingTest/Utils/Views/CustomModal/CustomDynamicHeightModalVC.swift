//
//  CustomDynamicHeightModalVC.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

class CustomDynamicHeightModalVC: UIViewController {
    
    private weak var delegate : ModalVCDelegate?
    private let group = DispatchGroup()
    public var contentView: ModalContainerView!
    
    var initialContainerViewFrame: CGRect = .zero
    var initialPanGestureOrigin: CGPoint = .zero
    
    /// Constants
    private var defaultHeight: CGFloat = 0.0
    private var dismissibleHeight: CGFloat = 200
    private var maximumContainerHeight: CGFloat {
        return self.view.bounds.height * 0.8
    }
    
    // keep current new height, initial is default height
    private  var currentContainerHeight: CGFloat = 0
    private let maxDimmedAlpha: CGFloat = 0.7
    private var cancelHasAction:Bool? = nil
    private var containerBackgroundColor: UIColor = .white
    
    /// Dynamic container constraint
    private var containerViewBottomConstraint: NSLayoutConstraint?
    /// Flag on Background Touch
    private var closeOnBackgroundTouch: Bool = true
    private var isPanGestureEnable: Bool = true
    
    //MARK: - View Lifecycle -
    
    init(view: ModalContainerView, delegate: ModalVCDelegate? = nil,cancelHasAction:Bool? = nil,closeOnBackgroundTouch: Bool = true, containerBackgroundColor: UIColor? = .white, isPanGestureEnable: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.contentView = view
        self.delegate = delegate
        self.cancelHasAction = cancelHasAction
        self.closeOnBackgroundTouch = closeOnBackgroundTouch
        self.containerBackgroundColor = containerBackgroundColor ?? .white
        self.isPanGestureEnable = isPanGestureEnable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = containerBackgroundColor
        view.roundedCorners(corners: [.topLeft , .topRight], radius: 30.0)
        view.clipsToBounds = true
        return view
    }()
    
    private  lazy var dimmedView: UIControl = {
        let view = UIControl()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        addDimmedView()
    }
    
    func bindViewModel() {
        self.contentView.dismissWith = { [weak self] vm in
            self?.animateDismissView {
                self?.delegate?.dismissWith(vm)
            }
        }
    }
    
    func setupUI() {
        self.view.layoutIfNeeded()
        self.view.backgroundColor = App.Color.dimmedColor
        if self.closeOnBackgroundTouch{
            self.dimmedView.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
            
        }
        
        if isPanGestureEnable {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            containerView.addGestureRecognizer(panGesture)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupConstraintForBottomToTopAnimatate(subView: self.contentView)
        self.animateShowDimmedView()
        self.animatePresentContainer()
    }
    
    
    @objc private func handleCloseAction() {
        animateDismissView {
            if let action = self.cancelHasAction {
                self.delegate?.dismissWith(.cancel(action: action))
            }else{
                self.delegate?.dismissWith(.cancel())
            }
        }
    }
    
    //  Pangesture for sliding and dismiss the containerView
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initialContainerViewFrame = containerView.frame
            initialPanGestureOrigin = gesture.translation(in: containerView)
        case .changed:
            let translation = gesture.translation(in: containerView)
            
            // Check if the vertical displacement is positive (dragging downwards)
            guard translation.y - initialPanGestureOrigin.y > 0 else {
                return // Dragging upwards, so return without performing any actions
            }
            
            let deltaY = translation.y - initialPanGestureOrigin.y
            var newFrame = initialContainerViewFrame
            newFrame.origin.y += deltaY
            containerView.frame = newFrame

        case .ended, .cancelled:
            let translation = gesture.translation(in: containerView)
            if translation.y > containerView.bounds.height / 2 { // Adjust this threshold as needed
                dismissViewController()
            } else {
                resetBottomView()
            }
        default:
            break
        }
    }
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.frame.origin.y = self.view.bounds.height
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    private func resetBottomView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.frame = self.initialContainerViewFrame
        }
    }
}


//MARK: - setupConstraints

extension CustomDynamicHeightModalVC {
    
    private func addDimmedView() {
        self.view.addSubview(self.dimmedView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: self.dimmedView.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: self.dimmedView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: self.dimmedView.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: self.dimmedView.bottomAnchor),
        ])
    }
    
    /// set bottom constant
    private func setupConstraintForBottomToTopAnimatate(subView: ModalContainerView) {
        self.defaultHeight = maximumContainerHeight
        containerView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: subView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.heightAnchor.constraint(lessThanOrEqualToConstant: self.maximumContainerHeight),
        ])
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: self.defaultHeight)
        
        // Activate constraints
        containerViewBottomConstraint?.isActive = true
        view.layoutIfNeeded()
        self.animateShowDimmedView()
        self.animatePresentContainer()
    }
}

// MARK: Present and dismiss animation

extension CustomDynamicHeightModalVC {
    private  func animatePresentContainer() {
        self.containerViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        self.dimmedView.alpha = self.maxDimmedAlpha
    }
    
    private func animateDismissView( closure:@escaping () -> Void){
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.defaultHeight = 0
            self.dismiss(animated: false) {
                closure()
            }
        }
        // hide main view by updating bottom constraint in animation block
        self.containerViewBottomConstraint?.constant = self.defaultHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
