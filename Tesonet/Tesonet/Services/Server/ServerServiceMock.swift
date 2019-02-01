import RxSwift

class ServerServiceMock: ServerService {
    override func retrieveAllServers() -> Single<[Server]> {
        let json = """
[
    {
        "name": "Singapore #41",
        "distance": 148
    },
    {
        "name": "Latvia #92",
        "distance": 1384
    },
    {
        "name": "Japan #40",
        "distance": 187
    },
    {
        "name": "United Kingdom #54",
        "distance": 1678
    },
    {
        "name": "Latvia #96",
        "distance": 1155
    },
    {
        "name": "Germany #60",
        "distance": 1554
    },
    {
        "name": "Germany #88",
        "distance": 301
    },
    {
        "name": "United Kingdom #53",
        "distance": 1592
    },
    {
        "name": "Latvia #31",
        "distance": 984
    },
    {
        "name": "Japan #21",
        "distance": 1829
    },
    {
        "name": "Lithuania #56",
        "distance": 300
    },
    {
        "name": "Japan #12",
        "distance": 1275
    },
    {
        "name": "Singapore #60",
        "distance": 425
    },
    {
        "name": "Latvia #20",
        "distance": 1673
    },
    {
        "name": "United States #91",
        "distance": 1236
    }
]
"""
        
        guard let data = json.data(using: .utf8) else {
            return Single.just([Server]())
        }
        
        let decoder = JSONDecoder()
        do {
            let servers = try decoder.decode([Server].self, from: data)
            RealmStore.shared.add(items: servers)
            return  Single.just(servers)
        } catch {
            return Single.just([Server]())
        }
    }
}
