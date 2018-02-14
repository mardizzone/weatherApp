import UIKit
import GooglePlaces
import Nuke

class ViewController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var localWeatherLabel: UILabel!
    @IBOutlet var localTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup the autocomplete for the search bar that leverages the Google Places API
        setUpResultsController()
        //load the weather for the most recently searched location
        loadSavedData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

// MARK: - Update UI Methods
extension ViewController {
    func setUpResultsController() {
        //setup the autocomplete for the search bar that leverages the Google Places API
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 25.0, width: 350.0, height: 45.0))
        searchController?.searchBar.barTintColor = UIColor(displayP3Red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    func updateUIAndStoreData(results: WeatherResponse) {
        //update our labels after getting results from the Open Weather API
        let retrievedLocation = results.name
        self.placeLabel.text = retrievedLocation
        let retrievedWeatherDescription = results.weather.first?.main
        self.localWeatherLabel.text = retrievedWeatherDescription
        let roundedTemp = Int(roundf(results.main.temp))
        self.localTemperatureLabel.text = "\(roundedTemp)°"
        self.loadImageIntoView(for: (results.weather.first?.icon)!)
        //store the pertinent information from the open weather API in User Defaults
        PersistenceManager.storeLastSearchedWeatherData(location: retrievedLocation, image: self.weatherImageView.image, temperature: roundedTemp, weatherDescription: retrievedWeatherDescription!)
    }

}

// MARK: - Data Persistence Methods
extension ViewController {
    func loadSavedData() {
        //load the weather for the most recently searched location
        if let location = UserDefaults.standard.object(forKey: "location") as? String {
            self.placeLabel.text = location
        }
        if let temperature = UserDefaults.standard.object(forKey: "temperature") as? Int {
            print(temperature)
            self.localTemperatureLabel.text = "\(temperature)°"
        }
        if let imageData = UserDefaults.standard.object(forKey: "image") as? Data {
            weatherImageView.image = UIImage(data: imageData)
        }
        if let weatherDescription = UserDefaults.standard.object(forKey: "weatherDescription") as? String {
            localWeatherLabel.text = weatherDescription
        }
    }
    
}

// MARK: - Autocomplete Delegate
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        Networking.dataFromWeatherAPI(searchTerm: place.name, completionHandler: { results in
            self.updateUIAndStoreData(results: results)
        })
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // called when error occurrs
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func loadImageIntoView(for iconURL: String) {
        //utilize Nuke framework to load weather icon
        let imageURL =  "http://openweathermap.org/img/w/\(iconURL).png"
        let url = URL(string: imageURL)!
        let request = Request(url: url)
        Manager.shared.loadImage(with: request, into: weatherImageView)
    }
}
