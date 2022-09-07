$title  Aggregation of IO Table
$ontext

29ïîñÂx47ìsìπï{åßÇÃéYèoäzÇìùçáÇ∑ÇÈÉvÉçÉOÉâÉÄÅD


$offtext

$if not setglobal new_data $setglobal new_data 15_output

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set sam_i      original row of SAM data (region)
     /1*50/;

set sam_j      original column of SAM data (sector)
     /10*300/;

display sam_i, sam_j;


parameter
  data(*,*)   "Original Output data";

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

set agg_j    "Aggregated row of SAM data (23 goods)" /
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
    
set mapagg_j(agg_j,sam_j)  "Mapping set for goods and sectors" /
    1.(10)
    2.(20)
    3.(30)
    4.(40)
    5.(50)
    6.(60)
    7.(70)
    8.(80)
    9.(90)
    10.(100)
    11.(110)
    12.(130)
    13.(150)
    14.(120,140)
    15.(160)
    16.(180)
    17.(170)
    18.(190)
    19.(230,240)
    20.(200,220)
    21.(210,250*290)  
    /;

display agg_i, agg_j;


parameter
  dataagg(*,*)  "aggregated SAM (bil yen)";

dataagg(agg_i, agg_j)
      = sum((sam_i,sam_j)$
          (mapagg_i(agg_i,sam_i)
          *mapagg_j(agg_j,sam_j)),
             data(sam_i,sam_j));

display dataagg;


*       Export new data set:
Execute_Unload '%gdx_data%',agg_i,agg_j,dataagg;

execute 'gdxxrw %gdx_data% o=%excel_data% par=dataagg rng=data!A1 rdim=1 cdim=1'

$exit

