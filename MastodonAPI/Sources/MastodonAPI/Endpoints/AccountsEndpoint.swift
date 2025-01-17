// Copyright © 2020 Metabolist. All rights reserved.

import Foundation
import HTTP
import Mastodon

public enum AccountsEndpoint {
    case rebloggedBy(id: Status.Id)
    case favouritedBy(id: Status.Id)
    /// https://docs.joinmastodon.org/methods/mutes/
    case mutes
    case blocks
    case accountsFollowers(id: Account.Id)
    case accountsFollowing(id: Account.Id)
    case followRequests
    /// https://docs.joinmastodon.org/methods/directory/
    case directory(local: Bool)
}

extension AccountsEndpoint: Endpoint {
    public typealias ResultType = [Account]

    public var context: [String] {
        switch self {
        case .rebloggedBy, .favouritedBy:
            return defaultContext + ["statuses"]
        case .mutes, .blocks, .followRequests, .directory:
            return defaultContext
        case .accountsFollowers, .accountsFollowing:
            return defaultContext + ["accounts"]
        }
    }

    public var pathComponentsInContext: [String] {
        switch self {
        case let .rebloggedBy(id):
            return [id, "reblogged_by"]
        case let .favouritedBy(id):
            return [id, "favourited_by"]
        case .mutes:
            return ["mutes"]
        case .blocks:
            return ["blocks"]
        case let .accountsFollowers(id):
            return [id, "followers"]
        case let .accountsFollowing(id):
            return [id, "following"]
        case .followRequests:
            return ["follow_requests"]
        case .directory:
            return ["directory"]
        }
    }

    public var queryParameters: [URLQueryItem] {
        switch self {
        case let .directory(local):
            return [.init(name: "local", value: String(local))]
        default:
            return []
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var requires: APICapabilityRequirements? {
        switch self {
        case .directory:
            return .mastodonForks("3.0.0")
        case .mutes:
            return .mastodonForks(.assumeAvailable) | [
                .pleroma: .assumeAvailable,
                .akkoma: .assumeAvailable,
                .firefish: .assumeAvailable,
                .calckey: .assumeAvailable
            ]
        default:
            return nil
        }
    }

    public var fallback: [Account]? { [] }
}
