--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Applicative ((<$>))
import           Data.Monoid         (mappend, mconcat)
import           System.FilePath     (dropFileName)
import           Hakyll

import           Sidebar
--------------------------------------------------------------------------------

-- Sitemap is used to generate the navbars
sitemap :: PageTree
sitemap = Tree "/" "Home"
  [ (Page "index.html" "Overview")
  , (Tree "languages"  "Languages" langpages)
  , (Tree "software"   "Software"  softwarepages)
  , (Tree "hardware"   "Hardware"  hardwarepages)
  , (Page "about.html" "About")
  , (Page "news.html"  "News")
  ]
  where
  hardwarepages =
    [ Page "index.html"            "Overview"
    , Group "Air Vehicles"
      [ Page "airvehicle-overview.html" "Overview"
      , Page "airvehicle-genericquad.html" "Generic Quadcopter"
      , Page "airvehicle-ardrone.html" "AR Drone"
      ]
    , Group "Electronics"
      [ Page "flightcontroller.html" "Flight Controller"
      , Page "blackmagic.html"       "Debugger"
      , Page "rc-controller.html"    "Radio Control"
      ]
    , Group "Guides"
      [ Page "shoppinglist.html"     "Shopping List"
      ]
    ]
  softwarepages =
    [ Page "index.html"           "Introduction"
    , Page "properties.html"      "Properties and Evidence"
    , Group "Development"
      [ Page "prerequisites.html"     "Prerequisites"
      , Page "build.html"             "Building"
      , Page "loading.html"           "Loading"
      ]
    , Group "Flight Software"
      [ Page "flight-overview.html"   "Overview"
      , Page "flight-checklists.html" "Flight Checklists"
      , Page "flight-platforms.html"  "Platform Support"
      , Page "flight-components.html" "Software Components"
      , Page "flight-future.html"     "Future Developments"
      ]
    , Group "Ground Control Software"
      [ Page "gcs-overview.html"      "Overview"
      , Page "gcs-commsec.html"       "Communication Security"
      , Page "gcs-smaccm-sik.html"    "SMACCM-SiK Radio"
      , Page "gcs-mavproxy.html"      "MAVProxy"
      , Page "gcs-gamepad.html"       "Gamepad Control"
      ]
    , Group "Communications Security"
      [ Page "commsec-overview.html" "Overview"
      , Page "commsec-encapsulation.html" "Encapsulation"
      , Page "commsec-keyexchange.html" "Key Exchange"
      ]
    ]
  langpages =
    [ Page "index.html"          "Overview"
    , Group "Ivory Language"
      [ Page "ivory-introduction.html" "Introduction"
      , Page "ivory-concepts.html"     "Concepts"
      , Page "ivory-cheatsheet.html"   "Cheatsheet"
      , Page "ivory-tools.html"        "Toolchain"
      , Page "ivory-libs.html"         "Libraries"
      , Page "ivory-fib.html"          "Tutorial"
      ]
    , Group "Tower Language"
      [ Page "tower-overview.html" "Introduction"
      ]
    ]

standardPandocPagesSubdir d = do
    match (fromGlob ("pages/" ++ d ++ "*.md")) $ do
        route   $ gsubRoute "pages/"  (const "") `composeRoutes`
                  setExtension "html"
        compile $ pandocCompiler >>= (templated "templates/standard.html")

config :: Configuration
config = defaultConfiguration { deployCommand = deploy }
  where
  path = "/srv/www/smaccmpilot.org/public_html/"
  server = "cerf.galois.com"
  deploy = "scp -r _site/* " ++ server ++  ":" ++ path
    -- scp sets the group wrong, we need to change all of the items
    -- we own to group smaccm, supressing errors for the items we do not own
    ++ " && ssh " ++ server ++  " chgrp -R -f smaccm "  ++  path
    ++ " ;  ssh " ++ server ++  " chmod -R -f g+w "  ++  path
    ++ " ;  exit 0"

main :: IO ()
main = hakyllWith config $ do

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "artifacts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "bootstrap/css/*" $ do
        route   $ gsubRoute "bootstrap/" (const "")
        compile compressCssCompiler

    match "bootstrap/js/*.js" $ do
        route   $ gsubRoute "bootstrap/" (const "")
        compile copyFileCompiler

    match "jquery/*.js" $ do
        route   $ gsubRoute "jquery/" (const "js/")
        compile copyFileCompiler

    match "bootstrap/img/*" $ do
        route   $ gsubRoute "bootstrap/" (const "")
        compile copyFileCompiler

    match "pages/index.md" $ do
        route   $ gsubRoute "pages/"  (const "") `composeRoutes`
                  setExtension "html"
        compile $ pandocCompiler >>= (templated "templates/frontpage.html")

    match "templates/*" $ compile templateCompiler

    standardPandocPagesSubdir ""
    standardPandocPagesSubdir "hardware/"
    standardPandocPagesSubdir "software/"
    standardPandocPagesSubdir "languages/"


navbar :: FilePath -> String
navbar currentpath = unlines $
  [ "<ul class=\"nav\"> "
  , entry "/index.html"           "Home"
  , entry "/languages/index.html" "Languages"
  , entry "/software/index.html"  "Software"
  , entry "/hardware/index.html"  "Hardware"
  , entry "/about.html"           "About"
  , entry "/news.html"            "News"
  , "</ul>"
  ]
  where
  entry path desc =
    "<li" ++ (emphif path) ++ "><a href=\"" ++ path ++ "\">" ++
    desc ++ "</a></li> "
  emphif path = if under path then " class=\"active\" " else ""
  under path | rootdir path = path == currentpath
             | otherwise    = dropFileName path == dropFileName currentpath
  rootdir path = dropFileName path == "/"

templated :: Identifier -> Item String -> Compiler (Item String)
templated t input = loadAndApplyTemplate t ctx input >>= relativizeUrls
  where
  ctx :: Context String
  ctx = mconcat
    [ field "navbar"    $ \item -> return (navbar (itemFilePath item))
    , field "sidebar"   $ \item -> return (sidebarHTML sitemap item)
    , field "directory" $ \item -> return (itemDirectory item)
    , field "filepath"  $ \item -> return (itemFilePath item)
    , constField "copyright" "<p>&copy; Galois Inc. 2013</p>"
    , defaultContext
    ]

