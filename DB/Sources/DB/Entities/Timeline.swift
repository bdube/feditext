// Copyright © 2020 Metabolist. All rights reserved.

import Foundation
import Mastodon

public enum Timeline: Hashable {
    case home
    case local
    case federated
    case list(List)
    case tag(String)
    case profile(accountId: String, profileCollection: ProfileCollection)
}

public extension Timeline {
    static let unauthenticatedDefaults: [Timeline] = [.local, .federated]
    static let authenticatedDefaults: [Timeline] = [.home, .local, .federated]

    enum Item: Hashable {
        case status(StatusConfiguration)
        case loadMore(LoadMore)
    }

    var filterContext: Filter.Context {
        switch self {
        case .home, .list:
            return .home
        case .local, .federated, .tag:
            return .public
        case .profile:
            return .account
        }
    }
}

public extension Timeline.Item {
    struct StatusConfiguration: Hashable {
        public let status: Status
        public let pinned: Bool
        public let isReplyInContext: Bool
        public let hasReplyFollowing: Bool

        init(status: Status, pinned: Bool = false, isReplyInContext: Bool = false, hasReplyFollowing: Bool = false) {
            self.status = status
            self.pinned = pinned
            self.isReplyInContext = isReplyInContext
            self.hasReplyFollowing = hasReplyFollowing
        }
    }
}

extension Timeline: Identifiable {
    public var id: String {
        switch self {
        case .home:
            return "home"
        case .local:
            return "local"
        case .federated:
            return "federated"
        case let .list(list):
            return "list-".appending(list.id)
        case let .tag(tag):
            return "tag-".appending(tag).lowercased()
        case let .profile(accountId, profileCollection):
            return "profile-\(accountId)-\(profileCollection)"
        }
    }
}