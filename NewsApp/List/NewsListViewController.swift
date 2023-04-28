import Foundation
import UIKit

final class NewsListViewController: UIViewController {
    
    private var page = 1
    private var isLoading = false
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = Constants.module * 15
        table.separatorStyle = .none
        return table
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    private var articles: [Article] = []
    
    private let network = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        setupTableView()
        setupTableViewLayout()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        articles = ArticleStorage.storedArticles

        fetchData()
        
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.tableHeaderView = makeTableViewFooter()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.reuseId)
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func fetchData() {
        fetchData(page: page) { [weak self] articles in
            guard let self = self else { return }
            
            guard let articles = articles else {
                DispatchQueue.main.async {
                    self.reloadTableViewData()
                }
                return
            }
            
            if self.page > 1 {
                self.articles += articles
            } else {
                self.articles = articles
            }
            
            ArticleStorage.storeArticles(articles: articles)

            DispatchQueue.main.async {
                self.reloadTableViewData()
            }
        }
    }
    
    private func reloadTableViewData() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
    }

    private func makeTableViewFooter() -> UIView {
        let footerView = UIView(
            frame: .init(
                x: 0,
                y: 0,
                width: view.frame.size.width,
                height: 100
            )
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    @objc
    private func refreshData() {
        fetchData()
    }
}

extension NewsListViewController {
    
    func fetchData(page: Int = 1, completion: @escaping ([Article]?) -> Void) {
        guard !isLoading else { return }
        
        isLoading = true
        
        network.fetchData(page: page) { [weak self] articlesResult in
            var result: [Article] = []
            
            for articleResult in articlesResult {
                if let article = self?.convert(result: articleResult) {
                    result.append(article)
                }
            }
            
            self?.isLoading = false
            
            completion(result)
        }
    }
    
    private func convert(result: ResponseResult.ArticleResult) -> Article? {
        guard let title = result.title,
              let url = URL(string: result.url ?? ""),
              let urlString = result.urlToImage,
              let imageUrl = URL(string: urlString),
              let fullText = result.description,
              let date = ISO8601DateFormatter().date(from: result.publishedAt ?? ""),
              let source = result.source?.name
        else {
            return nil
        }
        
        return Article(
            title: title,
            url: url,
            imageUrl: imageUrl,
            fullText: fullText,
            date: date.description,
            source: source
        )
    }
}

// MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.reuseId) as? NewsListTableViewCell else {
            fatalError("Can not dequeue NewsListTableViewCell")
        }
        
        let item = articles[indexPath.item]
        
        cell.configure(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        article.views += 1
        let vc = NewsInfoViewController(article: article)
        navigationController?.pushViewController(vc, animated: false)
        ArticleStorage.storeArticles(articles: articles)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 80 - scrollView.frame.size.height {
            tableView.tableFooterView = makeTableViewFooter()
            page += 1
            fetchData()
        }
    }
}
