import UIKit

class NewsCollectionViewController: UICollectionViewController {

    private var newsArray = [News]()
    var networkService = NewsNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadNewsAlamofire(){ [weak self ] (news, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let news = news, let self = self else { return }
            self.newsArray = news
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "newsCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? NewsCollectionViewCell else{
            fatalError("The dequeued cell is not an instance of VKTableViewCell.")}
        
        cell.configureNewsCell(with: newsArray[indexPath.row])
        
        return cell
    }
}


extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.view.bounds.width, height: 400)
    }
}
