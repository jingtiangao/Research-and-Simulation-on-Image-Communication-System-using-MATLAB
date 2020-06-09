# Research and Simulation on Image Communication System using MATLAB
- Study performance of JPEG image compression and reconstruction algorithm with different com-
pression ratios, the analysis result obtained from the rate-distortion curve is that the JPEG al-
gorithm is more suitable for compressing and reconstructing images with many low-frequency
components.
-  Study the effect of different filtering algorithms (mean filtering, median filtering, Wiener filtering)
on the performance of image compression and reconstruction, concluded that JPEG encoding is
more suitable for compressing and reconstructing the median filtered image.
-  Study effects of different interpolation algorithms (nearest neighbor, bilinear, cubic convolution
interpolation) after downSampling by factor 2 on the performance of image compression and
reconstruction, the result is that nearest neighbor interpolation algorithm reduces compression
performance the most.
- Study the effect of rotation attack and noise attack on the performance of watermark embedding
and extraction for grayscale image and 24-bit color image. Used Arnold Image-Scrambling and
chaotic scrambling to achieve water embedding. Concluded that the watermarking algorithm is
robust to JPEG compression, Gaussian noise attack, and rotation attack.