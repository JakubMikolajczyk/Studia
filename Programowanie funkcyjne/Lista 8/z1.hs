import System.IO (isEOF)
import Data.Char

main = myLoop

myLoop = do done <- isEOF
            if done
              then return ()
              else do inp <- getChar
                      putChar (toLower inp)
                      myLoop