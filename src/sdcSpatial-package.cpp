#include <Rcpp.h>
#include <cmath>
#ifdef _OPENMP
#include <omp.h>
#endif

//[[Rcpp::plugins(openmp)]]
using namespace Rcpp;
// Function to create a 2D Gaussian kernel
NumericMatrix generate_gaussian_kernel(int kernel_size, double sigma) {
  NumericMatrix kernel(kernel_size, kernel_size);
  double sum = 0.0;
  int half_size = kernel_size / 2;

  for (int y = -half_size; y <= half_size; y++) {
    for (int x = -half_size; x <= half_size; x++) {
      double value = exp(-(x*x + y*y) / (2 * sigma * sigma));
      kernel(y + half_size, x + half_size) = value;
      sum += value;
    }
  }

  // Normalize the kernel
  for (int y = 0; y < kernel_size; y++) {
    for (int x = 0; x < kernel_size; x++) {
      kernel(y, x) /= sum;
    }
  }

  return kernel;
}

// Function to apply the Gaussian filter to an image
// [[Rcpp::export]]
NumericMatrix apply_gaussian_filter(NumericMatrix image, double sigma) {
  int width = image.ncol();
  int height = image.nrow();

  // the kernel size must be odd
  int kernel_size = 6 * sigma + 1;
  if (kernel_size % 2 == 0) {
    kernel_size++;
  }
  // check that kernel is less then height and width
  int half_size = kernel_size / 2;

  NumericMatrix kernel = generate_gaussian_kernel(kernel_size, sigma);
  NumericMatrix output_image(height, width);

#ifdef _OPENMP
#pragma omp parallel for
#endif
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      double sum = 0.0;
      double skip = 0.0;
      for (int ky = -half_size; ky <= half_size; ky++) {
        for (int kx = -half_size; kx <= half_size; kx++) {
          int pixel_x = x + kx;
          int pixel_y = y + ky;

          auto w = kernel(ky + half_size, kx + half_size);
          auto value = image(pixel_y, pixel_x);

          if (NumericVector::is_na(value) || pixel_x < 0 || pixel_x >= width || pixel_y < 0 || pixel_y >= height) {
            skip += w;
          } else {
            sum += w * value;
          }
        }
      }
      // implies that skip < 1, when sum == 0 all is skipped or scaling does not matter
      if (sum > 0){
        output_image(y, x) = sum / (1-skip);
      }
    }
  }
  output_image.attr("kernel") = kernel;
  return output_image;
}


/*** R

V <- volcano
image(V)
sigma <- 10

system.time({
  V1 <- apply_gaussian_filter(V, sigma = sigma)
})

old_par <- par(mfrow=c(1,2))
image(V, zlim=c(90,195), main="V")
image(V1, zlim=c(90,195), main=paste0("V1 (sigma=", sigma, ")"))
par(old_par)
range(V1)

dir.create("example", showWarnings = FALSE)
pdf("example/volcano_gaussian_filter.pdf")
par(mfrow=c(2,2))
r <- sapply(0.5*(1:20), function(s){
  t <- system.time({
    V1 <- sdcSpatial:::apply_gaussian_filter(V, sigma = s)
  })
  image(V1, zlim=c(90,195), main=paste0("V1 (sigma=", s, ")"))
  t
})
dev.off()
t(r[1:3,])
*/
