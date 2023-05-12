# Robotics-Project
This project simulates an autonomous robot (Differential Drive) that has to avoid certain obstacles to reach a defined goal from a starting point
***

# Goal of this project
After generating an obstacle map, generate a path for the robot to arrive from point A to point B using four different obstacles avoidance techniques (Voronoi map, Visibility graph, potential field and discrete potential field), two different trajectory generation methods (point to point, curve) and model the differential drive posture regulation and trajection tracking procedures.

# How to use this project
Inside this project there are 4 files in the root folder and 3 folders that manage each goal's requirement.
mappa_Ostacoli generates the obstacles course, plotRobot and plotTriangle are used to plot the robot making its way to the goal and the main.m is where the starting point "P_start" and the goal "P_goal" are chosen.
When the main.m files is ran you are asked to insert 4 inputs: 
The first is which obstacle avoidance technique is to be used
- 1 for Visibility graph
- 2 for Potential field
- 3 for Discrete potential field
- 4 for Voronoi map
The second is which type of trajectory generation method is used
- 1 for curved
- 2 for point to point
The third is which kind of trajectory tracking the robot should use
- 1 for linear control
- 2 for non-linear control
- 3 for feedback linearization
And the last one is which kind of posture regulation (they don't have name) the robot should adopt
- 1 for Posture regulation 1 
- 2 for Posture regulation 2
The program will then generate a graph showing the robot following the path chosen.
