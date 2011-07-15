module Main where

import Database.HaskellDB.FieldType
import Database.HaskellDB.DBSpec.DBInfo
import Database.HaskellDB.DBSpec.DBSpecToDBDirect
import Database.HaskellDB.DBSpec.PPHelpers

dbdescr = DBInfo "Blog" (DBOptions False mkIdentPreserving) [
    TInfo "posts" [
        CInfo "id" (IntT, False) -- numeric and not null
      , CInfo "author" (StringT, False)
      , CInfo "title" (StringT, False)
      , CInfo "content" (StringT, False)
    ]
  , TInfo "comments" [
        CInfo "id" (IntT, False) -- numeric and not null
      , CInfo "email" (StringT, False)
      , CInfo "comment" (StringT, False)
      , CInfo "post" (IntT, False) -- The same type as post id
    ]
  ]

main = dbInfoToModuleFiles "." "Blog" dbdescr
