// MFNS quadtree extraction (Dagli et al., 2026, Sec. IV): N x N escape-time patch at
// (cx, cy, zoom), M_max iterations, cut into grid x grid tiles; each tile's share of
// non-escaping points is one parameter. Defaults follow the paper: N = 128, M = 70, 8 x 8.
#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector mfns_tiles(double cx, double cy, double zoom, int N = 128, int M = 70, int grid = 8) {
  NumericVector out(grid * grid); int t = N / grid; double s = 1.0 / zoom;
  for (int j = 0; j < N; ++j) { double ci = cy - s + 2.0 * s * j / N;
    for (int k = 0; k < N; ++k) { double cr = cx - s + 2.0 * s * k / N, zr = 0, zi = 0; bool in = true;
      for (int i = 0; i < M; ++i) { double q = zr * zr - zi * zi + cr; zi = 2 * zr * zi + ci; zr = q;
        if (zr * zr + zi * zi > 4.0) { in = false; break; } }
      if (in) out[(j / t) * grid + (k / t)] += 1.0; } }
  for (int i = 0; i < grid * grid; ++i) out[i] /= (double)(t * t);
  return out;
}
