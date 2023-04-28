struct ResponseResult: Codable {
    
    struct ArticleResult: Codable {
        
        struct Source: Codable {
            let name: String?
        }
        
        let source: Source?
        let title: String?
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: String?
    }
    
    let articles: [ArticleResult]
}
