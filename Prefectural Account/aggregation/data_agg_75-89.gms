$title  Aggregation of SNA Table
$ontext

47都道府県のSNA表を統合するプログラム．


$offtext

$if not setglobal new_data $setglobal new_data 50seisan_75-89

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:
set y      original row of year data
     /1975*1989/;

set r      original row of prefectural data
     /1*47/;

set i      original column of sectoral data
     /0*34/;

display y, r, i;


parameter
  data(*,*,*)   Output data;

$gdxin %new_data%.gdx
$load data
$gdxin

display "Original data", data;

*       ----------------------------------------------------------------------
*       Aggregation:
display "com: Aggregation:";

set agg_i    "Aggregated column of dist data (15 goods)" /
    1                  Agriculture
    2                  Mining
    3-15               Manufacturing tol
    16                  Construction
    17                  Infrastructure
    18                  Wholesale and retail
    19                  Finance and insurance and Real estate
    20                  Transport and communication
    21                  Private and government service
    gp
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
    1.(1)
    2.(5)
    3-15.(6)
    16.(20)
    17.(21)
    18.(22)
    19.(23*24)
    20.(25)
    21.(26,27,31)
    gp.34
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
  dataagg(*,*,*)  "aggregated SAM (bil yen)";

dataagg(y,agg_r,agg_i)
      = sum((r,i)$
          (mapagg_r(agg_r,r)*mapagg_i(agg_i,i)),
          data(y,r,i));

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=dataagg!A1 rdim=1 cdim=2'

$exit