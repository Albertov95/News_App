import UIKit

final class NewsInfoViewController: UIViewController {
    
    private let mainView = NewsInfoView()
    private let article: Article
    
    // MARK: - Init
    init(article: Article) {
        self.article = article
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        mainView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        mainView.title = article.title
        mainView.descriptionText = article.articleDescription
        mainView.date = article.date
        mainView.source = article.source
        
        if let imageData = article.imageData {
            mainView.icon = UIImage(data: imageData)
        }
    }
}

// MARK: - NewsInfoViewDelegate
extension NewsInfoViewController: NewsInfoViewDelegate {
    
    func sourceButtonTapped() {
        let vc = WKWebViewController(url: article.url, title: article.source)
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}
