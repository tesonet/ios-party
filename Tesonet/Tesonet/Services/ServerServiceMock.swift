import RxSwift

class ServerServiceMock: ServerService {
    override func retrieveAll() -> Single<[Server]> {
        let json = """
[
    {
        distance: 1020,
        name: "Germany #47"
    },
    {
        distance: 1451,
        name: "Latvia #52"
    },
    {
        distance: 330,
        name: "United States #76"
    },
    {
        distance: 52,
        name: "Lithuania #64"
    },
    {
        distance: 395,
        name: "Lithuania #49"
    },
    {
        distance: 1168,
        name: "Lithuania #64"
    },
    {
        distance 632,
        name: "Germany #68"
    },
    {
        distance: 1080,
        name: "Singapore #48"
    },
    {
        distance: 1946,
        name: "Lithuania #16"
    },
    {
        distance: 934,
        name: "Latvia #89"
    },
    {
        distance: 922,
        name: "United States #59"
    },
    {
        distance: 1739),
        name: "United States #69"
    },
    {
        distance: 683),
        name: "United Kingdom #54"
    },
    {
        distance: 769),
        name: "Lithuania #15"
    },
    {
        distance: 494),
        name: "United Kingdom #47"
    },
    {
        distance: 942),
        name: "Singapore #41"
    },
    {
        distance: 1532),
        name: "Singapore #82"
    },
    {
        distance: 593),
        name: "United Kingdom #62"
    },
    {
        distance: 1995),
        name: "Japan #78"
    },
    {
        distance: 1066),
        name: "Lithuania #89"
    },
    {
        distance: 1399),
        name: "United States #80"
    },
    {
        distance: 273),
        name: "Latvia #89"
    },
    {
        distance: 1243),
        name: "Singapore #65"
    },
    {
        distance: 438),
        name: "Lithuania #84"
    },
    {
        distance: 185),
        name: "United States #76"
    },
    {
        distance: 1943),
        name: "United States #38"
    },
    {
        distance: 107),
        name: "Lithuania #62"
    },
    {
        distance: 1353),
        name: "Latvia #51"
    },
    {
        distance: 840),
        name: "Lithuania #37"
    },
    {
        distance: 282),
        name: "Singapore #91"
    }
]
"""

        guard let data = json.data(using: .utf8) else {
            return Single.just([Server]())
        }

        do {
            let servers = try JSONDecoder().decode([Server].self, from: data)
            RealmStore.shared.add(items: servers)
            return  Single.just(servers)
        } catch {
            return Single.just([Server]())
        }
    }
}
