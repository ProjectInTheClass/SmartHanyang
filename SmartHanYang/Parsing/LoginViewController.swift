
import UIKit
import WKZombie

class LoginViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton : UIButton!
    
    fileprivate let url = URL(string: "https://m.hanyang.ac.kr/login.page")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        guard let user = nameTextField.text, let password = passwordTextField.text else { return }
        self.setUserInterfaceEnabled(enabled: false)
        login(url, user: user, password: password)
    }
    
    private func setUserInterfaceEnabled(enabled: Bool) {
        nameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
    
    func login(_ url: URL, user: String, password: String) {
        print("username:'\(user)', password:'\(password)'")
        open(url)
            >>> get(by: .id("_username"))
            >>> setAttribute("value", value: user)
            >>> get(by: .id("_password"))
            >>> setAttribute("value", value: password)
            >>> execute("loginProc()")
            === handleResult1
        
    }
    func handleResult1(result: JavaScriptResult?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            execute("document.cookie")
                === self.handleResult2
        }
    }
    
    func handleResult2(result: JavaScriptResult?) {
        if let result = result
        {
            requestData(cookie: result, yoils: [2,3,4,5,6])
        }
    }
    
    func requestData(cookie:String, yoils:[Int])
    {
        for yoil in yoils
        {
            let my_yoil = yoil
            
            let date = Date()
            var cal = Calendar.current
            cal.timeZone = .current
            
            if let url = URL(string: "https://m.hanyang.ac.kr/haksa/sggu/sggu0001001.json?suup_year=\(cal.component(.year, from: Date()))&suup_term=10&yoil=\(my_yoil)&apiUrl%5B%5D=%2FHASA%2FA201300018.json"){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue(cookie, forHTTPHeaderField: "Cookie")
                
                let session = URLSession.shared
                session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
                    if (error) != nil
                    {
                        //print("re-yoil")
                        self.requestData(cookie: cookie, yoils: [my_yoil])
                    }
                    else if returnData != nil
                    {
                        if let str = NSString(data: returnData!, encoding: String.Encoding.utf8.rawValue)
                        {
                            print(str)
                            print("gogo: \(my_yoil)")
                            ParseJson(json: str as String, yoil: my_yoil)
                        }
                    }
                }).resume()
            }
        }
    }
}
