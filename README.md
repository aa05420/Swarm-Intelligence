# Swarm-Intelligence


Ant Clustering Simulation:

In this simulation, the ant clustering algorithm is used to display the behavior of ants as they search for and eat from the nearby food sources.

The simulation is based on the following parameters
  1.Number of food sources
  2.Number of ants
  3.Cluster threshold
  4.Ant speed
  5.Ant size
  6.Food size
  7.Food amount

The user can change these parameters through sliders to see how the behavior of ants changes with these values. Moreover, the user can also add ants to the simulation by clicking on the left mouse button.

The Ant class defines the behavior of individual ants.
  -The move() method updates the position of the ant by moving it randomly within a certain speed range.
  -The findCluster() method checks if another ant is within a certain distance and moves the ant towards that ant if it is.
  -The findFood() method checks if the ant is close to a food source and moves the ant towards the food source if it is.

The Food class represents a food object that has a location (x and y coordinates), a size, and an amount.
`-eatFood() reduces the amount of food in the food source by a certain amount Link to youtube video: https://youtu.be/nJ7vS7AGi7M
      ![image](https://github.com/aa05420/Swarm-Intelligence/assets/62726090/9acc6886-4f6e-4188-9986-e712612c8b56)

