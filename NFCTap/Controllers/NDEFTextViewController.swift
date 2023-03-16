//
//  NDEFTextViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 16/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit

class NDEFTextViewController: ST25UIViewController {

    @IBOutlet weak var textView: UITextView!
    var textViewString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.text = self.textViewString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText(data: String){
       self.textViewString = data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
