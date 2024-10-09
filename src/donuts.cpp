#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
DataFrame donut_adjust(
    DataFrame d,
    double outer,
    double inner = 0
){
  auto x = as<NumericVector>(d["x"]);
  auto y = as<NumericVector>(d["y"]);
  int n = d.nrow();

  auto rangle = M_PI * Rcpp::runif(n, 0, 2);
  //
  double s = outer-inner;

  auto rradius = Rcpp::runif(n);

  NumericVector x_d = clone(x);
  NumericVector y_d = clone(y);

  for (int i = 0; i < d.nrow(); i++){
    x_d(i) += inner + (s) * (rradius[i] * cos(rangle[i]));
    y_d(i) += inner + (s) * (rradius[i] * sin(rangle[i]));
  }

  DataFrame res = DataFrame::create(
    _["x"] = x_d,
    _["y"] = y_d
    // _["rradius"] = rradius
  );

  return res;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
d <- data.frame(x = 10 *(1:2), y = 20 * (1:2))
donut_adjust(d, outer = 2)
*/
