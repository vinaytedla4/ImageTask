//
//  ViewController.swift
//  sampletask
//
//  Created by Vinay on 10/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    var toDoList: [ToDo]?
    @IBOutlet weak var collectionview: UICollectionView?
    var flag : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchingAPI(url: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"){ result in
            self.toDoList = result
            DispatchQueue.main.async {
                self.collectionview?.reloadData()
            }
        }
    }
    
    func fetchingAPI(url: String, completion: @escaping ([ToDo]) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    // Print the JSON response
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    
                    do {
                        let parsingData = try JSONDecoder().decode([ToDo].self, from: data)
                        completion(parsingData)
                    } catch {
                        print("Parsing error: \(error)")
                        
                    }
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    
                }
            }
            dataTask.resume()
        } else {
            print("Invalid URL")
            
        }
    }

}




extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionview?.dequeueReusableCell(withReuseIdentifier: "cellidentifier", for: indexPath) else{
            fatalError("Failed to dequeue a cell with identifier 'vinay' as RecordingCell2")
        }
        if let category = toDoList?[indexPath.row] {
            
            if (isValidImageUrl(category.coverageURL)){
                
                ImageLoader.shared.loadImage(from: category.coverageURL) { image in
                if let cell1 = cell as? RecordingCell2{
                    cell1.photo.image = image
                    
                }
            }
        }
    }
        
        return cell
    }
}

func isValidImageUrl(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString) else { return false }
    return url.pathExtension.lowercased() == "jpg" && ["http", "https"].contains(url.scheme?.lowercased())
}



class ImageLoader {
    static let shared = ImageLoader()
    private var imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self?.imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

