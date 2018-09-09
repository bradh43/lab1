//
//  ViewController.swift
//  lab1 Shopping Calculator
//
//  Created by Brad Hodkinson on 9/6/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //create the total price display label
    let totalPriceLabel = UILabel()
    
    //create sales tax text field
    let salesTaxTextField = UITextField()
    
    //enum for textfield type
    enum TextFieldType {
        case price
        case discount
        case tax
    }
	
    //initalizing variables
    var price = 0.0
    var discount = 0.0
    var tax = 0.0
    
    //location manager for determining sales tax
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Calculate delta y for positioning elements customized to the size of the screen
        let deltaY = self.view.frame.maxY/20.0
        
        //change background color
        view.backgroundColor = UIColor(red: 165.0/255.0, green: 20.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        
        //draw the main content of the screen
        //Create shopping calculator label
        let shoppingCalculatorLabel = UILabel()
        createLabel(uiLabel: shoppingCalculatorLabel, labelText: "Shopping Calculator", fontSize:CGFloat(32), bold:false, yLocation:2*deltaY)
        
        //create shopping cart image
        createShoppingCartImageButton(yLocation: 4*deltaY, imageSize: 2*deltaY)
        
        //create original price section
        createOriginalPriceScetion(deltaY: deltaY, fontSize: CGFloat(20.0))
        
        
        //create discount section
        createDiscountSection(deltaY: deltaY, fontSize: CGFloat(20.0))
        
        //create sales tax section
        createSalesTaxSection(deltaY: deltaY, fontSize: CGFloat(20.0))
        
        //create final price section
        createFinalPriceSection(deltaY: deltaY, fontSize: CGFloat(22.0))
        
        //make it to so the keyboard can be dismissed when done edditing by tapping anywhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //make the view have a gesture recognizer listing for taps
        view.addGestureRecognizer(tap)
        
    }
    
    //lock the oritation of the phone into portait mode (refferenced hacking with swift guide)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //check to see if the current device is a phone
        if UIDevice.current.userInterfaceIdiom == .phone {
            //if it is a phone make it only return portait mode
            return .portrait
        } else {
            //any other device make it work with any mode
            return .all
        }
    }
    
    //generic function for creating a label, did not want to copy and paste code over and over again
    func createLabel(uiLabel:UILabel, labelText:String, fontSize:CGFloat, bold:Bool, yLocation:CGFloat){
        //set the text of the welcome label
        uiLabel.text=labelText
        //change the font color to white
        uiLabel.textColor = UIColor.white
        //set the font to the spoecified size
        uiLabel.font = uiLabel.font.withSize(fontSize)
        //check if font should be bold
        if(bold){
            uiLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        }
        //align the text in the center
        uiLabel.textAlignment = .center
        //create the frame for the label
        uiLabel.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/10, width: self.view.frame.width, height: self.view.frame.height)
        //center the text
        uiLabel.center = self.view.center
        //make sure text is always in the center horizontally
        uiLabel.center.x = self.view.center.x
        //position label at specified y location
        uiLabel.center.y = yLocation
        //do not allow auto resizing
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        //add the label to the main view of the app
        self.view.addSubview(uiLabel)
    }

    //generic function for creating a textfield, did not want to copy and paste code over and over again
    func createTextField(textField:UITextField, placeHolder:String, fieldType:TextFieldType, yLocation:CGFloat){
        //set the id for the textfield for later reference to assign the proper variable value(ie. price, discount, tax)
        switch fieldType {
        case TextFieldType.price:
            textField.accessibilityIdentifier = "price"
        case TextFieldType.discount:
             textField.accessibilityIdentifier = "discount"
        case TextFieldType.tax:
             textField.accessibilityIdentifier = "tax"
        }
        //set the place holder text
        textField.placeholder = placeHolder
        //change the font size of the textfield
        textField.font = textField.font?.withSize(20.0)
        //change the background color
        textField.backgroundColor = UIColor.cyan
        //align the text in the center
        textField.textAlignment = .center
        //create the frame for the textfield
        textField.frame = CGRect(x: self.view.frame.width/6, y: self.view.frame.height/8, width: self.view.frame.width/3, height: self.view.frame.height/20)
        //center the text
        textField.center = self.view.center
        //make sure text is always in the center horizontally
        textField.center.x = self.view.center.x
        //position label at specified y location
        textField.center.y = yLocation
        //do not allow auto resizing
        textField.translatesAutoresizingMaskIntoConstraints = false
        //round the edges of the textfield
        textField.layer.cornerRadius = textField.frame.size.width/10
        //set the keyboard type to the number pad
        textField.keyboardType = UIKeyboardType.decimalPad
        //add action to the text field so when ever the text is changed it calls a function
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //add the textfield to the main view
        self.view.addSubview(textField)

    }
    
    //function to update the total cost
    @objc func textFieldDidChange(_ sender: UITextField) {
        //determine which varaible should be updated from the textfield
        //check to make sure the variable can be stored as a double otherwise default it to 0.0
        switch sender.accessibilityIdentifier {
        case "price":
            if (Double(sender.text!) != nil){
                price = Double(sender.text!)!
            } else {
                price = 0.0
                print("Invalid entry for original price")
            }
        case "discount":
            if (Double(sender.text!) != nil){
                discount = Double(sender.text!)!
            } else {
                discount = 0.0
                print("Invalid entry for discount")
            }
        case "tax":
            if (Double(sender.text!) != nil){
                tax = Double(sender.text!)!
            } else {
                tax = 0.0
                print("Invalid entry for tax")
            }
        default:
            print("error determing textfield sender")
        }
        
        //calculate the final price
        let finalPrice = price - (price*(discount/100.0)) + (price*(tax/100.0))
        
        //display the final price
        let displayText = "$\(String(format: "%.2f", finalPrice))"
        totalPriceLabel.text = displayText
    }
    
    //function to create the shopping cart image button
    func createShoppingCartImageButton(yLocation:CGFloat, imageSize:CGFloat){
        //create the UIImage
        var shoppingCartButton = UIButton()
        //create the image to be in the center of the view
        shoppingCartButton = UIButton(frame:CGRect(x: self.view.frame.width/10, y: self.view.frame.height/10, width: imageSize, height: imageSize));
        //position the image in the top center
        shoppingCartButton.center.x = self.view.center.x
        shoppingCartButton.center.y = yLocation
        //fetch the image from the app assets
        let shoppingCartImage = UIImage(named:"shoppingCart")
        //set the button background to the shopping cart image
        shoppingCartButton.setBackgroundImage(shoppingCartImage, for: UIControlState.normal)
        //do not allow auto resizing
        shoppingCartButton.translatesAutoresizingMaskIntoConstraints = false
        //add action to the shopping cart button
        shoppingCartButton.addTarget(self, action: #selector(getLocationSalesTax(_:)), for: UIControlEvents.touchUpInside)
        //add the Wustl Image to the main view of the app
        self.view.addSubview(shoppingCartButton)
    }
    
    //followed YouTube tutorial & referenced the Swift docs to learn location services
    @objc func getLocationSalesTax(_ sender: UIButton){
        //request permission to use location manager when app is open
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //location doesn't have to be super accurate, only care about the current State
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //update the users location
            locationManager.startUpdatingLocation()
        }
    }
    
    //function that is called once the users location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get the first location of the user
        if let location = locations.first {
            //set up GeoCoder for reversing the coordinates to determine the state
            let geoCoder = CLGeocoder()
            //get the state information from the coordinates
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                //get the state
                let currentState = placeMark.administrativeArea as String?
                //get the sales tax for the current state
                let salesTax = self.getSalesTax(state: currentState!)
                //update sales tax text field
                self.salesTaxTextField.text = salesTax
                //update the tax variable used in the final calculation
                self.tax = Double(salesTax)!
                //update the final price
                let finalPrice = self.price - (self.price*(self.discount/100.0)) + (self.price*(self.tax/100.0))
                //display the final price
                let displayText = "$\(String(format: "%.2f", finalPrice))"
                self.totalPriceLabel.text = displayText
            })
        }
        //stop updating the location, helps save the battery of the phone while the app is running
        locationManager.stopUpdatingLocation()
    }
    
    //action lisener for anytime the authorization of the location services is changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if locations services are disabled display an alert pop up
        if(status == CLAuthorizationStatus.denied){
            showLocationDisabledPopUP()
        }
    }
    
    //function to create an alert pop up when location services is disabled
    func showLocationDisabledPopUP() {
        //create an alert to notify user location services is disabled
        let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings to allow sales tax to be determined", preferredStyle: .alert)
        
        //create a cancel action that will dismiss the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add the cancel action to the alert
        alertController.addAction(cancelAction)
        
        //create an open action to open up the location services setting
        let openAction = UIAlertAction(title: "Open Settings", style: .default){ (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        //add the open action to the alert
        alertController.addAction(openAction)
        
        //display the alert to the user
        self.present(alertController, animated: true, completion: nil)
    }
    
    //price to create the original price section
    func createOriginalPriceScetion(deltaY:CGFloat, fontSize:CGFloat){
        //create original price label
        let originalPriceLabel = UILabel()
         createLabel(uiLabel: originalPriceLabel, labelText: "Original Price $", fontSize:fontSize, bold:false, yLocation:6*deltaY)
        
        //create original price text field
        let originalPriceTextField = UITextField()
        createTextField(textField: originalPriceTextField, placeHolder: "0.00", fieldType: ViewController.TextFieldType.price, yLocation: 7*deltaY)
    }
    
    //function to create the discount section
    func createDiscountSection(deltaY:CGFloat, fontSize:CGFloat){
        //create discount label
        let discountLabel = UILabel()
        createLabel(uiLabel: discountLabel, labelText: "Discount %", fontSize:fontSize, bold:false, yLocation:9*deltaY)
        
        //create discount text field
        let discountTextField = UITextField()
        createTextField(textField: discountTextField, placeHolder: "0.0", fieldType: ViewController.TextFieldType.discount, yLocation: 10*deltaY)
    }
    
    //function to create the sales tax section
    func createSalesTaxSection(deltaY:CGFloat, fontSize:CGFloat){
        //create sales tax label
        let salesTaxLabel = UILabel()
        createLabel(uiLabel: salesTaxLabel, labelText: "Sales Tax %", fontSize:fontSize, bold:false, yLocation:12*deltaY)
        
        //create sales tax text field
        createTextField(textField: salesTaxTextField, placeHolder: "0.0", fieldType: ViewController.TextFieldType.tax, yLocation: 13*deltaY)
        
    }
    
    //function to create the final price section
    func createFinalPriceSection(deltaY:CGFloat, fontSize:CGFloat){
        //create final price label
        let finalPriceLabel = UILabel()
        createLabel(uiLabel: finalPriceLabel, labelText: "Final Price", fontSize:fontSize, bold:false, yLocation:15*deltaY)
        
        //create calculated total price label
        createLabel(uiLabel: totalPriceLabel, labelText: "$0.00", fontSize:fontSize, bold:true, yLocation:16*deltaY)
        
    }
    
    //function to dismiss the keyboard
    @objc func dismissKeyboard() {
        //end the editing session allowing the keyboard to be dismissed
        view.endEditing(true)
    }
    
    //function to look up a given state's sales tax
    func getSalesTax(state: String) -> String {
        //set the default sales tax to 0.00
        var salesTax = "0.00"
        //get the path to the file containing the sales tax rates for each state
        let path = Bundle.main.path(forResource: "stateSalesTaxRates", ofType: "txt") // file path for file "data.txt"
        do {
            //store all the text from the file
            let text = try String(contentsOfFile: path!)
            //sperate the state data each time there is a new line into a new array of state data
            let salesTaxData = text.components(separatedBy: "\n")
            //loop throug all the state info in the array of sales tax data
            for stateInfo in salesTaxData {
                //find the current states sales tax
                if(stateInfo.prefix(2) == state){
                    salesTax = String(stateInfo.suffix(4))
                }
            }
        } catch(_){
            print("error")
        }
        return salesTax
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
