//
//  ContentView.swift
//  NewsFeed
//
//  Created by Ashwani Kumar on 2020-11-22.
//

import SwiftUI

struct ContentView: View {
    @State private var results = [Article]()
    var body: some View {
        VStack{
            List(results, id:\.publishedAt) { item in
                VStack(alignment: .leading) {
                    Text(item.title).font(.headline)
                    Text(item.author ?? "")
                }
            }
        }
        .onAppear(perform: {
            loadData()
        })
        .navigationTitle("News Feed")
    }
    
    func loadData() -> Void{
        guard let url = URL(string: "http://newsapi.org/v2/everything?q=apple&from=2020-11-22&to=2020-11-22&sortBy=popularity&apiKey=aad88a812b1b432d983b86e75524c7f6") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.articles
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Response: Codable {
    var articles: [Article]
}

struct Article: Codable {
    var title: String
    var author: String?
    var publishedAt: String
}
