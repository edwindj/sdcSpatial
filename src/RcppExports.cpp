// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// apply_gaussian_filter
NumericMatrix apply_gaussian_filter(NumericMatrix image, double sigma);
RcppExport SEXP _sdcSpatial_apply_gaussian_filter(SEXP imageSEXP, SEXP sigmaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type image(imageSEXP);
    Rcpp::traits::input_parameter< double >::type sigma(sigmaSEXP);
    rcpp_result_gen = Rcpp::wrap(apply_gaussian_filter(image, sigma));
    return rcpp_result_gen;
END_RCPP
}
// calc_risk
NumericMatrix calc_risk(NumericMatrix image, double sigma);
RcppExport SEXP _sdcSpatial_calc_risk(SEXP imageSEXP, SEXP sigmaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type image(imageSEXP);
    Rcpp::traits::input_parameter< double >::type sigma(sigmaSEXP);
    rcpp_result_gen = Rcpp::wrap(calc_risk(image, sigma));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_sdcSpatial_apply_gaussian_filter", (DL_FUNC) &_sdcSpatial_apply_gaussian_filter, 2},
    {"_sdcSpatial_calc_risk", (DL_FUNC) &_sdcSpatial_calc_risk, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_sdcSpatial(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
