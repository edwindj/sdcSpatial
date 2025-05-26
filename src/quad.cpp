#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List quadcount(DataFrame d, int resolution = 100, int J = 4){
  NumericVector x = as<NumericVector>(d["x"]);
  NumericVector y = as<NumericVector>(d["y"]);

  double x_min = Rcpp::min(x);
  double x_max = Rcpp::max(x);
  double y_min = Rcpp::min(y);
  double y_max = Rcpp::max(y);

  List counts = List();
  int res = resolution;

  int min_res = resolution * 2^(J-1);
  x_min = floor(x_min / min_res) * min_res;
  x_max = ceil(x_max / min_res) * min_res;
  y_min = floor(y_min / min_res) * min_res;
  y_max = ceil(y_max / min_res) * min_res;

  for (int j = 0; j < J; j++){
    int n_x = (x_max - x_min) / res;
    int n_y = (y_max - y_min) / res;
    NumericMatrix count(n_y, n_x);
    NumericVector ix(x.size());
    for (int i = 0; i < x.size(); i++){
      int x_index = (x[i] - x_min) / res;
      int y_index = (y[i] - y_min) / res;

      ix[i] = 1 + (x_index * n_y) + y_index; // for debugging
      if (x_index >= 0 && x_index < n_x && y_index >= 0 && y_index < n_y){
        count(y_index, x_index)++;
      }
    }
    std::string JS = "J" + std::to_string(j+1);
    d.push_back(ix, JS);
    counts.push_back(count, JS);
    res = res*2;
  }
  counts.push_back(d, "data");
  return counts;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
data("dwellings", package="sdcSpatial")
l <- quadcount(dwellings, resolution = 100, J = 6)
l$d
*/
