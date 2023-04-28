import Foundation

final class Article: Codable {
    let title: String
    let url: URL
    let imageUrl: URL
    let articleDescription: String
    let date: String
    let source: String

    var imageData: Data?
    var views = 0
    
    init(
        title: String,
        url: URL,
        imageUrl: URL,
        fullText: String,
        date: String,
        source: String
    ) {
        self.title = title
        self.url = url
        self.imageUrl = imageUrl
        self.articleDescription = fullText
        self.date = date
        self.source = source
    }
}
