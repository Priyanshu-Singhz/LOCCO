//
//  SlideToActionButton.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 20/02/24.
//

import UIKit

struct Colors {
    static let background = UIColor.appWhite
    static let draggedBackground = UIColor.appWhite
    static let tint = UIColor.appSkyBlue
}

protocol SlideToActionButtonDelegate: AnyObject {
    func didFinish()
}

class SlideToActionButton: UIView {
    
    let handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.draggedBackground
        view.layer.masksToBounds = true
        return view
    }()
    
    let handleViewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ic_slider_car")
        view.contentMode = .scaleAspectFit
        view.tintColor = Colors.tint
        return view
    }()
    
    let draggedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.draggedBackground
        view.layer.cornerRadius = 12
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.tint
        label.font = AppFont.medium(size: 11)
        label.text = "Slide to start LOCCO >>>"
        return label
    }()
    
    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    private var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: SlideToActionButtonDelegate?
    private var currentPadding:CGFloat = 10
    private var xEndingPoint: CGFloat {
        return (bounds.width - (handleView.bounds.width + currentPadding))
    }
    
    private var isFinished = false
    var handleDidFinish:(()->())? = nil
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = Colors.background
        layer.cornerRadius = 12
        addSubview(titleLabel)
        addSubview(draggedView)
        addSubview(handleView)
        handleView.addSubview(handleViewImage)
        
        //MARK: - Constraints
        
        leadingThumbnailViewConstraint = handleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: currentPadding)
        
        NSLayoutConstraint.activate([
            leadingThumbnailViewConstraint!,
            handleView.topAnchor.constraint(equalTo: topAnchor),
            handleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 80),
            draggedView.topAnchor.constraint(equalTo: topAnchor),
            draggedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            draggedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            draggedView.trailingAnchor.constraint(equalTo: handleView.trailingAnchor),
            handleViewImage.topAnchor.constraint(equalTo: handleView.topAnchor, constant: 10),
            handleViewImage.bottomAnchor.constraint(equalTo: handleView.bottomAnchor, constant: -10),
            handleViewImage.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        handleView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished { return }
        let translatedPoint = sender.translation(in: self).x
        switch sender.state {
        case .changed:
            if translatedPoint <= currentPadding {
                updateHandleXPosition(currentPadding)
            } else if translatedPoint >= xEndingPoint {
                updateHandleXPosition(xEndingPoint)
            } else {
                updateHandleXPosition(translatedPoint)
            }
        case .ended:
            if translatedPoint >= xEndingPoint {
                self.updateHandleXPosition(xEndingPoint)
                isFinished = true
                delegate?.didFinish()
                self.handleDidFinish?()
            } else {
                UIView.animate(withDuration: 1) {
                    self.reset()
                }
            }
        default:
            break
        }
    }
    
    private func updateHandleXPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x
    }

    func reset() {
        isFinished = false
        updateHandleXPosition(currentPadding)
    }
}

