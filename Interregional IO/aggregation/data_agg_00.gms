$title  Aggregation of IO Table
$ontext

53部門x9地域の連関表を統合するプログラム．


$offtext

$if not setglobal new_data $setglobal new_data h2rio00b

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set sam_i      original row of SAM data
     /100*6300/;

set sam_j      original column of SAM data
     /100*7500/;

set sam_r      region of SAM data
     /0*9/;

alias (sam_r,sam_s);
display sam_i, sam_j, sam_r;

set
    row_(sam_i)         Row (endogenous sector)
    / 100 *5500 /
    va(sam_i)           Row (Value added)
    / 5600*6300 /
    col_(sam_j)         Column (endogenous sector)
    / 100 *5300 /
    fd(sam_j)           Column (Final demand)
    / 5400*7500 /
    r_(sam_r)           Region
    / 0*9 /
    r_r(sam_r,sam_s)
;
r_r(sam_r,sam_r) = yes;
display row_, col_, fd, r_, r_r;
alias (s_,r_);

parameter
  data(*,*,*,*)   "Reigonal IO data (r, row, col,s)";

$gdxin %new_data%.gdx

$load data

$gdxin

display "Original data", data;

*       ----------------------------------------------------------------------
*       Aggregation:
display "com: Aggregation:";

set agg_i    "Aggregated row of SAM data (23 goods)" /
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
    tol                Total
    /;

set
    s_va        Value adde /
      500       Business consumption
      510       Wage
      520       Profit
      530       Capital depreciation
      540       Tax
      550       Subsidies
      560       Total value added
      570       Total product
    /
    s_fd        Final demand /
      480       Business consumption
      490       Household consumption
      500       Government consumption
      510       Public capital accumulation
      520       Private capital accumulation
      530       Factory stock
      540       Distributor stock
      550       Total regional final demand
      560       Total regional demand
      570       Export
      680       Total final demand
      690       Total demand
      700       Import
      810       Import and transer-in
      820       Total final demand
    /;

*        ----------------------------------------------------------------------
*        Mapping set

set mapagg_i(agg_i,sam_i)  "Mapping set for goods and sectors" /
    1.(100*300)
    2.(400,500)
    3.(600)
    4.(700,800)
    5.(1000,1100)
    6.(1200*1500)
    7.(1600,1700)
    8.(1800)
    9.(1900,2000)
    10.(2100)
    11.(2200,2300)
    12.(2400*2900)
    13.(3000*3200)
    14.(3300)
    15.(3400,3500,900,5400,5500)
    16.(3600*3800)
    17.(3900*4100)
    18.(4200)
    19.(4300)
    20.(4500,4600)
    21.(4700*5100)
    /;

set mapagg_r(agg_r,sam_r)  "Mapping set for region" /
    hok.0
    toh.1
    kan.2
    chb.3
    kin.4
    chg.5
    sik.6
    kyu.7
    oki.8
    tol.9
    /;

alias (agg_i,agg_j);
alias (agg_r,agg_s);
display agg_i, agg_r;

set mapagg_j(*,*)
    mapagg_s(*,*);

mapagg_j(agg_i,sam_i) = mapagg_i(agg_i,sam_i);
mapagg_s(agg_r,sam_r) = mapagg_r(agg_r,sam_r);
display mapagg_i, mapagg_r;

set
    map_fd(s_fd,sam_j) /
      480.5400       
      490.5500  
      500.5600     
      510.5700   
      520.5800 
      530.5900
      540.6000   
      550.6100  
      560.6200  
      570.6500  
      680.6700   
      690.6800
      700.7200   
      810.7200   
      820.7400
    /
    map_va(s_va,sam_i) /
      500.5600    
      510.5700 
      520.5800   
      530.5900  
      540.6000  
      550.6100   
      560.6200   
      570.6300   
    /;

display map_fd, map_va;

parameter
  dataagg(*,*,*,*)  "aggregated SAM (bil yen)";

dataagg(agg_r, agg_i, agg_j, agg_s)
      = sum((sam_r,sam_i,sam_j,sam_s)$
          (mapagg_r(agg_r,sam_r)*mapagg_i(agg_i,sam_i)
              *mapagg_j(agg_j,sam_j)*mapagg_s(agg_s,sam_s)),
          data(sam_r,sam_i,sam_j,sam_s));

dataagg(agg_r, s_va, agg_j, agg_s)
      = sum((sam_r,sam_i,sam_j,sam_s)$
          (mapagg_r(agg_r,sam_r)*map_va(s_va,sam_i)
              *mapagg_j(agg_j,sam_j)*mapagg_s(agg_s,sam_s)),
          data(sam_r,sam_i,sam_j,sam_s));

dataagg(agg_r, agg_i, s_fd, agg_s)
      = sum((sam_r,sam_i,sam_j,sam_s)$
          (mapagg_r(agg_r,sam_r)*mapagg_i(agg_i,sam_i)
              *map_fd(s_fd,sam_j)*mapagg_s(agg_s,sam_s)),
          data(sam_r,sam_i,sam_j,sam_s));

display dataagg;

alias (agg_i,i), (agg_i,j);
alias (agg_r,r), (agg_r,s);

Parameters
  ijs0(r,i,j,s)    Intermediate inputs,
  avs0(r,s_va,j,s)      Added value,
  fds0(r,i,s_fd,s)      Final demands;

ijs0(r,i,j,s) = DataAGG(r,i,j,s);

avs0(r,"500",j,s) = DataAGG(r,"500",j,s);
avs0(r,"510",j,s) = DataAGG(r,"510",j,s);
avs0(r,"520",j,s) = DataAGG(r,"520",j,s);
avs0(r,"530",j,s) = DataAGG(r,"530",j,s);
avs0(r,"540",j,s) = DataAGG(r,"540",j,s);
avs0(r,"550",j,s) = DataAGG(r,"550",j,s);
avs0(r,"560",j,s) = DataAGG(r,"560",j,s);
avs0(r,"570",j,s) = DataAGG(r,"570",j,s);

fds0(r,i,"480",s) = DataAGG(r,i,"480",s);
fds0(r,i,"490",s) = DataAGG(r,i,"490",s);
fds0(r,i,"500",s) = DataAGG(r,i,"500",s);
fds0(r,i,"510",s) = DataAGG(r,i,"510",s);
fds0(r,i,"520",s) = DataAGG(r,i,"520",s);
fds0(r,i,"530",s) = DataAGG(r,i,"530",s);
fds0(r,i,"540",s) = DataAGG(r,i,"540",s);
fds0(r,i,"550",s) = DataAGG(r,i,"550",s);
fds0(r,i,"560",s) = DataAGG(r,i,"560",s);
fds0(r,i,"570",s) = DataAGG(r,i,"570",s);
fds0(r,i,"680",s) = DataAGG(r,i,"680",s);
fds0(r,i,"690",s) = DataAGG(r,i,"690",s);
fds0(r,i,"700",s) = DataAGG(r,i,"700",s);
fds0(r,i,"810",s) = DataAGG(r,i,"810",s);
fds0(r,i,"820",s) = DataAGG(r,i,"820",s);


*       Export new data set:
Execute_Unload '%gdx_data%',i,r,s_va,s_fd,ijs0,avs0,fds0;

execute 'gdxxrw %gdx_data% o=%excel_data% par=ijs0 rng=ijs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=avs0 rng=avs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=fds0 rng=fds0!A1 rdim=2 cdim=2'

$exit

