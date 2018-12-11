{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.GML.Base

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the foundations of all GML types

-}

-- ------------------------------------------------------------

module CityGML.GML.Base where

import           GHC.Generics
import           Text.XML.HXT.Core

-- | 'GML' provides the most basic interface to the underlying GML data.
--  TODO: metaDataProperty maybe needed? see @7.2.2.8 of the GML specification
data GML = GML
    {   gid         :: Maybe String  -- ^ TODO: should be changed to a ID type
    ,   name        :: [CodeType]    -- ^ List of domain-specific names.
    ,   description :: Maybe String  -- ^ Optional description of the element.
    -- metaDataProperty
    } deriving (Read, Show, Eq, Generic)

{- | As stated in the GML specification:
    This is a generalized type to be used for a term, keyword or name. It adds a
    XML attribute codeSpace to a term, where the value of the (optional)
    codeSpace should indicate a dictionary, thesaurus, classification scheme,
    authority, or pattern for the term'CodeType' refers to.

    Note that
    in all cases the rules for the values, including such things as uniqueness
    constraints, are set by the authority responsible for the codeSpace.
-}
data CodeType = CodeType
    {   value     :: String         -- ^ The actual name of the element.
    ,   codeSpace :: Maybe String   -- ^ The semantical space to which the name refers.
    } deriving (Read, Show, Eq, Generic)


instance XmlPickler GML where
    xpickle = xpGML

instance XmlPickler CodeType where
    xpickle = xpCodeType


-- | Prickler for the base _GML abstract element.
-- See 7.2.2.2 of GML Specification.
xpGML :: PU GML
xpGML = xpWrap      ( uncurry3 GML
                    , \ g -> (gid g, name g, description g)
                    ) $

        xpTriple    (xpOption $ xpAttr "gml:id"             xpText      )
                    (xpList   $ xpElem "gml:name"           xpCodeType  )
                    (xpOption $ xpElem "gml:description"    xpText      )


-- | Prickler for the CodeType abstract property, i.e. gml:codeType.
-- See 7.3.2.5 of GML Specification.
xpCodeType :: PU CodeType
xpCodeType =    xpWrap  ( uncurry CodeType
                        , \ t -> (value t, codeSpace t)
                        ) $

                xpPair  xpText
                        (xpOption $ xpAttr "codeSpace" xpText)
