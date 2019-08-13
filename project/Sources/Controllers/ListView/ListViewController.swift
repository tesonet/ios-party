import UIKit
import SnapKit
import Just

class ServerCell: UITableViewCell {
	static var reuseIdentifier = "ServerCellReuseIdentifier"
	private var _server: Server? = nil
	
	private func setup() {
		self.backgroundView = UIView()
		self.backgroundColor = Color.tableViewBackground
		self.backgroundView?.backgroundColor = Color.tableViewBackground
		
		if let font = UIFont(name: "HelveticaNeue-Light", size: 13.0) {
			textLabel?.font = font
			detailTextLabel?.font = font
		}
		
		textLabel?.textColor = .black
		detailTextLabel?.textColor = .black
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	var server: Server? {
		set {
			_server = newValue
			textLabel?.text = _server?.name ?? ""
			
			if let distance = _server?.distance {
				detailTextLabel?.text = "\(distance)"
			}
		}
		
		get {
			return _server
		}
	}
}

class ListViewController: UIViewController {
	var token: String? = nil
	private var _servers: [Server] = []
	
	@IBOutlet var _tableView: UITableView!
	weak var _btnSort: SortButton? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.translatesAutoresizingMaskIntoConstraints = true

		_tableView.delegate = self
		_tableView.dataSource = self
		
		_tableView.backgroundView = UIView()
		_tableView.backgroundColor = Color.tableViewBackground
		_tableView.backgroundView?.backgroundColor = Color.tableViewBackground
		
		let itemLeft = UIBarButtonItem(image: UIImage(named: "logo-dark")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
		itemLeft.isEnabled = false
		self.navigationItem.leftBarButtonItem = itemLeft
		let itemRight = UIBarButtonItem(image: UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logout))
		self.navigationItem.rightBarButtonItem = itemRight
		
		// register header view
		
		_tableView?.register(UINib(nibName: "HeaderView", bundle: .main), forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifer)
		
		// load sort button from xib
		
		if let btnSort = XibLoader.loadViewFromXib(name: "SortButton", type: SortButton.self) as? SortButton {
			self.view.addSubview(btnSort)
			_btnSort = btnSort
			
			btnSort.snp.makeConstraints { (make) in
				make.height.equalTo(50)
				make.width.equalToSuperview()
				make.bottom.equalToSuperview()
			}
			
			_tableView.snp.makeConstraints { (make) in
				make.width.equalToSuperview()
				make.top.equalToSuperview()
				make.left.equalToSuperview()
				make.bottom.equalTo(btnSort.snp.top)
			}
			
			btnSort.addTarget(self, action: #selector(onButtonSort), for: .touchUpInside)
		}
		
		loadServers()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	
	@objc func logout() {
		debugPrint(#function)
		StorageHelper.saveToken(nil)
		self.navigationController?.pop()
	}
	
	@objc func onButtonSort() {
		showSortMenu()
	}
	
	private func loadServers() {
		guard let token = self.token, let listUrl = URL(string: TSURL.listUrl) else {
			return
		}
		
		_servers.removeAll()
		
		let headers : [String : String] = ["Content-Type" : "application/json", "Authorization" : "Bearer \(token)"]
		
		Just.request(.get, url: listUrl, headers: headers) { [weak self] (result: HTTPResult) in
			if let respData = result.content {
				do {
					let jsonResponse = try JSONSerialization.jsonObject(with: respData, options: [])
					
					if let arrServers = jsonResponse as? [[String: Any]] {
						debugPrint(arrServers)
						
						for s in arrServers {
							if let name = s[Server.Keys.name.rawValue] as? String, let distance = s[Server.Keys.distance.rawValue] as? Int {
								let server = Server(name: name, distance: distance)
								self?._servers.append(server)
							}
						}
						
						DispatchQueue.main.async {
							self?._tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
						}
					}
				}
				catch let error {
					debugPrint(error.localizedDescription)
				}
			}
			else if let error = result.error {
				debugPrint(error.localizedDescription)
			}
		}
	}
	
	private func showSortMenu() {
		debugPrint(#function)
		
		_btnSort?.isHidden = true
		let ctrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		weak var s = self
		
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("By Distance", comment: ""), style: .default , handler: { (action: UIAlertAction) in
			debugPrint(action.title ?? "")
			s?._servers.sort { $0.distance < $1.distance }
			
			DispatchQueue.main.async {
				s?._btnSort?.isHidden = false
				s?._tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			}
		}))
	
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("Alphanumerical", comment: ""), style: .default , handler: { (action: UIAlertAction) in
			debugPrint(action.title ?? "")
			s?._servers.sort { $0.name < $1.name }
			
			DispatchQueue.main.async {
				s?._btnSort?.isHidden = false
				s?._tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			}
		}))
		
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action: UIAlertAction) in
			debugPrint(action.title ?? "")
			
			DispatchQueue.main.async {
				s?._btnSort?.isHidden = false
			}
		}))
		
		ctrl.view.backgroundColor = .clear
		self.present(ctrl, animated: true)
	}
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource
{
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
	{
		return 50
	}
	
	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
	{
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifer) as? HeaderView
		header?.tintColor = .white
		return header
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return _servers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		var cell: ServerCell! = tableView.dequeueReusableCell(withIdentifier: ServerCell.reuseIdentifier) as? ServerCell
		
		if cell == nil {
			cell = ServerCell(style: .value1, reuseIdentifier: ServerCell.reuseIdentifier)
		}
		
		let server = _servers[indexPath.row]
		cell.server = server
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		debugPrint(#function)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
	{
		debugPrint(#function)
		return false
	}
}
