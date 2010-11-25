Haskell Tagging
===============

1. Come up with regex rules to tag your data and use:

        mkRules :: [PCREOption] -> [ (RegexStr, [Tag]) ] -> Rules

2. Tag your data by specifying how to extract the part to run against regex rules

        mkTaggedWrt :: [PCREExecOption] -> Rules -> [a] -> (a -> Str) -> Tagged a

        -- example
        data Tran = Tran { ttype::TType, date::Date, proccessed::Date, msg::Msg, amt::Amt }
        mkTaggedWrt [] rules trans msg

3. Filter your data according to tags:

        withTag :: Tag -> Tagged a -> Tagged a
        withoutTag :: Tag -> Tagged a -> Tagged a
        withAnyTag :: [Tag] -> Tagged a -> Tagged a

4. (Optional) Make sure your tags are good:

        untagged :: Tagged a -> [a]
        unusedTags :: Rules -> Tagged a -> [Tag]
        usedTags :: Tagged a -> [Tag]
