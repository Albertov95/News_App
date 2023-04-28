import Foundation

struct ArticleStorage {
    
    static var storedArticles: [Article] {
        if let savedData = UserDefaults.standard.object(forKey: "Articles") as? Data {
            do {
                let savedArticles = try JSONDecoder().decode([Article].self, from: savedData)
                return savedArticles
            } catch {}
        }
        
        return []
    }
    
    static func storeArticles(articles: [Article]) {
        UserDefaults.standard.removeObject(forKey: "Articles")
        
        do {
            let encodedData = try JSONEncoder().encode(articles)
            
            UserDefaults.standard.set(encodedData, forKey: "Articles")
        } catch {}
    }
}
