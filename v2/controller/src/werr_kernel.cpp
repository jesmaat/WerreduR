// Fast path of the WERR tripod kernel. Semantics identical to R/werr_kernel.R.
#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

static inline double vec_erf(double x) {
  double s = (x > 0) - (x < 0), xa = std::fabs(x);
  double t = 1.0 / (1.0 + 0.3275911 * xa);
  double poly = ((((1.061405429 * t - 1.453152027) * t + 1.421413741) * t
                   - 0.284496736) * t + 0.254829592) * t;
  return s * (1.0 - poly * std::exp(-xa * xa));
}
static inline double ncdf(double z) { return 0.5 * (1.0 + vec_erf(z / std::sqrt(2.0))); }

// [[Rcpp::export]]
NumericVector werr_tripod_cpp(double cx, double cy, double zoom,
                              int res = 36, int max_iter = 36, double bandwidth = 0.12) {
  // returns c(q1, q2, q3, q4, black_ratio)
  const double zf[3] = {0.60, 1.00, 1.60}, wz[3] = {0.25, 0.50, 0.25};
  // boundary-correction weight depends only on the integer escape count: tabulate
  std::vector<double> wc(max_iter + 1), uu(max_iter + 1);
  double h = std::max(1e-4, bandwidth);
  for (int k = 0; k <= max_iter; ++k) {
    double u = (double)k / max_iter; uu[k] = u;
    double om = ncdf(u / h) + ncdf((1.0 - u) / h) - 1.0;
    om = std::min(std::max(om, 0.45), 1.0);
    wc[k] = 1.0 / om;
  }
  NumericVector out(5);
  int mh = res / 2, mw = res / 2;
  for (int s = 0; s < 3; ++s) {
    double scale = 1.0 / (zoom * zf[s]);
    double sw[4] = {0, 0, 0, 0}, sc[4] = {0, 0, 0, 0}, su[4] = {0, 0, 0, 0};
    int nblack = 0;
    for (int j = 0; j < res; ++j) {          // row = y
      double ci = cy - scale + 2.0 * scale * j / (res - 1);
      for (int k = 0; k < res; ++k) {        // col = x
        double cr = cx - scale + 2.0 * scale * k / (res - 1);
        double zr = 0, zi = 0; int e = max_iter;
        for (int i = 0; i < max_iter; ++i) {
          double t = zr * zr - zi * zi + cr; zi = 2.0 * zr * zi + ci; zr = t;
          if (std::sqrt(zr * zr + zi * zi) > 2.0) { e = i; break; }
        }
        if (e == max_iter) ++nblack;
        int q = (j < mh ? 0 : 2) + (k < mw ? 0 : 1);
        sw[q] += wc[e]; su[q] += wc[e] * uu[e];
        if (uu[e] >= 0.90) sc[q] += wc[e];
      }
    }
    for (int q = 0; q < 4; ++q) out[q] += wz[s] * (0.65 * sc[q] / sw[q] + 0.35 * su[q] / sw[q]);
    out[4] += wz[s] * (double)nblack / (res * res);
  }
  return out;
}
