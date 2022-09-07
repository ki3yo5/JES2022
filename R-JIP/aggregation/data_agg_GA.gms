$title  Aggregation of GA Table
$ontext

47ìsìπï{åßÇÃGAï\ÇìùçáÇ∑ÇÈÉvÉçÉOÉâÉÄÅD


$offtext

$if not setglobal new_data $setglobal new_data GA_70-16

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:
set r      original row of prefectural data
     /1*47/;

set i      original column of sectoral data
     /1*23/;

set y      original row of year data
     /1970*2016/;

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
    16                  Construction
    17                  Infrastructure
    18                  Wholesale and retail
    19                  Finance and insurance and Real estate
    20                  Transport and communication
    21                  Private and government service
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
    1.1
    2.2
    3.3
    4.4
    5.5
    6.6
    7.7
    8.8
    9.9
    10.10
    11.11
    12.12
    13.13
    14.14
    15.15
    16.16
    17.17
    18.18
    19.19
    20.21
    21.22
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

dataagg(agg_r,agg_i,y)
      = sum((r,i)$
          (mapagg_r(agg_r,r)*mapagg_i(agg_i,i)),
          data(r,i,y));

dataagg("hok",agg_i,y) = dataagg("hok",agg_i,y) / 1;
dataagg("toh",agg_i,y) = dataagg("toh",agg_i,y) / 6;
dataagg("kan",agg_i,y) = dataagg("kan",agg_i,y) / 11;
dataagg("chb",agg_i,y) = dataagg("chb",agg_i,y) / 5;
dataagg("kin",agg_i,y) = dataagg("kin",agg_i,y) / 7;
dataagg("chg",agg_i,y) = dataagg("chg",agg_i,y) / 5;
dataagg("sik",agg_i,y) = dataagg("sik",agg_i,y) / 4;
dataagg("kyu",agg_i,y) = dataagg("kyu",agg_i,y) / 7;
dataagg("oki",agg_i,y) = dataagg("oki",agg_i,y) / 1;

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=dataagg!A1 rdim=2 cdim=1'

$exit