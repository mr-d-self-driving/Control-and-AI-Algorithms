# PID Control

A standard PID controller is implemented in Simulink and MATLAB. The influence of the different control settings is studied.
<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/PIDcontroller_model.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/PIDcontrollerInfluenceP.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/PIDcontrollerInfluenceI.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/PIDcontrollerInfluenceD.png" width="400">

The PID tuning will perform less optimal if their is a measurement delay.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/controlWithMeasurementDelay.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/controlWithMeasurementDelay.png" width="400">

To efficiently tune the system, control margins are plotted on a BODE-plot for a system of respectively first, second and third order.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/marginFirstOrder.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/marginSecondOrder.png" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/marginThirdOrder.png" width="400">

We will now tune the PID controller. First the state without control.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/PIDTuningNoControl.PNG" width="400">

The open loop response.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/PIDTuningOpenLoop.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/PIDTuningOpenLoop.png" width="400">

And then the calculated optimal PID control.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/PIDTuningControl.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/PIDTuningControl.png" width="400">

Lastly, a PID-feedbackward controller is combined with a feedforward controller. We assume the noise distrubing the system is perfectly characterised. This combination effectively maintains the desire state.

<img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/Simulink%20models/FeedforwardBackward_model.PNG" width="400"><img src="https://github.com/WardQ/Control-and-AI-Algorithms/blob/master/PID%20Control/FeedforwardBackward.png" width="400">
