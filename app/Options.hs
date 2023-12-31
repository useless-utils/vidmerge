module Options
  ( Opts(..)
  , execParser
  , prefs
  , showHelpOnEmpty
  , optsParser
  , optsParserInfo ) where

import Options.Applicative
    ( (<**>),
      Alternative((<|>)),
      prefs,
      showHelpOnEmpty,
      execParser,
      Parser,
      ParserInfo,
      action,
      fullDesc,
      header,
      help,
      hidden,
      info,
      infoOption,
      long,
      metavar,
      progDesc,
      short,
      strArgument,
      strOption,
      switch )


import Options.Applicative.Extra ( helperWith )

import Version ( versionStr, progName )

data Opts = Opts
  { optInputFile1    :: FilePath
  , optInputFile2    :: FilePath
  , optMatchShortest :: Bool
  , optVersion       :: String -> String
  , optVerbose       :: Bool
  }

optsParser :: Parser Opts
optsParser
  = Opts
  <$> (inputFile1OptParser <|> fileOptParser)
  <*> (inputFile2OptParser <|> fileOptParser)
  <*> matchShortestOptParser
  <*> versionOptParse
  <*> verboseOptParse

fileOptParser :: Parser FilePath
fileOptParser
  = strArgument
  $ metavar "FILE"
  <> help "Input video part, in order"
  <> action "file"

inputFile1OptParser :: Parser FilePath
inputFile1OptParser
  = strOption
  $ long "file1"
  <> short '1'
  <> metavar "FILE"
  -- <> value ""
  <> help "Input video file first part"

inputFile2OptParser :: Parser FilePath
inputFile2OptParser
  = strOption
  $ long "file2"
  <> short '2'
  <> metavar "FILE"
  -- <> value ""
  <> help "Input video file second part"

matchShortestOptParser :: Parser Bool
matchShortestOptParser
  = switch
  $ long "match-shortest"
  <> short 's'
  <> help "Use shortest match of the overlapping portion between the input videos."

versionOptParse :: Parser (a -> a)
versionOptParse =
  infoOption versionStr
  $ long "version"
  <> short 'V'
  <> help "Display the version number"

verboseOptParse :: Parser Bool
verboseOptParse
  = switch
  $ long "verbose"
  <> short 'v'
  <> help "Show debug messages"

optsParserInfo :: ParserInfo Opts
optsParserInfo = info (optsParser <**> helper')
  $ fullDesc
  <> progDesc "Automatically merge videos using matching md5 checksums from frames."
  <> header (progName ++ " - " ++ "Merge videos using framemd5")

helper' :: Parser (a -> a)
helper' = helperWith
          $ long "help"
          -- <> help "Show this help text"
          <> hidden  -- don't show in help messages
