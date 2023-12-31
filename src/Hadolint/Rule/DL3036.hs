module Hadolint.Rule.DL3036 (rule) where

import Hadolint.Rule
import qualified Hadolint.Shell as Shell
import Language.Docker.Syntax


rule :: Rule Shell.ParsedShell
rule = dl3036 <> onbuild dl3036
{-# INLINEABLE rule #-}

dl3036 :: Rule Shell.ParsedShell
dl3036 = simpleRule code severity message check
  where
    code = "DL3036"
    severity = DLWarningC
    message = "`zypper clean` missing after zypper use."

    check (Run (RunArgs args _)) =
      foldArguments (Shell.noCommands zypperInstall) args
        || ( foldArguments (Shell.anyCommands zypperInstall) args
               && foldArguments (Shell.anyCommands zypperClean) args
           )
    check _ = True

    zypperInstall = Shell.cmdHasArgs "zypper" ["install", "in"]
    zypperClean = Shell.cmdHasArgs "zypper" ["clean", "cc"]
{-# INLINEABLE dl3036 #-}
