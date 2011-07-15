{-# LANGUAGE EmptyDataDecls, TypeSynonymInstances, TemplateHaskell #-}
{-# OPTIONS_GHC -fcontext-stack44 #-}
module Blog.Comments where

import Database.HaskellDB.DBLayout
import Database.HaskellDB.CodeGen
mkDBDirectTable "Comments" [
    ("id", [t|Int|])
  , ("email", [t|String|])
  , ("comment", [t|String|])
  , ("post", [t|Int|])
  ]
