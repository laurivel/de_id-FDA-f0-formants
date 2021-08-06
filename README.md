# de_id-FDA-f0-formants
This repository contains R and Praat scripts used in the paper "Improving speaker de-identification with functional data analysis of f0 trajectories".

These scripts perform fda for chosen speech signals and de-identify them using fda-based pitch manipulation and simple formant shifts. The following steps are required to perfor de-identification:

1) Collect f0 trajectories using a Praat script
2) Adjust and run R scripts () in order to create fCPAs and collect coefficients for manipulated f0 trajectories
3) Manipulate f0 trajectories using Praat script
4) Finally, modify formants using Praat script
