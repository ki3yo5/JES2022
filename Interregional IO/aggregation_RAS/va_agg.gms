$title  Aggregation of IO Table
$ontext

47ìsìπï{åßÇÃïtâ¡âøíläzÇìùçáÇ∑ÇÈÉvÉçÉOÉâÉÄÅD


$offtext

$if not setglobal new_data $setglobal new_data 15_va

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set sam_i      original row of SAM data (region)
     /1*50/;

display sam_i;


parameter
  data(*)   "Original Output data";

$gdxin %new_data%.gdx

$load data

$gdxin

display "Original data", data;

*       ----------------------------------------------------------------------
*       Aggregation:
display "com: Aggregation:";

set agg_i    "Aggregated region (9 regions)" /
    hok                Hokkaido
    toh                Tohoku
    kan                Kanto
    chb                Chubu
    kin                Kinki
    chg                Chugoku
    sik                Sikoku
    kyu                Kyushu
    oki                Okinawa
    tol                Total
    /;


*        ----------------------------------------------------------------------
*        Mapping set

set mapagg_i(agg_i,sam_i)  "Mapping set for region" /
    hok.1
    toh.(2*7)
    kan.(8*15,19,20,22)
    chb.(16,17,21,23,24)
    kin.(18,25*30)
    chg.(31*35)
    sik.(36*39)
    kyu.(40*46)
    oki.47
    tol.50
    /;
    

display agg_i;


parameter
  dataagg(*)  "aggregated SAM (bil yen)";

dataagg(agg_i)
      = sum((sam_i)$
          (mapagg_i(agg_i,sam_i)),
             data(sam_i));

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',agg_i,dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=data!A1 rdim=1 cdim=0'

$exit

