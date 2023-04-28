import UIKit

protocol NewsInfoViewDelegate: AnyObject {
    func sourceButtonTapped()
}

final class NewsInfoView: UIView {
    
    weak var delegate: NewsInfoViewDelegate?
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    var date: String? {
        didSet {
            dateLabel.text = date
        }
    }
    
    var source: String? {
        didSet {
            sourceLabel.text = source
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        return text
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let sourceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Source", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.doubleModule
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        setupLayout()
        
        sourceButton.addTarget(self, action: #selector(sourceButtonTapped), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    @objc
    private func sourceButtonTapped() {
        delegate?.sourceButtonTapped()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        setupScrollViewLayout()
        setupTitleLabelLayout()
        setupIconImageViewLayout()
        setupDescriptionLabelLayout()
        setupDateLabelLayout()
        setupSourceLabelLayout()
        setupSourceButtonLayout()
    }

    private func setupScrollViewLayout() {
        addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.doubleModule).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.doubleModule).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.doubleModule).isActive = true
    }
    
    private func setupIconImageViewLayout() {
        contentView.addSubview(iconImageView)
        
        iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.doubleModule * 4).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.halfModule * 75).isActive = true
        iconImageView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - Constants.doubleModule * 2).isActive = true
    }
    
    private func setupDescriptionLabelLayout() {
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.doubleModule).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.doubleModule).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.module * 4).isActive = true
    }
    
    private func setupDateLabelLayout() {
        contentView.addSubview(dateLabel)
        
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.doubleModule).isActive = true
        dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.halfModule * 8).isActive = true
    }
    
    private func setupSourceLabelLayout() {
        contentView.addSubview(sourceLabel)
        
        sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.doubleModule).isActive = true
        sourceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.halfModule * 8).isActive = true
    }
    
    private func setupSourceButtonLayout() {
        contentView.addSubview(sourceButton)
        
        sourceButton.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: Constants.halfModule * 4).isActive = true
        sourceButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        sourceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.module * 2).isActive = true
        sourceButton.widthAnchor.constraint(equalToConstant: Constants.doubleModule * 8).isActive = true
    }
}
