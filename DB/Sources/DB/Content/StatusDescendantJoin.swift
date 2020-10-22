// Copyright © 2020 Metabolist. All rights reserved.

import Foundation
import GRDB
import Mastodon

struct StatusDescendantJoin: ContentDatabaseRecord {
    let parentId: Status.Id
    let statusId: Status.Id
    let index: Int
}

extension StatusDescendantJoin {
    enum Columns {
        static let parentId = Column(StatusDescendantJoin.CodingKeys.parentId)
        static let statusId = Column(StatusDescendantJoin.CodingKeys.statusId)
        static let index = Column(StatusDescendantJoin.CodingKeys.index)
    }

    static let status = belongsTo(StatusRecord.self, using: ForeignKey([Columns.statusId]))
}