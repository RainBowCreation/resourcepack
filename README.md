# resourcepack

resourcepack for RainBowCreation Server support versions 1.8+

![Alt](https://repobeats.axiom.co/api/embed/4de7cbb82f484e975e09d961b81600b9f04261f6.svg "Repobeats analytics image")

# What is the goal of this pack?

This resourcepack will hight compatibility in RainBowCreation's network servers.
We will also make the game with 1.8 atmostheric lastest version of minecraft,
for older version please goto old branch

``git clone https://github.com/RainBowCreation/resourcepack.git``

``chmod +x *.sh``

## to compress (required zip)

``./run.sh``

### you can use args to compress specific version

``./run.sh <version>``

ex. ``./run.sh v1_20`` to build compressed 1.20+ resourcepack

the compressed file are located at directort ``target/``

## to validate the compressed file (required unzip, curl)

first pull latest zip.

``./pull_validator.sh``

then you can validate the compressed using

``./validate.sh``
