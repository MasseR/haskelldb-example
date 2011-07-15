module Main where

import Database.HDBC
import Database.HDBC.Sqlite3
import Control.Monad

createDb conn = do
  forM_ [posts, comments, tags] $ \a -> handleSqlError $ quickQuery' conn a []
  where
    posts = "CREATE TABLE Post (id INTEGER PRIMARY KEY AUTOINCREMENT, author NOT NULL, date NOT NULL, content NOT NULL)"
    comments = "CREATE TABLE Comment (id INTEGER PRIMARY KEY AUTOINCREMENT, email NOT NULL, comment NOT NULL, post, foreign key (post) references Post(id))"
    tags = "CREATE table Tag (tag, post, foreign key (post) references Post (id))"

main = do
  conn <- connectSqlite3 ":mem:"
  createDb conn
