module Haddock.Backends.Json
    ( ppJson
    ) where

import Haddock.Backends.Json.Utils

import Haddock.Types
import Haddock.Utils.Json

import Data.ByteString.Builder      (hPutBuilder)
-- import Data.Maybe
-- import DynFlags                     (DynFlags)
import System.Directory             (createDirectoryIfMissing)
import System.FilePath              ((</>), (<.>))
import System.IO                    (withFile, IOMode (WriteMode))

-- | Entry point for generating documentation in JSON
ppJson  :: --DynFlags
         String                   -- ^ Title
        -> Maybe String             -- ^ Package
        -> [Interface]              -- ^ interfaces
        -> [InstalledInterface]     -- ^ Reexported interfaces
        -> FilePath                 -- ^ Output directory
        -> IO()
ppJson title package ifaces installedIfaces outDir = do
    putStrLn "generating JSON"

    let
        jsonValue :: Value
        jsonValue = object [
              "title"               .= String   title
            , "package"             .= maybeStringToJsonValue package
            , "Interfaces"          .= Array    (map interfaceToJsonObject ifaces)
            , "InstalledInterfaces" .= String (if (null installedIfaces) then "nothing here" else "there is something")
            ]

    outputStuff jsonValue outDir

outputStuff :: Value -> FilePath -> IO()
outputStuff jsonValue outDir = do
    createDirectoryIfMissing True outDir
    --writeFile
    withFile (outDir </> "test" <.> "json") WriteMode $ \h ->
        hPutBuilder h (encodeToBuilder jsonValue)

-- writeJson :: Value -> IO()
-- writeJson jsonValue = do
--     createDirectoryIfMissing True outputdir
--     withFile (outputdir </> "test" <.> "json") WriteMode $ \h ->
--         hPutBuilder h (encodeToBuilder jsonValue)