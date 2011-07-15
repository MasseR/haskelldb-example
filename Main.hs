module Main where

import Database.HDBC
import Database.HDBC.Sqlite3
import Control.Monad
import Database.HaskellDB
import Time
import qualified Blog.Posts as P
import qualified Blog.Comments as C

createDb conn = do
  forM_ [posts, comments] $ \a -> handleSqlError $ quickQuery' conn a []
  where
    posts = "CREATE TABLE posts (id INTEGER PRIMARY KEY AUTOINCREMENT, author NOT NULL, date NOT NULL, title NOT NULL, content NOT NULL)"
    comments = "CREATE TABLE comments (id INTEGER PRIMARY KEY AUTOINCREMENT, email NOT NULL, comment NOT NULL, post, foreign key (post) references Post(id))"

addPost db postid email comment = insert db C.comments $
    C.xid << _default
  # C.email <<- email
  # C.comment <<- comment
  # C.post <<- postid

savePost db author title content = do
  now <- toCalendarTime =<< getClockTime
  insert db P.posts $
      P.xid << _default
    # P.author <<- author
    # P.createDate <<- now
    # P.title <<- title
    # P.content <<- content

getAllPosts db = query db $ table P.posts

getTopNPosts db n = do
  p <- query db $ do
    posts <- table P.posts
    top n
    project $ (P.title << posts!P.title)
  return $ map (\r -> r!P.title) p

postsComments db = query db $ do
  posts <- table P.posts
  comments <- table C.comments
  restrict $ (posts!P.xid .==. comments!C.post)
  project $
      P.title << posts!P.title
    # C.email << comments!C.email
    # C.comment << comments!C.comment

main = do
  conn <- connectSqlite3 ":mem:"
  createDb conn
