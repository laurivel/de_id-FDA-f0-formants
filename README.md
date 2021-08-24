# de_id-FDA-f0-formants
This repository contains R and Praat scripts used in the paper "Improving speaker de-identification with functional data analysis of f0 trajectories" (Tavi, Kinnunen and Gonzalez-Hautamäki, 2021).

The scripts perform functional data analysis for chosen speech signals and de-identify them using fda-based pitch manipulation and simple formant shifts. They are not meant to be executed all at once, rather part by part. Please make sure that you know what you are doing (no quarantee any kind at all, use with your own responsibility).

The following steps are required to perform de-identification:

1)  Adjust and run f0s_fda.R to collect f0 trajectories and to convert them to functional objects. The f0 trajectories must ne collected from de-identified and modelling signals.
2) Adjust and run fPCA_data_points.R in order to create fCPAs and collect coefficients for manipulated f0 trajectories. The type of modelling signals will affect the quality of de-identified signals.
3) Manipulate f0 trajectories using manipulate_pitch_final.praat.
4) Finally, modify formants using formant_shift.praat. You can try different coefficients for the amount of formant shift.

For further details, please see the paper (Tavi, Kinnunen and Gonzalez-Hautamäki, 2021).

To complete above steps, the following plug-ins/libraries are required:

1) Praat: Vocal toolkit:http://www.praatvocaltoolkit.com/
2) R: a) fda: https://cran.r-project.org/web/packages/fda/index.html

      b) PraatR: http://www.aaronalbin.com/praatr/index.html

      c) fda.usc: https://cran.r-project.org/web/packages/fda.usc/index.html
      
      d) tidyverse: https://www.tidyverse.org/
3) YOUR DATA
