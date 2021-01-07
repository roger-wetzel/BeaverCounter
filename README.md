# Beaver Counter

The card game [Biberbande](https://www.amigo-spiele.de/spiel/biberbande) is the same game as [Rat-a-Tat Cat](https://gamewright.com/product/Rat-a-Tat-Cat), but has been re-themed and is distributed throughout Europe.

The game is played in six rounds. At the end of each round, the values of each player's four cards are added up and recorded. The winner is the player who has the lowest total score at the end of the six rounds.

The Beaver Counter app (iOS) does the counting and writing down for you.

![Screenshot](https://roger-wetzel.github.io/images/beaver_counter-1.png)
![Screenshot](https://roger-wetzel.github.io/images/beaver_counter-2.png)

## Implementation Details

1. An object recognizer was created with [Create ML](https://developer.apple.com/machine-learning/create-ml/). Create ML comes with Xcode (see Xcode > Open Developer Tool > Create ML). The model (`Detector.mlmodel`) recognizes the different playing cards. The complete Create ML project can be found [here](https://www.dropbox.com/s/r909p8awld3ee2l/create_ml-beaver_counter.dmg?dl=0
) (1.03 GB). But you only need it if you want to customize it. For example, so that it can recognize the cards from [Rat-a-Tat Cat](https://www.boardgamegeek.com/boardgame/3837/rat-tat-cat) instead of the Biberbande cards. You can use the images in folder `Test Data` in the Preview tab to test the model.

1. Apple's [Breakfast Finder sample code](https://developer.apple.com/documentation/vision/recognizing_objects_in_live_capture) was used as the basis for the Beaver Counter app.

## Instructions

The app is self explanatory. See this [tweet](https://twitter.com/roger_wetzel/status/1271125684526686209?s=20).

## Credits

- Background image taken from AMIGO's [Biberbande](https://www.amigo-spiele.de/spiel/biberbande) product page
- Photos of playing cards labeled with [RectLabel](http://rectlabel.com) image annotation tool
- `.gitignore` file created with [gitignore.io](https://gitignore.io)
- `LICENSE` file created with [Choose an open source license](https://choosealicense.com)