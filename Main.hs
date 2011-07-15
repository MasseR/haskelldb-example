module Main where

import Database.HDBC
import Database.HDBC.Sqlite3
import Control.Monad
import Control.Monad.Trans
import Database.HaskellDB
import Database.HaskellDB.HDBC.SQLite3
import Time
import qualified Blog.Posts as P
import qualified Blog.Comments as C

dbpath = "blog.db"

createDb ::  IConnection conn => conn -> IO ()
createDb conn = do
  forM_ [posts, comments] $ \a -> handleSqlError $ quickQuery' conn a []
  commit conn
  where
    posts = "CREATE TABLE posts (id INTEGER PRIMARY KEY AUTOINCREMENT, author NOT NULL, title NOT NULL, content NOT NULL)"
    comments = "CREATE TABLE comments (id INTEGER PRIMARY KEY AUTOINCREMENT, email NOT NULL, comment NOT NULL, post, foreign key (post) references Post(id))"

addComment postid email comment db = insert db C.comments $
    C.id << _default
  # C.email <<- email
  # C.comment <<- comment
  # C.post <<- postid

savePost author title content db = insert db P.posts $
      P.id << _default
    # P.author <<- author
    # P.title <<- title
    # P.content <<- content

getAllPosts db = query db $ do
  posts <- table P.posts
  project $ copyAll posts

getTopNPosts n db = do
  p <- query db $ do
    posts <- table P.posts
    top n
    project $ copyAll posts
    --project $ (P.title << posts!P.title)
  return $ map (\r -> r!P.title) p

postsComments db = query db $ do
  posts <- table P.posts
  comments <- table C.comments
  restrict $ (posts!P.id .==. comments!C.post)
  project $
      P.title << posts!P.title
    # C.email << comments!C.email
    # C.comment << comments!C.comment

withDb :: MonadIO m => (Database -> m a) -> m a
withDb = sqliteConnect dbpath
main = do
  conn <- connectSqlite3 dbpath
  tables <- getTables conn
  unless (("posts" `elem` tables) && ("comments" `elem` tables)) $ createDb conn
