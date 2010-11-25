module Data.Tag where

import Text.Regex.PCRE.Light
import qualified Data.ByteString.Char8 as B
import Data.List
import Data.Maybe

--------------------------------------------------------------------------------
-- Tag Lib
--------------------------------------------------------------------------------
-- Types
type Str = B.ByteString
type RegexStr = Str
type Tag = Str
type Tagged a = [(a,[Tag])]
type Rules = [(Regex, [Tag])]

-- Creation
mkRules :: [PCREOption] -> [ (RegexStr, [Tag]) ] -> Rules
mkRules opts rs = map (\(r, ts) -> (compile r opts, ts)) rs
mkRules1 = mkRules []

getTags :: [PCREExecOption] -> Rules -> Str -> [Tag]
getTags opts rs x = nub $ concat $ mapMaybe (\(r,ts) -> match r x opts >> Just ts) rs

mkTaggedWrt :: [PCREExecOption] -> Rules -> [a] -> (a -> Str) -> Tagged a
mkTaggedWrt opts rs xs f = zip xs $ map (getTags opts rs . f) xs

-- Analysis
allTags :: Rules -> [Tag]
allTags = nub . concatMap snd

untagged :: Tagged a -> [a]
untagged = map fst . filter ((== []) . snd)

usedTags :: Tagged a -> [Tag]
usedTags = nub . concatMap snd

unusedTags :: Rules -> Tagged a -> [Tag]
unusedTags r t = (allTags r) \\ (usedTags t)

-- Filtering
hasTag :: Tag -> (a,[Tag]) -> Bool
hasTag t (_,ts) = t `elem` ts

withTag :: Tag -> Tagged a -> Tagged a
withTag t ta = filter (hasTag t) ta

withoutTag :: Tag -> Tagged a -> Tagged a
withoutTag t ta = filter (not . hasTag t) ta

withAnyTag :: [Tag] -> Tagged a -> Tagged a
withAnyTag ts ta = filter (\(a,ats) -> ts `intersect` ats /= []) ta
