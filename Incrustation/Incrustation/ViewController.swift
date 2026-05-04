import UIKit

struct ImageFragment: Codable {
    let image: String
    let position: Int
}

struct ImageData: Codable {
    let items: [ImageFragment]
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAndDisplayImage()
    }
        
    private func setupUI() {
        view.backgroundColor = .white
    }
        
    private func loadAndDisplayImage() {
        guard let jsonData = loadJSONFromFile(named: "images") else {
            print("Failed to load JSON file")
            return
        }
        
        do {
            let imageData = try JSONDecoder().decode(ImageData.self, from: jsonData)
            createCompositeImage(from: imageData.items)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
        
    private func loadJSONFromFile(named filename: String) -> Data? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            return nil
        }
            
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
        
    private func createCompositeImage(from fragments: [ImageFragment]) {
        let n = Int(sqrt(Double(fragments.count)))
        guard n * n == fragments.count else {
            print("Количество фрагментов не образует квадратную матрицу")
            return
        }
        
        let sortedFragments = fragments.sorted { $0.position < $1.position }
        var matrix = [[ImageFragment?]](
            repeating: [ImageFragment?](repeating: nil, count: n),
            count: n
        )
        
        var fragmentIndex = 0
        for d in 0..<(2 * n - 1) {
            var currentRow: Int
            var currentCol: Int
            let isGoingUp = (d % 2 == 0)
    
            if d < n {
                if isGoingUp {
                    currentRow = d
                    currentCol = 0
                } else {
                    currentRow = 0
                    currentCol = d
                }
            } else {
                if isGoingUp {
                    currentRow = n - 1
                    currentCol = d - n + 1
                } else {
                    currentRow = d - n + 1
                    currentCol = n - 1
                }
            }
    
            while currentRow >= 0 && currentRow < n && currentCol >= 0 && currentCol < n {
                if fragmentIndex < sortedFragments.count {
                    matrix[currentRow][currentCol] = sortedFragments[fragmentIndex]
                    fragmentIndex += 1
                }
        
                if isGoingUp {
                    currentRow -= 1
                    currentCol += 1
                } else {
                    currentRow += 1
                    currentCol -= 1
                }
            }
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        for row in 0..<n {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 0
            
            for col in 0..<n {
                if let fragment = matrix[row][col],
                   let image = base64ToImage(fragment.image) {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    rowStackView.addArrangedSubview(imageView)
                } else {
                    let emptyView = UIView()
                    emptyView.backgroundColor = .gray
                    rowStackView.addArrangedSubview(emptyView)
                }
            }
            stackView.addArrangedSubview(rowStackView)
        }
    }
        
    private func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
