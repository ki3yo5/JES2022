$title  Aggregation of Dist Table

parameter
  dist_out(*,*)  Prefectural dist-out data,
  dist_in(*,*)   Prefectural dist-in data,
  dist_ex(*,*)   Prefectural export data,
  dist_im(*,*)   Prefectural import data;

$call gdxxrw 15_dist_out.xls par=dist_out rng=dist_out!a1:bi49 Rdim=1 Cdim=1

$call gdxxrw 15_dist_in.xls par=dist_in rng=dist_in!a1:bi49 Rdim=1 Cdim=1

$call gdxxrw 15_dist_ex.xls par=dist_ex rng=dist_ex!a1:bi49 Rdim=1 Cdim=1

$call gdxxrw 15_dist_im.xls par=dist_im rng=dist_im!a1:bi49 Rdim=1 Cdim=1