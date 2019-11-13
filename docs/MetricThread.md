# Metric Thread

![Metric thread specs](http://mdmetric.com/tech/din13pix.jpg)

metric_thread.csv provides the numbers given in the norm (no thinking done there, just copying). metric_thread.awk - as usual - calculates the threadlib specs. 

- Designator: use the simplified variant
- Pitch diameters: Choose the center of the tolerance range
- Support diameters: Center of tol. range
- Valley diameter: Border of tol. range so that overlap with support is assured
- Crest diameters: Center of tol. range

## Specialties

For some internal threads, we get a valley diameter that is on the corner or even outside the fundamental triangle. This would lead to one turn of the thread overlapping with the next turn which we need to avoid. Therefore, we have a built-in check to limit the valley diameter to a safe range.
