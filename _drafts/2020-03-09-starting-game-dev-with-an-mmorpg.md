---
layout: post
title: starting gamedev with a mmorpg
slug: starting-game-dev-with-mmorpg
tags: csharp linux cli netcore ffmpeg
author: Trbl
excerpt: 14 years later, the loop repeats
image: 
thumbnail: 
image-credits: 
size: 3.9k
---

# Pixel

That's the name of the engine/game. Well, it's the name of the engine, the game has no name. The game doesn't
have anything yet. It's built using my own attempt at *ECS*, it's a 2D top down tile engine, it's connected to a server and generats maps using noise algos. I have more ideas than I could realistically write down. But I have to start somewhere.

## the inspiration

Honestly most games are shit. All the AAA industry does is fuck their devs and us gamers. Microtransactions weren't a thing 10 years ago. We UNLOCKED cosmetics and new content through PLAYING. All they did was take the L out of playing. I've been inspired by Kenshi and Rimworld, I'd rank both of them as my two games of the decade. If you haven't heard of them, now is the time to at least check them out. I'll reference them a lot in this post. 

### Kenshi

Kenshi combined RPG with base building/strategy and deep combat through its complex body simulation.
Broken limbs, even cut off limbs (and prosthetics). You'd get stronger by the beatings you survive. 
Like in Elder Scrolls titles, you improve by using a certain skill, just taken to its logical next step -
and it fucking works. If you're ever bored of the great D&D combat, you can start building your own town 
and have people come by to visit and trade with you. If you build camp in territory controled by the 
Holy Nation, they will even send priests on prayer day and you have to pray with them or risk angering them. But rather that annoyance than dealing with random passing herds of animals that might chew through your 
people / crops. If you can't feed your people they will starve and die. 


* stats improve by using them
* food
* complex injury simulation
* lots of roaming squads
* the world is deadly
* soft perma-death

https://www.youtube.com/watch?v=HD1mlWtPWK8

### Rimworld

https://www.youtube.com/watch?v=tfP7BFuEtpY



I want to have a massive world. Something that would take a couple of hours to reach the edge of. Not 
infinite. Why that's very important will become apparent very soon. I want you to imagine *Once the end gets discovered, events start happening enemies arrive, breed/multiply/spread* a medieval town, surrounded by walls
some houses, blacksmith, mage's guild, .. populated by NPCs that have a daily schedule. 