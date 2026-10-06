// Detrended fluctuation analysis, order 1 (Peng et al., 1994).
// x: series; boxes: window sizes. Returns F(n) for each window size (non-overlapping
// windows from the start and from the end, as is standard for short series).
#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector dfa_F(NumericVector x, IntegerVector boxes) {
  int N = x.size(); double m = 0; for (int i = 0; i < N; ++i) m += x[i]; m /= N;
  std::vector<double> y(N); double s = 0;
  for (int i = 0; i < N; ++i) { s += x[i] - m; y[i] = s; }       // profile
  NumericVector F(boxes.size());
  for (int b = 0; b < boxes.size(); ++b) {
    int n = boxes[b], K = N / n; double ss = 0; long cnt = 0;
    for (int dir = 0; dir < 2; ++dir) for (int k = 0; k < K; ++k) {
      int st = dir == 0 ? k * n : N - (k + 1) * n;
      double sx = 0, sy = 0, sxx = 0, sxy = 0;
      for (int i = 0; i < n; ++i) { sx += i; sy += y[st + i]; sxx += (double)i * i; sxy += i * y[st + i]; }
      double beta = (n * sxy - sx * sy) / (n * sxx - sx * sx), a = (sy - beta * sx) / n;
      for (int i = 0; i < n; ++i) { double r = y[st + i] - a - beta * i; ss += r * r; ++cnt; }
    }
    F[b] = std::sqrt(ss / cnt);
  }
  return F;
}
