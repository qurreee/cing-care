# CingCare

A cozy grid-based cat management game about designing the perfect daycare for different cat personalities.

Players arrange facilities such as feeding stations, beds, water bowls, and playgrounds to satisfy cats with unique preferences and behaviors.

---

# Core Gameplay

Each day:

1. Cats arrive at the daycare
2. Cats randomly develop needs
3. Cats move around the facility
4. Cats evaluate the environment based on their personality
5. Player earns score and income based on cat satisfaction

The main challenge is creating layouts that satisfy multiple cats with conflicting preferences.

---

# Main Features

## Grid-Based Building
- Place facilities on a small customizable grid
- Rearrange layouts between days
- Optimize spacing and adjacency

## Personality-Driven Cats
Each cat has:
- weighted needs
- facility preferences
- unique rule reactions

Example:
- One cat dislikes eating near water
- Another cat prefers sleeping near quiet areas
- Playful cats prioritize playgrounds more often

## Dynamic Need System
Cats periodically:
- think
- choose a need
- search for a matching facility
- move and interact with it

## Satisfaction Scoring
Cats evaluate the environment after using a facility.

Scoring can include:
- nearby facilities
- room spacing
- preferred facility types
- future environmental rules

---

# Current Systems

## Implemented
- Grid manager
- Facility placement
- Cat spawning
- Weighted need selection
- Wandering behavior
- Facility usage
- Basic scoring system
- Day phase loop
- Camera drag + zoom

## Planned
- Shop system
- Day rewards
- UI polish
- More facilities
- More personality traits
- Better facility scoring
- Saving/loading
- Visual feedback and animations

---

# Technical Structure

## Main Nodes

### GridManager
Handles:
- grid data
- facility placement
- cell lookup
- world/grid conversion

### CatManager
Handles:
- spawning cats
- daily cat logic
- signals and scoring

### Cat
Handles:
- movement
- needs
- wandering
- thinking
- facility usage

### GameManager
Handles:
- progression
- unlocked facilities
- daily score
- global game state

---

# AI Philosophy

The game does not use complex AI systems.

Instead, cats operate on:
- weighted random needs
- environmental evaluation
- personality-based scoring

This creates emergent behavior while keeping the system lightweight and scalable.

---
