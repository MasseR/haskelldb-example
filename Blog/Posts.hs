{-# LANGUAGE EmptyDataDecls, TypeSynonymInstances, TemplateHaskell #-}
{-# OPTIONS_GHC -fcontext-stack44 #-}
module Blog.Posts where

import Database.HaskellDB.DBLayout
import Database.HaskellDB.CodeGen
mkDBDirectTable "Posts" [
    ("id", [t|Int|])
  , ("author", [t|String|])
  , ("title", [t|String|])
  , ("content", [t|String|])
  ]
