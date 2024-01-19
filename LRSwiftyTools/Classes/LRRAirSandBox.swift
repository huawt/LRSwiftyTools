import Foundation
import UIKit
private struct RAirSandBoxConstant {
    static let kASThemeColor = UIColor(white: 0.2, alpha: 1.0)
    static let kASWindowPadding: CGFloat = 20
    static var cellWidth: CGFloat {
        return UIScreen.main.bounds.width - (2 * self.kASWindowPadding)
    }
}
private enum RSFileItemType {
    case up, directory, file
}
private class RSFileItem: NSObject {
    var name: String = ""
    var path: String = ""
    var type: RSFileItemType = .up
    init(name: String, path: String, type: RSFileItemType) {
        self.name = name
        self.path = path
        self.type = type
        super.init()
    }
}
private class RAirSandboxCell: UITableViewCell {
    static let classIdenfifier = String(describing: RAirSandboxCell.self)
    lazy var lbName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .left
        label.frame = CGRect(x: 10, y: 30, width: RAirSandBoxConstant.cellWidth, height: 15)
        label.textColor = .black
        return label
    }()
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = RAirSandBoxConstant.kASThemeColor
        line.frame = CGRect(x: 10, y: 47, width: RAirSandBoxConstant.cellWidth - 20, height: 1)
        return line
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(lbName)
        addSubview(line)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func render(with item: RSFileItem) {
        lbName.text = item.name
    }
}
private class RSViewController: UIViewController {
    var items: [RSFileItem] = []
    var rootPath = NSHomeDirectory()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = RAirSandBoxConstant.kASThemeColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(tableView)
        loadFiles()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewWidth = RAirSandBoxConstant.cellWidth
        let closeButtonHeight: CGFloat = 28.0
        let closeButtonWidth: CGFloat  = 60
        closeButton.frame = CGRect(x: viewWidth - closeButtonWidth - 4,
                                   y: 4,
                                   width: closeButtonWidth,
                                   height: closeButtonHeight)
        var frame = view.frame
        frame.origin.y += (closeButtonHeight + 4)
        frame.size.height -= (closeButtonHeight + 4)
        tableView.frame = frame
    }
    public func loadFiles( path: String? = nil) {
        var files: [RSFileItem] = []
        var targetPath: String? = path
        if let targetPath = targetPath, targetPath != rootPath {
            let file = RSFileItem(name: "🔙..", path: targetPath, type: .up)
            files.append(file)
        } else {
            targetPath = rootPath
        }
        let fm = FileManager.default
        do {
            let paths = try fm.contentsOfDirectory(atPath: targetPath!) as [NSString]
            let targetPath = targetPath! as NSString
            var isDir: ObjCBool = false
            for path in paths {
                if path.lastPathComponent.hasPrefix(".") { continue }
                let fullPath = targetPath.appendingPathComponent(path as String)
                fm.fileExists(atPath: fullPath, isDirectory: &isDir)
                let file = RSFileItem(name: "", path: fullPath, type: .file)
                if isDir.boolValue {
                    file.name = "📁" + " " + (path as String)
                    file.type = .directory
                } else {
                    file.name = "📄" + " " + (path as String)
                    file.type = .file
                }
                files.append(file)
            }
            items = files
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc private  func closeButtonClick() {
        view.window?.isHidden = true
    }
    private func share(file path: String) {
        let url = URL(fileURLWithPath: path)
        let shareController = UIActivityViewController(activityItems: [url],
                                                       applicationActivities: nil)
        shareController.excludedActivityTypes = [
            .postToWeibo,
            .message,
            .mail,
            .print,
            .saveToCameraRoll,
            .copyToPasteboard,
            .postToTencentWeibo,
            .postToFlickr,
            .postToVimeo,
            .assignToContact,
            .addToReadingList
        ]
        if UIDevice.current.model.hasPrefix("iPad") {
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.size.width * 0.5,
                y: UIScreen.main.bounds.size.height,
                width: 10,
                height: 10)
        }
        present(shareController, animated: true, completion: nil)
    }
}
extension RSViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > (items.count - 1) { return }
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        switch item.type {
        case .up:
            loadFiles(path: (item.path as NSString).deletingLastPathComponent)
        case .file:
            share(file: item.path)
        case .directory:
            loadFiles(path: item.path)
        }
    }
}
extension RSViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > (items.count - 1) {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        let cell: RAirSandboxCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: RAirSandboxCell.classIdenfifier) as? RAirSandboxCell {
            cell = reuseCell
        } else {
            cell = RAirSandboxCell(style: .default, reuseIdentifier: RAirSandboxCell.classIdenfifier)
        }
        cell.render(with: item)
        return cell
    }
}
open class RAirSandBoxSwift: NSObject {
  public static let shared = RAirSandBoxSwift()
    var swipeGest: UISwipeGestureRecognizer?
    lazy var window: UIWindow = {
        let window = UIWindow()
        var keyFrame = UIScreen.main.bounds
        keyFrame.origin.y += 64
        keyFrame.size.height -= 64
        window.frame = keyFrame.insetBy(
            dx: RAirSandBoxConstant.kASWindowPadding,
            dy: RAirSandBoxConstant.kASWindowPadding)
        window.backgroundColor = .white
        window.layer.borderColor = RAirSandBoxConstant.kASThemeColor.cgColor
        window.layer.borderWidth = 2.0
        window.windowLevel = UIWindow.Level(rawValue: 1000)
        window.rootViewController = viewController
        return window
    }()
    private lazy var viewController = RSViewController()
    public func enableSwipe() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDetected(gs:)))
        swipeGesture.numberOfTouchesRequired = 1
        UIApplication.shared.keyWindow?.addGestureRecognizer(swipeGesture)
        swipeGest = swipeGesture
    }
    public func disableSwipe() {
        if let swipeGest = swipeGest, let view = swipeGest.view {
            view.removeGestureRecognizer(swipeGest)
        }
    }
    public func showSandboxBrowser () {
        window.isHidden = false
        self.viewController.loadFiles()
    }
    @objc private func onSwipeDetected(gs: UISwipeGestureRecognizer) {
        showSandboxBrowser()
    }
}
