import UIKit
import RxSwift
import RxRelay

class AddStoryViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    @IBOutlet weak var openGallery: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var enableLocation: UISwitch!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postStoryBtn: UIButton!
    @IBOutlet weak var scrollableHeight: NSLayoutConstraint!
    
    let vm = AddStoryViewModel()
    var uploadResponse: AddStoryResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelAndDeleteLocation()
    }
    
    private func setup() {
        postStoryBtn.layer.cornerRadius = 8.0
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        locationLabel.addGestureRecognizer(tapGesture)
        scrollableHeight.constant = view.bounds.height + 50
        bindData()
    }
    
    func bindData() {
        vm.addStory.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data {
                self.uploadResponse = validData
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                case .loading:
                    self.addLoading(self.postStoryBtn)
                case .failed:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                    if let error = self.uploadResponse?.message {
                        self.displayAlert(title: "Upload Story Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                    if let message = self.uploadResponse?.message {
                        self.displayAlert(title: message, message: "Please continue to home", completion:  {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        }).disposed(by: bag)
        
        enableLocation.rx.isOn.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            state ? self.locationHandler() : self.cancelAndDeleteLocation()
            self.locationLabel.isHidden = !state
        }).disposed(by: bag)
    }
    
    private func locationHandler() {
        checkLocationAuthorization(map)
        getAddressFromCurrentLocation(lat: latitude, lon: longitude) { _ in
            self.getAddressFromCurrentLocation(lat: self.latitude, lon: self.longitude) { name in
                self.locationLabel.text = name
            }
        }
    }
    
    private func cancelAndDeleteLocation() {
        locationLabel.text = nil
        latitude = 0.0
        longitude = 0.0
    }
    
    private func openPicker(sourceType: UIImagePickerController.SourceType) {
        pickerImage.allowsEditing = true
        pickerImage.delegate = self
        pickerImage.sourceType = sourceType
        if sourceType == .camera { pickerImage.showsCameraControls = true }
        present(pickerImage, animated: true)
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        locationHandler()
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        openPicker(sourceType: .camera)
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        openPicker(sourceType: .photoLibrary)
    }
    
    @IBAction func uploadStory() {
        addLoading(postStoryBtn)
        
        guard let enteredCaption = captionTextField.text, !enteredCaption.isEmpty else {
            displayAlert(title: "Upload Story Failed", message: "Please enter your caption", completion:  {
                self.afterDissmissed(self.postStoryBtn, title: "Post Story")
            })
            return
        }
        guard let uploadedImage = uploadedImage.image else {
            displayAlert(title: "Upload Story Failed", message: "Please select your image", completion:  {
                self.afterDissmissed(self.postStoryBtn, title: "Post Story")
            })
            return
        }
        let lat = (latitude == 0.0) ? nil : Float(latitude)
        let lon = (longitude == 0.0) ? nil : Float(longitude)
        
        vm.postStory(param: AddStoryParam(description: enteredCaption, photo: uploadedImage, lat: lat, lon: lon))
    }
}

extension AddStoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        uploadedImage.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddStoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let triggerOffset: CGFloat = -80

        if yOffset < triggerOffset {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
