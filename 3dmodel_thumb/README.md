# Thumbnails (preview) for 3mf, amf, obj, step, stl, x3d 3d-models 

**[Nextcloud forum](https://help.nextcloud.com/t/thumbnail-for-stl-and-step-files/158115)**

Install Workflow external scripts and create bash script to generate thumbnails.

For generate thumbnail from **obj**, **stl** and **x3d** using **[aslze/minirender](https://github.com/aslze/minirender)**.  
For **3mf**, **amf** and **step** temporary **stl** file is creating by **[PrusaSlicer](https://github.com/prusa3d/PrusaSlicer)**.

## Notes:
- Thumbnail generating when stl/step file adding or updating.
- Thumbnail generating not immediately. Activating by cron.
- Thumbnail generating for file less than set size.
- Thumbnail not generating if png file already exist.

<img src="https://github.com/demonlibra/nextcloud/blob/main/3dmodel_thumb/model_thumb_config.png" width="400"> <img src="https://github.com/demonlibra/nextcloud/blob/main/3dmodel_thumb/model_thumb_demo.png" width="400">