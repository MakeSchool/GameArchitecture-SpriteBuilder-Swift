#Goal for this exercise
John Doe, a former employee of AmazingGames Inc. has been fired for having poor Game Architecture skills. It's your first day on the new job and you have to clean up behind John. The PM is asking you to:

- Replace the blue character with a green one
- Replace the flag with a different color
- Increase the running speed in level 2
- Decrease the running speed in level 3
- Reduce the jump height in all levels
- Add 5 collectible stars to each level, add a label to the screen that displays the amount of collected stars
- Make sure the game looks good on screens with different aspect ratios

You can find the **new** art assets in the NewAssets folder.

#Hints for this exercise

- Use custom properties in SpriteBuilder
- Move game logic into a new Gameplay class, this should have its own scene CCB
- Make level class that all levels use to load in custom properties
- Make use of code connections with `Owner` to connect character, next level button, etc to Gameplay class (use CCBReader.load("CCBName" owner: self))
