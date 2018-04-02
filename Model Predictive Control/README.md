# Model Predictive Control

Implementation of MPC on a basic system with the following uncontrolled step response.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/StepResponse.png" width="400">

After optimization of the parameters, the model predictive control algorithm will accurately responds on a change in the set point. Left the response, right the taken control action.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/ControlledSystem.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/ControlAction.png" width="400">

The calculations done by the MPC around the change in stepoint are visualised below:

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/t1003.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/t1020.PNG" width="400">

The impact of the parameters m and p is visualised:

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/VariationM.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/Model%20Predictive%20Control/Figures/VariationP.png" width="400">
