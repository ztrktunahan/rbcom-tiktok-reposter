//
//  SaverController.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 02.02.2021.
//

import UIKit
import CoreData
import SPAlert
import BLTNBoard
import Hero

class RepostController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var inAppBackground = UIImageView()
    let repostTitle = UILabel()
    let repostSubtitle = UILabel ()
    let dirrectButton = UIImageView ()

    
    let database = Database.shared
    let settings = Settings.shared

    let bulletinManager = BulletinManager()
    
    var blockOperations: [BlockOperation] = []
    var shouldReloadCollectionView: Bool = false
    
    var sortDescriptor: NSSortDescriptor {
        get {
            switch settings.mediaSort {
            case MediaSort.byNew.rawValue: return NSSortDescriptor(key: "date", ascending: false)
            case MediaSort.byOld.rawValue: return NSSortDescriptor(key: "date", ascending: true)
            default: return NSSortDescriptor(key: "date", ascending: false)
            }
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<Post> {
        get {
            
            if _fetchedResultsController != nil {
                return _fetchedResultsController!
            }
            
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
                        
            fetchRequest.fetchBatchSize = 20
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: database.context,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
            _fetchedResultsController?.delegate = self
            
            do {
                try _fetchedResultsController?.performFetch()
                collectionView.reloadData()
            } catch let error {
                print(error.localizedDescription)
            }
                        
            return _fetchedResultsController!
        }
        set {
            _fetchedResultsController = newValue
        }
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Post>? = nil
        
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //bulletinManager.delegate = self
    
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        //NotificationCenter.default.addObserver(self, selector: #selector(copyClipboard), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        
        
        inAppBackground.image = UIImage(named: "main_image")
        inAppBackground.frame = CGRect(x: 0.2 * screenWidth, y: 0.29 * screenHeight, width: 0.6 * screenWidth, height: 0.3 * screenHeight)
        view.addSubview(inAppBackground)
        
        
        dirrectButton.image = UIImage (named: "img_repost")
        dirrectButton.frame = CGRect(x: 0.65 * screenWidth, y: 0.22 * screenHeight, width: 0.22 * screenWidth, height: 0.1 * screenHeight)
        view.addSubview(dirrectButton)
    
        
        
        
        let postCount = fetchedResultsController.sections?.first?.numberOfObjects
        if postCount == 0 {
            inAppBackground.isHidden = false
            repostTitle.isHidden = false
            repostSubtitle.isHidden = false
            dirrectButton.isHidden = false
            
            
        }
        else
        {
            inAppBackground.isHidden = true
            repostTitle.isHidden = true
            repostSubtitle.isHidden = true
            dirrectButton.isHidden = true
            
        }
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
           
            
            let postCount = fetchedResultsController.sections?.first?.numberOfObjects
            if postCount == 0 {
                inAppBackground.isHidden = false
                repostTitle.isHidden = false
            }
            else
            {
                inAppBackground.isHidden = true
                repostTitle.isHidden = true
                
            }
            
        }
        
        let backgroundView = UIView()
        //backgroundView.frame =  CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 414 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.backgroundColor = UIColor(red: 0.24, green: 0.15, blue: 0.24, alpha: 1.00)
        backgroundView.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 1.4
        backgroundView.frame = CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 1 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        view.addSubview(backgroundView)
        
        collectionView.frame = CGRect(x: 0 * screenWidth, y: 0.05 * screenHeight, width: 1 * screenWidth, height: 0.95 * screenHeight)
        collectionView.contentInset = UIEdgeInsets(top: 0.1 * screenHeight, left: 0, bottom: 0, right: 0)
        
        
        let backgroundTitle = UILabel()
        backgroundTitle.textColor = .white
        backgroundTitle.text = NSLocalizedString("Repost", comment: "")
        backgroundTitle.textAlignment = .center
        backgroundTitle.font = UIFont(name: "AvenirNext-Bold", size: 25 * stringMultiplier)
        backgroundTitle.frame = CGRect(x: 0.05 * screenWidth, y: 0.050 * screenHeight, width: 0.9 * screenWidth, height: 0.071 * screenHeight)
        view.addSubview(backgroundTitle)
      
        let settingsButton = UIButton()
        settingsButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        settingsButton.setBackgroundImage(UIImage(named: "btn_settings"), for: UIControl.State.normal)
        settingsButton.frame = CGRect(x: 0.068 * screenWidth, y: 0.070 * screenHeight, width: 0.060 * screenWidth, height: 0.028 * screenHeight)
        settingsButton.contentVerticalAlignment.self = .center
        settingsButton.contentHorizontalAlignment.self = .center
        settingsButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20 * stringMultiplier)
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked), for: UIControl.Event.touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        deleteButton.setBackgroundImage(UIImage(named: "btn_trash"), for: UIControl.State.normal)
        deleteButton.frame = CGRect(x: 0.868 * screenWidth, y: 0.070 * screenHeight, width: 0.060 * screenWidth, height: 0.028 * screenHeight)
        deleteButton.contentVerticalAlignment.self = .center
        deleteButton.contentHorizontalAlignment.self = .center
        deleteButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20 * stringMultiplier)
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: UIControl.Event.touchUpInside)
        /*
        let centerIcon = UIImageView ()
        centerIcon.image = UIImage(named: "img_tiktokicon")
        centerIcon.frame = CGRect (x: 0.435 * screenWidth, y: 0.64 * screenHeight, width: 0.108 * screenWidth, height: 0.033 * screenHeight)
        view.addSubview(centerIcon)
        */
        let addplusButton = UIButton ()
        addplusButton.setBackgroundImage(UIImage(named: "btn_plus"), for: UIControl.State.normal)
        addplusButton.frame = CGRect (x: 0.735 * screenWidth, y: 0.79 * screenHeight, width: 0.3 * screenWidth, height: 0.2 * screenHeight)
        view.addSubview(addplusButton)
        addplusButton.addTarget(self, action: #selector(addplusButtonClicked), for: UIControl.Event.touchUpInside)
    
        repostTitle.textColor = .black
        repostTitle.text = NSLocalizedString("There is no Repost yet!", comment: "")
        repostTitle.textAlignment = .left
        repostTitle.font = UIFont(name: "AvenirNext-Medium", size: 16 * stringMultiplier)
        repostTitle.frame = CGRect(x: 0.1 * screenWidth, y: 0.7 * screenHeight, width: 0.5 * screenWidth, height: 0.1 * screenHeight)
        view.addSubview(repostTitle)
        
        
        repostSubtitle.text = NSLocalizedString("I. Copy Link to repost.\nII. Push + Button\nIII. Paste Link", comment: "")
        repostSubtitle.textAlignment = .left
        repostSubtitle.textColor = .black
        repostSubtitle.numberOfLines = 0
        repostSubtitle.frame = CGRect(x: 0.1 * screenWidth, y: 0.78 * screenHeight, width: 0.6 * screenWidth, height: 0.1 * screenHeight)
        view.addSubview(repostSubtitle)
        
        navigationController?.isNavigationBarHidden = true
        
    
    }
    @objc func addplusButtonClicked () {
    
    performSegue(withIdentifier: "toReposting", sender: nil)
    }
      
    
    
    @objc func settingsButtonClicked() {
        performSegue(withIdentifier: "toSettings", sender: nil) }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.once {
            //copyClipboard()
        }
        
        if !settings.isPremium {
            showPremium()
        }
        
        let postCount = fetchedResultsController.sections?.first?.numberOfObjects
        if postCount == 0 {
            inAppBackground.isHidden = false
            repostTitle.isHidden = false
        }
        else
        {
            inAppBackground.isHidden = true
            repostTitle.isHidden = true
            
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bulletinManager.dismissBulletin()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: Actions

    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        
        guard fetchedResultsController.sections?.first?.numberOfObjects != 0
        else {UIImpactFeedbackGenerator.tapticErrorFeedback();return}
        
        UIImpactFeedbackGenerator.tapticFeedback()
        
        database.deleteCoreDataEntity("Post")
        database.saveContext()
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {print(error.localizedDescription)}
        
        
        
        let postCount = fetchedResultsController.sections?.first?.numberOfObjects
        if postCount == 0 {
            inAppBackground.isHidden = false
            repostTitle.isHidden = false
            repostSubtitle.isHidden = false
        }
        else
        {
            inAppBackground.isHidden = true
            repostTitle.isHidden = true
            repostSubtitle.isHidden = true
        }
        
    }
    /*
    @IBAction func addMediaAction(_ sender: PlusButton) {
        
        if let url = UIPasteboard.general.string, url.contains("tiktok.com") {
            bulletinManager.makeTextFieldPage(with: url)
        } else {
            bulletinManager.makeTextFieldPage(with: "")
        }
        
        bulletinManager.showBulletin(in: self)
        
    }
    */
    // MARK: Private Methods
    
    func topViewController() -> UIViewController {
        
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        
        return self
    }

    /*
    @objc func copyClipboard() {
        
        if bulletinManager.bulletin.isShowingBulletin {
            return
        }
        
        if let url = UIPasteboard.general.string, url.contains("tiktok.com") {
            
            bulletinManager.makeTextFieldPage(with: url)
            bulletinManager.showBulletin(in: self)
            
        }
        
    }
    */
    func deleteMedia(at indexPath: IndexPath) {
        
        let post = (fetchedResultsController.object(at: indexPath))
        
//        try! FileManager.default.removeItem(atPath: "\(post.videoURL!)")

        database.context.delete(post)
        database.saveContext()
        
    }
 
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SettingsSegue" {
            UIImpactFeedbackGenerator.tapticFeedback()
            let nav = segue.destination as? UINavigationController
            let vc = nav?.topViewController as? settingsVC
            
           
        }else if segue.identifier == "toReposting"{

            let destination = segue.destination as! RepostPage
            destination.hero.isEnabled = true
            destination.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .up), dismissing: .slide(direction: .down))
            
        }
        
    }
    
    private func showPremium() {
        
        
    }
    
}

