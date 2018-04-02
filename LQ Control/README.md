# LQ Control

LQ control is implemented using Simulink and MATLAB.

First the situation without control. All variables will go towards their equilibrium values.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/noControl.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/noControl.png" width="400">

With LQ control, the controllable variables (k and v) will go towards the desired value. Uncontrollable variables (s) cannot be controlled.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/LQControl.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/LQControl.png" width="400">

Sometimes, some variables cannot be measered directly. An observer will estimate these values.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/noControlObserver.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/noControlObserver.png" width="400">

The observer can be combined with LQ control.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/LQControlObserver.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/LQControlObserver.png" width="400">

Finally, a reduced order observer can be used as well.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/LQControlReducedObserver.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/LQControlReducedOrderObserver.png" width="400">

To achieve optimal control, the controlmatrix can be optimized (on an other system).

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Simulink%20models/optimalLQControl.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/LQ%20Control/Results/optimalControl.png" width="400">
