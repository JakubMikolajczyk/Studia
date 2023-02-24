import Data.Maybe
import System.IO (isEOF)
import Data.Char

data StreamTrans i o a
     = Return a
     | ReadS (Maybe i -> StreamTrans i o a)
     | WriteS o (StreamTrans i o a)

eof = eof

toLowerStream :: StreamTrans Char Char a
toLowerStream = ReadS f where
    f (Just x) = WriteS (toLower x) toLowerStream
    f (Nothing) = Return eof


runIOStreamTrans :: StreamTrans Char Char a -> IO a
runIOStreamTrans (Return a) = return a
runIOStreamTrans (ReadS f) = do done <- isEOF
                                if done then runIOStreamTrans (f Nothing)
                                        else do c <- getChar
                                                runIOStreamTrans (f (Just c))

runIOStreamTrans (WriteS o c) = do  putChar o
                                    runIOStreamTrans c


main = runIOStreamTrans toLowerStream