// MARK: - UICollectionViewDataSource

private let collectionViewInset: CGFloat = 10
private let collectionViewSpacing: CGFloat = 10

extension RepostController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo =
                fetchedResultsController.sections?[section] else {return 0}
        return sectionInfo.numberOfObjects
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MediaCell else {return UICollectionViewCell()}

        let post = fetchedResultsController.object(at: indexPath)

        if let imageData = post.imageData {
            cell.imageView.image = UIImage(data: imageData)
        }
        
        if #available(iOS 13.0, *) {
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.addInteraction(interaction)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = collectionView.bounds.width - collectionViewInset
        let screenHigh = view.frame.size.height
        
        var maxCellsInRow: CGFloat = 0
        
        if collectionView.bounds.width > 600 {
            maxCellsInRow = 4
        } else if collectionView.bounds.width > 500 {
            maxCellsInRow = 3
        } else {
            maxCellsInRow = 2
        }
        
        let cellSize = (screenWidth/maxCellsInRow) - collectionViewSpacing
                
        return CGSize(width: cellSize, height: cellSize + 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewInset, left: collectionViewInset, bottom: collectionViewInset, right: collectionViewInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacing
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = fetchedResultsController.object(at: indexPath)
        
        print(post.url)
        if let post = Database.shared.getPost(with: String(post.url!.absoluteString) ){
            post.date = Date()
            LoadingView.removeLoadingView()
            presentPreviewController(with: post)
        }
        
        /*post.date = Date()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewController") as? PreviewController {
            vc.post = post
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true) {
                Database.shared.saveContext()
            }
        }
         */
    }

    
    func presentPreviewController(with post: Post) {
        
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PreviewController") as? PreviewController {
            vc.post = post
//            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            let navigationController = UINavigationController(rootViewController: vc)
            
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true) {
                Database.shared.saveContext()
            }
        }
        
    }
    

   
    
    
    



}

