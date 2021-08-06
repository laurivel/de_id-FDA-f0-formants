# de_id-FDA-f0-formants
This repository contains R and Praat scripts used in the paper "Improving speaker de-identification with functional data analysis of f0 trajectories".

These scripts perform fda for chosen speech signals and de-identify them using fda-based pitch manipulation and simple formant shifts. The following steps are required to perform de-identification:

1) Collect f0 trajectories using a Praat script
2) Adjust and run R scripts () in order to create fCPAs and collect coefficients for manipulated f0 trajectories
3) Manipulate f0 trajectories using Praat script
4) Finally, modify formants using Praat script


To complete above steps, the following plug-ins/libraries are required:

1) Praat: Vocal toolkit:http://www.praatvocaltoolkit.com/
2) R: a) fda: https://cran.r-project.org/web/packages/fda/index.html
      b) PraatR: http://www.aaronalbin.com/praatr/index.html
      c) fda.usc: https://cran.r-project.org/web/packages/fda.usc/index.html
      d) tidyverse: https://www.tidyverse.org/
