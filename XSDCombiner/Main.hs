-- TODO: Make this file generate classes straight away

-- Tool for combining multiple XSD's in one governing file.
-- Useful for use against the xsd.exe from Visual Studio and other class generating tools.

import System.IO
import System.Environment
import System.Directory
import Data.Text
import Data.Map

outputFile :: FilePath
outputFile = "combined.xsd"

xsdFolderContents :: IO [FilePath]
xsdFolderContents = getDirectoryContents "xsds"

headerString :: String -> String
headerString namespace 
    = "<xsd xmlns='http://microsoft.com/dotnet/tools/xsd/'>\
        \\n    <generateClasses language='CS' namespace='" ++ namespace ++ "'>\n"

footerString :: String
footerString 
    = "    </generateClasses>\
        \\n</xsd>"


main :: IO ()
main = do

    args <- getArgs :: IO [FilePath]
    compileOutputFile $ args !! 0
    putStr $ "De XSD bestanden zijn gecompileerd tot het bestand: " ++ outputFile
        ++ "\nGebruik het command:\n xsd.exe /p:" ++ outputFile ++ " /classes\
        \\nOm het bestand te gebruiken.\n\n"


compileOutputFile :: String -> IO ()
compileOutputFile namespace
    = writeFile outputFile (buildOutputFile namespace)


buildOutputFile :: String -> String
buildOutputFile namespace 
    = (appendHeader namespace) ++ (appendBody filePaths) ++ appendFooter
        where filePaths = xsdFolderContents


appendHeader :: String -> String
appendHeader namespace = headerString namespace


appendFooter :: String
appendFooter = "\n" ++ footerString


appendBody :: IO [FilePath] -> String
appendBody filePaths = mapM $ appendBodyLine filePaths


appendBodyLine :: IO FilePath -> String
appendBodyLine filePath = show $ filePath 