// MARK: - BulletinManagerDelegate

extension RepostController: BulletinManagerDelegate {
    
    func bulletinDismissedWithError() {
        DispatchQueue.main.async {
            SPAlert.present(title: NSLocalizedString("Wrong URL. Try another", comment: ""), preset: .error)
        }
    }
    
    func bulletinOpenInstagramTapped() {
                
        if let url = URL(string: "tiktok://") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension RepostController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            if type == NSFetchedResultsChangeType.insert {
                if (collectionView?.numberOfSections)! > 0 {
                    
                    if collectionView?.numberOfItems( inSection: newIndexPath!.section ) == 0 {
                        self.shouldReloadCollectionView = true
                    } else {
                        blockOperations.append(
                            BlockOperation(block: { [weak self] in
                                if let this = self {
                                    DispatchQueue.main.async {
                                        this.collectionView!.insertItems(at: [newIndexPath!])
                                    }
                                }
                                })
                        )
                    }
                    
                } else {
                    self.shouldReloadCollectionView = true
                }
            }
            else if type == NSFetchedResultsChangeType.update {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                
                                this.collectionView!.reloadItems(at: [indexPath!])
                            }
                        }
                        })
                )
            }
            else if type == NSFetchedResultsChangeType.move {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                            }
                        }
                        })
                )
            }
            else if type == NSFetchedResultsChangeType.delete {
                if collectionView?.numberOfItems( inSection: indexPath!.section ) == 1 {
                    self.shouldReloadCollectionView = true
                } else {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                DispatchQueue.main.async {
                                    this.collectionView!.deleteItems(at: [indexPath!])
                                }
                            }
                            })
                    )
                }
            }
        }
        
        public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            if type == NSFetchedResultsChangeType.insert {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            }
                        }
                        })
                )
            }
            else if type == NSFetchedResultsChangeType.update {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            }
                        }
                        })
                )
            }
            else if type == NSFetchedResultsChangeType.delete {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            }
                        }
                        })
                )
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            
            // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
            if (self.shouldReloadCollectionView) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData();
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView!.performBatchUpdates({ () -> Void in
                        for operation: BlockOperation in self.blockOperations {
                            operation.start()
                        }
                        }, completion: { (finished) -> Void in
                            self.blockOperations.removeAll(keepingCapacity: false)
                    })
                }
            }
        }
    
}

// MARK: - UIViewControllerPreviewingDelegate

extension RepostController: UIContextMenuInteractionDelegate {

    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        let locationInTableView = interaction.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: locationInTableView) else {return nil}
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            
            let linkAction = UIAction(title: NSLocalizedString("Copy link", comment: ""), image: UIImage(systemName: "doc.on.doc")) { _ in
                let post = self.fetchedResultsController.object(at: indexPath)
                if let url = post.url {
                    UIPasteboard.general.string = "\(url)"
                }
                SPAlert.present(title: NSLocalizedString("Copied", comment: ""), preset: .done)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                DispatchQueue.main.async {
                    self.deleteMedia(at: indexPath)
                }
            }
            
            return UIMenu(title: "", children: [linkAction, deleteAction])
        }
        
    }

}

// MARK: - SettingsDelegate


