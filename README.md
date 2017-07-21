# WaterKata
A (poor) Haskell solution to the "water on a terrain" problem

## The Problem (reference?)

Given a terrain find the depth water would lie at given it must be contained within peaks in the terrain. The terrain
is described as a sequence of integers which denotes the height of the land at that point. For water to occupy a point it
must be contained within a "valley" in the terrain.

For example a terrain might be [1, 5, 3, 1, 3, 1, 4, 1, 3, 1] which would look like:
```
 #    
 #    #
 ## # # #
 ## # # #
##########
```

If this was filled with water it would look like (where ~ represents water):
```
 #    
 #~~~~#
 ##~#~#~#
 ##~#~#~#
##########
```

## The Solution

The solution contained here is implemented in Haskell. Bear in mind this is my first Haskell program so it's not great.

The algorithm used is to first find all the valleys - those parts of the terrain demarked by peaks - and then works out the 
depth of the water at a given point by checking if the point lies in one of the valleys. If it does then the height is the 
max depth water can be in the valley minus the height of the land. If it is not in a valley then the height is zero.
