import UIKit
import SnapKit
import Just

class ServerCell: UITableViewCell {
	static var reuseIdentifier = "ServerCellReuseIdentifier"
	private var _server: Server? = nil
	
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
		
		_tableView.delegate = self
		_tableView.dataSource = self
		
		let itemLeft = UIBarButtonItem(image: UIImage(named: "logo-dark")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
		itemLeft.isEnabled = false
		self.navigationItem.leftBarButtonItem = itemLeft
		let itemRight = UIBarButtonItem(image: UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onLogout))
		self.navigationItem.rightBarButtonItem = itemRight
		
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
	
	@objc func onLogout() {
		print(#function)
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
		
		Just.request(.get, url: listUrl, headers: headers) { result in
			if let respData = result.content {
				if let resp = String(data: respData, encoding: .utf8) {
					print(resp)
				}
				
				do {
					let jsonResponse = try JSONSerialization.jsonObject(with: respData, options: [])
					print(jsonResponse)
					
					if let arrServers = jsonResponse as? [[String: Any]] {
						print(arrServers)
						
						for s in arrServers {
							if let name = s[Server.Keys.name.rawValue] as? String, let distance = s[Server.Keys.distance.rawValue] as? Int {
								let server = Server(name: name, distance: distance)
								self._servers.append(server)
							}
						}
						
						DispatchQueue.main.async {
							self._tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
						}
					}
				}
				catch let error {
					print("Error", error)
				}
			}
			else if let error = result.error {
				print(error.localizedDescription)
			}
		}
	}
	
	private func showOrHideSortButton(show: Bool) {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.2, animations: {
				self._btnSort?.alpha = show ? 1.0 : 0.0
			})
		}
	}
	
	private func showSortMenu() {
		print(#function)
		
		let ctrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("By Distance", comment: ""), style: .default , handler: { (UIAlertAction) in
			print("By Distance")
			self.showOrHideSortButton(show: true)
		}))
	
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("Alphanumerical", comment: ""), style: .default , handler: { (UIAlertAction) in
			print("Alphanumerical")
			self.showOrHideSortButton(show: true)
		}))
		
		ctrl.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (UIAlertAction) in
			print("Cancel")
			self.showOrHideSortButton(show: true)
		}))
		
		ctrl.view.backgroundColor = .clear
		
		showOrHideSortButton(show: false)
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
		return "Header"
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
	{
//		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FMTableViewHeaderViewGroupMembers.reuseIdentifer) as? FMTableViewHeaderViewGroupMembers
//		header?.label.text = NSLocalizedString("Members", comment: "")
//		return header
		return nil
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return _servers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		var cell: ServerCell! = tableView.dequeueReusableCell(withIdentifier: ServerCell.reuseIdentifier) as? ServerCell
		
		if cell == nil {
			cell = ServerCell(style: .subtitle, reuseIdentifier: ServerCell.reuseIdentifier)
		}
		
		let server = _servers[indexPath.row]
		cell.server = server
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		print(#function)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
	{
		print(#function)
		return false
	}
}
