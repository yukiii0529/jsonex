//
//  ViewController.swift
//  jsonex
//
//  Created by 田中勇輝 on 2020/12/04.
//  Copyright © 2020 WEB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchText.delegate=self
        searchText.placeholder="キーワードを入力してください"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /**
        UISearchBarの検索ボタンが押された時の処理
     */
    //入力したキーワードをエンコード
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true) //ソフトキーボードを隠す
        print(searchBar.text!)
        if let searchWord = searchBar.text {
            searchProduct(keyword: searchWord) //自作関数
        }
    }
    
    // URLを作成する
    
    var productList : [(maker:String , name:String , link:String , image:String)] = []
    
    func searchProduct(keyword:String){
        self.productList.removeAll()
        let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let URL =  NSURL(string:"http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode!)&max=10&oeder=r")
        
        let urlRequest = URLRequest(url: URL! as URL)
            // JSONを取得
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration,delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: urlRequest,
            completionHandler: {
                (data, response, error) -> Void in //dataにJSONが入る
                //JSON解析の処理
                
                // 再読み込み時(配列をクリアする)
                self.productList.removeAll()
                
                // 解析し配列に格納
                do{
                    let json:Dictionary = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    if let items = json["item"] as? [[String:Any]]{
                        for item in items{
                            guard let maker = item["maker"] as? String else{
                                    continue
                            }
                            guard let name = item["name"] as? String else{
                                    continue
                            }
                            guard let link = item["url"] as? String else{
                                continue
                            }
                            guard let image = item["image"] as? String else{
                                continue
                            }
                            
                            let product = (maker,name,link,image)
                            self.productList.append(product)
                        }
                        self.tableView.reloadData()
                    }
                }catch{
                    print("エラーが発生しました")
                }
            })
            task.resume() //実行
    }
    
    /**
        TableView関連
     */
    
    // 行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection
    section: Int) -> Int {
        return productList.count
    }
    
    // 記載内容を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
    IndexPath) -> UITableViewCell {
        let cell : MyCustomTableViewCell =
        tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! MyCustomTableViewCell
        cell.ProductName?.text = productList[indexPath.row].name // テキストを表示
        cell.MakerName?.text = productList[indexPath.row].maker // テキストを表示
        let url = URL(string: productList[indexPath.row].image)
        if let image_data = try? Data(contentsOf: url!){
            cell.ImageView?.image = UIImage(data: image_data)
        }
        print(productList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: productList[indexPath.row].link){
      UIApplication.shared.open(url) }
    }


}

