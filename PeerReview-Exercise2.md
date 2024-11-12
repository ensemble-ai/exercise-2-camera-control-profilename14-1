# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Charlie Edwards
* *email:* credwards@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
They implemented the positon lock camera and the cross overlay without any flaws.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
They implemented the auto scrolling camera without any flaws, including boundary checks and I especially liked their use of an autoscroll function that moved the camera and player at the same time to keep them synced.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Implemented the position lock and lerp smoothing camera without any flaws. Again, I liked their use of functions within the camera to better consolidate the code. 

___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Implemented lerp smoothing target focus without any flaws. I liked their logic in _physics_process to determine when to start the catchup timer and in the future I would like to use that idea. 

___
### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Implemented 4-way speedup push zone flawlesly. Their use of booleans made the logic explicitely clear.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
* [Excesive whitespace](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/position_lock.gd#L33) - Found here and in auto_scroll.gd
* [Should be 2 empty lines between functions](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/auto_scroll.gd#L47) - This infraction is also present in lerp_follow.gd

* [Private variables not prefixed with a _](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/position_lock.gd#L25) - They followed this pattern throughout the project

* [Use of ! instead of not](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/target_focus.gd#L28) - Used here in target_focus.gd and in push_zone.gd

#### Style Guide Exemplars ####
* [Good use of screaming snake case on a const](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/position_lock.gd#L5)

* [Included a _ prefix for a private function](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/auto_scroll.gd#L48)

___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
* I do not think there are any notable best practice infractions. This was a well done project.
#### Best Practices Exemplars ####
* [Good use of comments](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/position_lock.gd#L24) - Used comments to explicitely describe what positive and negative values represented here and in all other camera scripts.
* [Use of functions](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/auto_scroll.gd#L48) - Consolidating these similar lines of code into a function increases the readability. Does a similar thing in lerp_follow.gd

* [Use of booleans](https://github.com/ensemble-ai/exercise-2-camera-control-profilename14-1/blob/78a0d6e0e44677b0f371dda404ea89419f41ba8e/Obscura/scripts/camera_controllers/push_zone.gd#L28) - Good use of booleans made the functionality of the code explicitely clear