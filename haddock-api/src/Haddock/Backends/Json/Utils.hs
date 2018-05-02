module Haddock.Backends.Json.Utils
    where

import           Haddock.Types
import           Haddock.Utils.Json

import           Data.Maybe
import           DynFlags                           (Language(..))
import           GHC                                (Module, moduleUnitId, moduleName, Name)
-- import qualified GHC.LanguageExtensions as LangExt  (Extension)
import           Module                             (moduleNameString)

outputdir :: String
outputdir = "/home/ysd/Haskell/Output"

interfaceToJsonObject :: Interface -> Value
interfaceToJsonObject iface =
    object [
      "module"              .= moduleToJsonObject (ifaceMod iface)
    , "isSignatur"          .= Bool     (ifaceIsSig iface)
    , "originalFileName"    .= String   (ifaceOrigFilename iface)
    , "info"                .= modInfoToJsonObject (ifaceInfo iface)
    , "doc"                 .= Null --DocumentationToJsonValue (ifaceDoc iface)
    ]

moduleToJsonObject :: Module -> Value
moduleToJsonObject module' =
    object [
      "unitId"  .= String (show $ moduleUnitId module')
    , "name"    .= String (moduleNameString $ moduleName module')
    ]

modInfoToJsonObject :: HaddockModInfo Name -> Value
modInfoToJsonObject modInfo =
    object [
      "description" .= Null -- wird nicht im HTML Backend verwendet, wird erstmal ignoriert --hmi_description modInfo
    , "copyright"   .= maybeStringToJsonValue (hmi_copyright modInfo)
    , "license"     .= maybeStringToJsonValue (hmi_license modInfo)
    , "maintainer"  .= maybeStringToJsonValue (hmi_maintainer modInfo)
    , "stability"   .= maybeStringToJsonValue (hmi_stability modInfo)
    , "portability" .= maybeStringToJsonValue (hmi_portability modInfo)
    , "safety"      .= maybeStringToJsonValue (hmi_safety modInfo)
    , "language"    .= maybeLanguageToJsonValue (hmi_language modInfo)
    , "extensions"  .= map (String . show) (hmi_extensions modInfo)
    ]

maybeStringToJsonValue :: Maybe String -> Value
maybeStringToJsonValue = maybe Null String

maybeLanguageToJsonValue :: Maybe Language -> Value
maybeLanguageToJsonValue Nothing            = Null
maybeLanguageToJsonValue (Just Haskell98)   = String "Haskell98"
maybeLanguageToJsonValue (Just Haskell2010) = String "Haskell2010"


-- DocumentationToJsonValue :: Documentation Name -> Value
-- DocumentationToJsonValue doc =
--     object [
--       "" .= fromMaybe (documentationDoc doc)
--     , "" .= (documentationWarning doc)
--     ]