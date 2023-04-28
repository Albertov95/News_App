import UIKit

final class NewsListTableViewCell: UITableViewCell {
    
    static let reuseId = "NewsListTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()

    private let viewsIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "views")
        return image
    }()
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    // MARK: - Private methods
    private func setupLayout() {
        setupAvatarImageLayout()
        setupTitleLabelLayout()
        setupViewsImageViewLayout()
        setupViewsCountLabelLayout()
    }
    
    private func setupAvatarImageLayout() {
        contentView.addSubview(avatarImageView)

        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.module).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.module * 13).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: Constants.module * 12).isActive = true
    }
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.halfModule * 4).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.doubleModule).isActive = true
    }
    
    private func setupViewsImageViewLayout() {
        contentView.addSubview(viewsIconImageView)
        
        viewsIconImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        viewsIconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.doubleModule).isActive = true
        viewsIconImageView.widthAnchor.constraint(equalToConstant: Constants.module * 3).isActive = true
        viewsIconImageView.heightAnchor.constraint(equalToConstant: Constants.module * 3).isActive = true
    }
    
    private func setupViewsCountLabelLayout() {
        contentView.addSubview(viewsCountLabel)
        
        viewsCountLabel.leadingAnchor.constraint(equalTo: viewsIconImageView.trailingAnchor, constant: Constants.halfModule).isActive = true
        viewsCountLabel.centerYAnchor.constraint(equalTo: viewsIconImageView.centerYAnchor).isActive = true
    }
    
    // MARK: - Internal
    func configure(item: Article) {
        titleLabel.text = item.title
        
        if let imageData = item.imageData {
            avatarImageView.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: item.imageUrl) { [weak self] data, _, error in
                guard error == nil, let data = data else { return }
                
                DispatchQueue.main.async {
                    self?.avatarImageView.image = UIImage(data: data)
                }
                
                item.imageData = data
            }.resume()
        }
        
        viewsCountLabel.text = "\(item.views)"
    }
}
