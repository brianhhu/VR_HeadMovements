# VR Head Movements
Project code and data associated with Hu_etal '17 CISS paper on head movements in virtual reality

### Introduction

The program is written in MATLAB (Mathworks). The code is known to run on R2014a, but should also be compatible with other versions. The main program function is **plot_figs.m**. Running this program will generate the figures shown in the paper. For more details about the experiment or if you plan on using the data, please cite:

    @InProceedings{Hu_etal17a,
    Title                    = {Head movements during visual exploration of natural images in virtual reality},
    Author                   = {Hu, Brian and Johnson-Bey, Ishmael and Sharma, Mansi and Niebur, Ernst},
    Booktitle                = {IEEE CISS-2017 51st Annual Conference on Information Sciences and Systems},
    Year                     = {2017},
    Address                  = {Baltimore, MD},
    Organization             = {IEEE Information Theory Society},
    }


### Natural Image Dataset and Raw Head Movement Data

The natural images used in the experiment can be found in the **images** directory. We used a total of 125 images, with 25 images from each of five categories: buildings (images 0-24), fractals (images 25-49), old home interiors (images 50-74), landscapes (images 75-99), and new home interiors (images 100-124). With the exception of the new home interiors, the images used in the other four categories are the same as those used in previous visual attention studies on eye fixations and interest point selections (Parkhurst et al, '02; Masciocchi et al, '09).

The raw head movement data is contained in the **data** directory. Each subfolder in the directory is named by subject (N = 27 subjects, beginning with subject 0 through subject 26). In each subject folder, there are various files containing the raw head movement data. The important files are:

* imageList.txt
  * This file contains the order in which the images were presented to the subject. Images from each category were presented in a pseudo-random order.
* tutorial.csv
  * This file contains the raw head movement traces during the initial calibration tutorial, where subjects had to orient their heads to nine different targets within a fixed grid. The columns are "Time" (timestamp in milliseconds), "X" (X-position of the head mapped onto a 640x480 image), "Y" (Y-position of the head mapped onto a 640x480 image), and "Event" (a "1" indicates whenever the subject succesfully moved their head to one of the targets).
* image(image_id)data.csv
  * These files contain the raw head movement traces during each image presentation. image_id corresponds to the image number of the presented scene (see Natural Image Dataset section above). If the image was a repeat image, then "repeated" is appended to the filename, i.e. image(image_id)data_repeated.csv. The columns are "Time" (timestamp in milliseconds), "Intersection (X)" (X-position of the head mapped onto a 640x480 image), "Intersection (Y)" (Y-position of the head mapped onto a 640x480 image). We currently do not use the last two columns, "Angle (X and Y)," as these are the visual angles corresponding to the recorded head positions.
* *.WMA
  * These files correspond to audio recordings made during the experiments. Subjects were asked to verbally describe in one sentence what they remembered from the scene after each image presentation. As a fair warning, these files are not well-annotated, so it may be difficult to extract meaningful information from them.

### Post-Processing

We also include our post-processing code (**post_process.m** and **analyze_csv.m**), which generates the post-processed data we used in the paper. The result of these post-processing routines is saved as a structure name "results" in the MATLAB file **results.mat**. The results structure is organized by subject, image category, and image presentation. For example, to get head movement data for the sixth subject viewing the second image category ("fractals") and the fifth image they viewed, use the following: results(6).cat(2).image(5).

### Miscellaneous

If you have any questions about the code or the data, please feel free to contact me at bhu6 (AT) jhmi (DOT) edu.
