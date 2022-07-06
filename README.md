# RCSJ Washboard Potential

This script was made for 6.s079 - Classical and Quantum Superconducting Circuits taught in Fall 2020.
The script is a solver for the RCSJ model of a superconducting josephson junction. It helps visualize
applications of different currents vs. the critical current and how the washboard potential tilts.

<img src="doc/example_plot.png" />

The model shows a pendulum analog, where force is related to the current applied and the
pendulum properties correspond to the model constants. 

The mechanical analog for the model is as follows:
$$ml^2\ddot\phi+\Gamma\dot\Phi+mgl\sin\phi=\tau_{applied}$$

Where the moment of inertia is related to the capacitance term as
$ml^2\equiv\dfrac{\Phi_0}{2\pi}C$
, the damping coefficient as 
$\Gamma\equiv\dfrac{\Phi_0}{2\pi R}$
and an analog between the applied torque to driving current, where 
$L=1$, 
$mg=I_c$
and
$\tau_{applied}=F_{drive}\cdot L\equiv\dfrac{\Phi_0}{2\pi}\dfrac{1}{R}$
