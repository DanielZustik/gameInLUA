# justALittleGame

## About
This repository contains the final project I completed in the CS50 course. It is a small platformer game designed in a cyberpunk style, coded in LUA and run by the LOVE2D framework.

## Showcase
[Watch the game showcase on YouTube](https://youtu.be/GP_6mMiB_V0)

## Technology Used
- LUA
- LOVE2D framework

## Detailed Description
The game involves collision detection and resolution of objects, gravity, simple animations, and sounds. As a character, you can run, jump, fire, pick up key-cards, and move other objects.

## Obstacles
The collision detection and resolution logic, which is quite complex and is based on the "How to LOVE" tutorial, presented significant challenges. I had a hard time modifying it without causing breakdowns, especially to make it work for picking up items and similar interactions. To overcome this, I had to implement a workaround by adding an otherwise unnecessary layer. This involved calculating distances and deciding when it was time to destroy an object or pick it up.

## Credits
This game is heavily based on the tutorial ["How to LOVE"](https://sheepolution.com/learn/book/contents) by Sheepolution.
