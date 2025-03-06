# Fiting_Curve
This code smoothed the trajectory curve to extract features from the motion trajectory.
We use Total Variation to smooth the track curve.
![image](img/smooth_V.png)

Then, using fmincon and the 3rd-order spline fitting curve, a parametric painting curve was found.

Before Iterative
![image](img/fmincon_0.png)

After Iterative
![image](img/fmincon_n.png)
