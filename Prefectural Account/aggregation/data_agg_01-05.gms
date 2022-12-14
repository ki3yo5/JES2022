$title  Aggregation of SNA Table
$ontext

47都道府県のSNA表を統合するプログラム．


$offtext

$if not setglobal new_data $setglobal new_data 50seisan_01-05

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:
set y      original row of year data
     /2001*2005/;

set r      original row of prefectural data
     /1*47/;

set i      original column of sectoral data
     /0*49/;

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
    gp
    /;

set agg_y    "Year (same as originals)" /
    2001
    2002
    2003
    2004
    2005
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
    3.(7)
    4.(8)
    5.(9)
    6.(10)
    7.(11)
    8.(12)
    9.(13*14)
    10.(15)
    11.(16)
    12.(17)
    13.(18)
    14.(19)
    15.(20)
    16.(21)
    17.(22)
    18.(25)
    19.(28*29)
    20.(32*33)
    21.(37,41,45)
    gp.49
    /;

set mapagg_y(agg_y,y)  "Year (same as originals)" /
    2001.2001
    2002.2002
    2003.2003
    2004.2004
    2005.2005
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

dataagg(agg_y,agg_r,agg_i)
      = sum((y,r,i)$
          (mapagg_y(agg_y,y)*mapagg_r(agg_r,r)*mapagg_i(agg_i,i)),
          data(y,r,i));

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=dataagg!A1 rdim=1 cdim=2'

$exit