
import Control.Monad.Trans
import Control.Monad.Trans.State


class Monad m => MonadFresh m where
  -- Tworzy świeżą lokację na stercie. Nowej lokacji nie muszą być
  -- przypisane żadne dane.
  freshLoc :: m Integer

newtype MonadFreshT m a = MonadFreshT { runMonadFreshT :: StateT Integer m a }
 deriving (Functor, Applicative, Monad)

instance Monad m => MonadFresh (MonadFreshT m) where 
    freshLoc = MonadFreshT $ do
        s <- get
        put (s+1) 
        return s

instance MonadTrans MonadFreshT where
    lift c = MonadFreshT $ lift c

e :: MonadFreshT Maybe Integer
e = do
    x <- freshLoc
    y <- freshLoc
    lift $ Just (x + y)

