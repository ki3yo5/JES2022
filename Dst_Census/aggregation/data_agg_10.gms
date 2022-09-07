$title  Aggregation of Dist Table
$ontext

51ïîñÂx47ìsìπï{åßÇÃó¨í ï\ÇìùçáÇ∑ÇÈÉvÉçÉOÉâÉÄÅD


$offtext

$if not setglobal new_data $setglobal new_data 10_dist

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set r      original row of prefectural data
     /1*48/;

set i      original column of sectoral data
     /1*58/;

display i, r;

set
    row_(r)         Row (endogenous sector)
    / 1*48 /
    col_(i)         Column (endogenous sector)
    / 1*58 /
;

display row_, col_;

parameter
  dist_out(*,*)  Prefectural dist-out data,
  dist_in(*,*)   Prefectural dist-in data,
  dist_ex(*,*)   Prefectural export data,
  dist_im(*,*)   Prefectural import data;

$gdxin %new_data%_out.gdx
$load dist_out
$gdxin

$gdxin %new_data%_in.gdx
$load dist_in
$gdxin

$gdxin %new_data%_ex.gdx
$load dist_ex
$gdxin

$gdxin %new_data%_im.gdx
$load dist_im
$gdxin

parameter
  data(*,*)      Dist supply ammount (Dist-out + Export) (MT per year);
  
data(r,i) = dist_out(r,i) + dist_ex(r,i)
;

display "Original data", dist_out, dist_in, dist_ex, dist_im, data;

*       ----------------------------------------------------------------------
*       Aggregation:
display "com: Aggregation:";

set agg_i    "Aggregated column of dist data (15 goods)" /
    1                  Agriculture
    2                  Mining
    3                  Food Processing
    4                  Textile
    5                  Paper
    6                  Chemistry
    7                  Oil
    8                  Ceramics
    9                  Refine
    10                  Metal
    11                  Machine
    12                  Electric machine
    13                  Tranport machine
    14                  Precision machine
    15                  Other machine
*    16                  Construction
*    17                  Infrastructure
*    18                  Wholesale and retail
*    19                  Finance and insurance and Real estate
*    20                  Transport and communication
*    21                  Private and government service
    /;

set agg_r    "Aggregated region (9 regions)" /
    hok                Hokkaido
    toh                Tohoku
    kan                Kanto
    chb                Chubu
    kin                Kinki
    chg                Chugoku
    sik                Sikoku
    kyu                Kyushu
    oki                Okinawa
    /;

*        ----------------------------------------------------------------------
*        Mapping set

set mapagg_i(agg_i,i)  "Mapping set for goods and sectors" /
    1.(36)
    2.(7)
    3.(8*9)
    4.(10*11)
    5.(14*15)
    6.(16)
    7.(17*19)
    8.(21)
    9.(22*23)
    10.(24)
    11.(25)
    12.(26*28)
    13.(29)
    14.(30)
    15.(31,12*13,20)
*    16.()
*    17.()
*    18.()
*    19.()
*    20.()
*    21.()
    /;

set mapagg_r(agg_r,r)  "Mapping set for region" /
    hok.1
    toh.(2*7)
    kan.(8*15,19*20,22)
    chb.(16*17,21,23*24)
    kin.(18,25*30)
    chg.(31*35)
    sik.(36*39)
    kyu.(40*46)
    oki.47
    /;

display agg_i, agg_r;

parameter
  dataagg(*,*)  "aggregated SAM (bil yen)";

dataagg(agg_r, agg_i)
      = sum((r,i)$
          (mapagg_r(agg_r,r)*mapagg_i(agg_i,i)),
          data(r,i));

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=00_dist!A1 rdim=1 cdim=1'

$exit

