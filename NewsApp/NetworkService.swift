import Foundation

struct NetworkService {
    
    func fetchData(page: Int, completion: @escaping ([ResponseResult.ArticleResult]) -> Void) {
        let urlStr = "https://newsapi.org/v2/everything?q=tesla&sortBy=publishedAt&apiKey=5ca309ae38b14cc38c38a2324dfc3058&pageSize=20" + "&page=\(page)"
        
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(ResponseResult.self, from: data)
                
                completion(result.articles)
            } catch {}
        }
        
        task.resume()
    }
}
