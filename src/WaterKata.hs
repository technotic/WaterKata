module WaterKata where

  import Data.List

  type Index = Int
  type Value = Int

  type Terrain = [Value]
  type TerrainWithWater = [(Value, Value)]

  data Valley = Valley {
    start :: Int,
    end :: Int,
    maxDepth :: Int
  } deriving Show

  indexes :: [a] -> [Index]
  indexes values = [0..length values - 1]

  indexOfGreaterThanOrEqualTo :: Value -> Index -> [Value] -> Maybe Index
  indexOfGreaterThanOrEqualTo value index values =
    case found of
      [] -> Nothing
      result -> Just (last result)
    where
      indexesToSearch = drop index (indexes values)
      found = foldl (\acc i -> if values!!i >= value then (i : acc) else acc) [] indexesToSearch

  indexOfLargest :: Index -> [Value] -> Index
  indexOfLargest index values =
    foldl (\acc i -> if values!!i > values!!acc then i else acc) index indexesToSearch
    where
      indexesToSearch = drop index (indexes values)

  nextPeak :: Value -> Index -> [Value] -> Maybe Index
  nextPeak value index terrain =
    case indexOfGreaterThanOrEqualTo value index terrain of
      Nothing -> Just (indexOfLargest index terrain)
      Just i -> Just i

  valleyFrom :: Index -> Terrain -> Maybe Valley
  valleyFrom index terrain =
    if index == length terrain - 1 || terrain!!index <= terrain!!(index + 1)
      then Nothing
      else case nextPeak (terrain!!index) (index + 1) terrain of
        Nothing -> Nothing
        Just otherIndex -> Just Valley {start = index, end = otherIndex, maxDepth = min (terrain!!index) (terrain!!otherIndex) }

  valleysIn :: Terrain -> [Valley]
  valleysIn terrain = valleysInAcc terrain 0 []

  valleysInAcc :: Terrain -> Index -> [Valley] -> [Valley]
  valleysInAcc terrain index acc =
    if index == length terrain - 1
      then acc
      else case valleyFrom index terrain of
        Nothing -> valleysInAcc terrain (index + 1) acc
        Just valley -> valleysInAcc terrain (end valley) (valley : acc)

  valleyContainedIn :: [Valley] -> Index -> Maybe Valley
  valleyContainedIn valleys index =
    find (\v -> index >= (start v) && index <= (end v)) valleys

  depthOfWaterAt :: Index -> Terrain -> [Valley] -> Value
  depthOfWaterAt index terrain valleys =
    case (valleyContainedIn valleys index) of
      Nothing -> 0
      Just v -> if maxDepth v - terrain!!index < 0 then 0 else maxDepth v - terrain!!index

  terrainWithWater :: Terrain -> TerrainWithWater
  terrainWithWater terrain = map (\i -> (terrain!!i, depthOfWaterAt i terrain valleys)) (indexes terrain)
    where valleys = valleysIn terrain

  rotate :: [String] -> [String]
  rotate ss = map (\i -> foldl (\acc s -> acc ++ (s!!i):"") "" ss) (reverse (indexes $ ss!!0))

  renderTerrainWithWater :: TerrainWithWater -> String
  renderTerrainWithWater terrain =
    foldl (\acc s -> acc ++ s ++ "\n") "" $ rotate padded
    where
      showChars = \ch i -> concat $ replicate i ch
      columns = map (\v -> (showChars "#" (fst v)) ++ showChars "~" (snd v)) terrain
      tallest = foldl (\acc c -> max acc (length c)) 0 columns
      padded = map (\v -> v ++ showChars " " (tallest - (length v))) columns
