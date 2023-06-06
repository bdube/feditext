// Copyright © 2020 Metabolist. All rights reserved.

import Combine
import DB
import Foundation
import Mastodon
import MastodonAPI

public struct ExploreService {
    public let navigationService: NavigationService

    private let mastodonAPIClient: MastodonAPIClient
    private let contentDatabase: ContentDatabase

    init(environment: AppEnvironment, mastodonAPIClient: MastodonAPIClient, contentDatabase: ContentDatabase) {
        self.mastodonAPIClient = mastodonAPIClient
        self.contentDatabase = contentDatabase
        navigationService = NavigationService(environment: environment,
                                              mastodonAPIClient: mastodonAPIClient,
                                              contentDatabase: contentDatabase)
    }
}

public extension ExploreService {
    func fetchTrends() -> AnyPublisher<[Tag], Error> {
        mastodonAPIClient.request(TagsEndpoint.trends)
    }
}
