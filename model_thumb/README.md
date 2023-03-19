# Thumbnail for STL and STEP files 

[Nextcloud forum](https://help.nextcloud.com/t/thumbnail-for-stl-and-step-files/158115)

Install Workflow external scripts and create bash script to generate thumbnail for STL and STEP models.

For generate thumbnail from STL using minirender.
For STEP a temporary STL file is creating by PrusaSlicer.

Notes:
- Thumbnail generating when stl/step file adding or updating.
- Thumbnail generating not immediately. Activating by cron.
- Thumbnail generating for file less than set size.
- Thumbnail not generating if png file already exist.
