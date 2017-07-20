//
//  ViewController.swift
//  HCLinkPreview
//
//  Created by Lebron on 20/07/2017.
//  Copyright © 2017 hacknocraft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    let urlString = "https://twitter.com/KidFromTheIsles/status/596761535541694464"

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.startAnimating()

        HCOGDataFetcher.fetchOData(urlString: urlString) { (_, data) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            print(data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
