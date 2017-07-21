module WaterKataTests where

  import Test.Hspec
  import Test.QuickCheck
  import Control.Exception (evaluate)

  import WaterKata

  main :: IO()
  main = hspec $ do

    describe "WaterKata" $ do

      it "can handle the simplest terrain" $ do
        terrainWithWater [1]
          == [(1,0)]

      it "can handle the simplest terrain containing water" $ do
        terrainWithWater [2,1,2]
          == [(2,0), (1,1), (2,0)]

      it "can handle a more complex terrain containing water" $ do
        terrainWithWater [1,2,1,3,2,1,3,1]
          == [(1,0),(2,0),(1,1),(3,0),(2,1),(1,2),(3,0),(1,0)]

    describe "Rendered WaterKata" $ do

      it "can handle the simplest terrain" $ do
        renderTerrainWithWater (terrainWithWater [1])
          == "#\n"

      it "can handle the simplest terrain containing water" $ do
        renderTerrainWithWater (terrainWithWater [2,1,2])
          == "#~#\n\
             \###\n"

      it "can handle a more complex terrain containing water" $ do
        renderTerrainWithWater (terrainWithWater [1,2,1,3,2,1,3,1])
          == "   #~~# \n\
             \ #~##~# \n\
             \########\n"
