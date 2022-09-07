$title  Aggregation of Dist Table

parameter
  dist_out(*,*)  Prefectural dist-out data,
  dist_in(*,*)   Prefectural dist-in data,
  dist_ex(*,*)   Prefectural export data,
  dist_im(*,*)   Prefectural import data;

$call gdxxrw 00_dist_out.xlsx par=dist_out rng=dist_out!a1:az49 Rdim=1 Cdim=1

$call gdxxrw 00_dist_in.xlsx par=dist_in rng=dist_in!a1:az49 Rdim=1 Cdim=1

$call gdxxrw 00_dist_ex.xlsx par=dist_ex rng=dist_ex!a1:az49 Rdim=1 Cdim=1

$call gdxxrw 00_dist_im.xlsx par=dist_im rng=dist_im!a1:az49 Rdim=1 Cdim=1