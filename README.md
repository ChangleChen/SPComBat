# SPComBat
### Superpixel-ComBat Modeling: A Joint Approach for Harmonization and Characterization of Inter-Scanner Variability in T1-Weighted Images

--------
**Maintainer**: Chang-Le Charles Chen, chc348@pitt.edu

**Licenses**: 
- Matlab code: MIT License

**References**: Please cite our [paper](https://direct.mit.edu/imag/article/doi/10.1162/imag_a_00306/124455) if you are using this method or its extension for image harmonization or characterization of inter-scanner variability. https://direct.mit.edu/imag/article/doi/10.1162/imag_a_00306/124455

<div id='id-section1'/>
  
## Introduction
T1-weighted imaging holds wide applications in clinical and research settings; however, the challenge of inter-scanner variability arises when combining data across scanners, which impedes multi-site research. To address this, post-acquisition harmonization methods such as statistical or deep learning approaches have been proposed to unify cross-scanner images. Nevertheless, how inter-scanner variability is manifested in images and the derived measures, and how to harmonize it in an interpretable manner, remains underexplored. To broaden our knowledge of inter-scanner variability and leverage it to develop a new harmonization strategy, we proposed a pipeline to assess the interpretable inter-scanner variability in matched T1-weighted images across MRI scanners. The pipeline incorporates ComBat modeling with 3D superpixel parcellation algorithm (namely SP-ComBat), which estimates location and scale effects to quantify the shift and spread in relative signal distributions, respectively, concerning brain tissues in the image domain. We implemented this harmonization strategy involving proper image preprocessing and site effect removal by ComBat-derived parameters, achieving substantial improvement in image quality and significant reduction in variation of volumetric measures of brain tissues. This approach can also be applied to evaluate and characterize the performance of various image harmonization techniques, demonstrating a new way to assess image harmonization. Briefly, this framework demonstrates a pipeline that extends the implementation of the statistical ComBat method to the image domain for characterizing and harmonizing the inter-scanner variability in T1-weighted images in an interpretable manner, providing further insight for the studies focusing on the development of image harmonization methodologies (especially deep learning-based methods) and their applications.
The application of SPComBat for unmatched T1-weighted images (i.e. without traveling subjects across sites) is under development and validation.

<div id='id-section2'/>
  
## Software implementation
The proposed method is an extension of [ComBat harmonization](https://github.com/Jfortin1/ComBatHarmonization/tree/master), which has been currently implemented using Matlab. The Python version of our method is under development.

![The proposed framework](https://github.com/ChangleChen/SPComBat/blob/main/fig1.jpg)




