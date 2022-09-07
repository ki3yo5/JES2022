$title  Aggregation of IO Table
$ontext

43部門x9地域の連関表を統合するプログラム．


$offtext

$if not setglobal new_data $setglobal new_data h2rio80a

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set sam_i      original row of SAM data
     /010*530/;

set sam_j      original column of SAM data
     /010*650/;

set sam_r      region of SAM data
     /1*10/;

alias (sam_r,sam_s);
display sam_i, sam_j, sam_r;

set
    row_(sam_i)         Row (endogenous sector)
    / 010*440 /
    va(sam_i)           Row (Value added)
    / 450*530 /
    col_(sam_j)         Column (endogenous sector)
    / 010*440 /
    fd(sam_j)           Column (Final demand)
    / 450*650 /
    r_(sam_r)           Region
    / 1*10 /
    r_r(sam_r,sam_s)
;
r_r(sam_r,sam_r) = yes;
display row_, col_, fd, r_, r_r;
alias (s_,r_);

parameter
  data(*,*,*,*)   "Reigonal IO data (r, row, s, col)";

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
    15                  Other manufacturing
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
      490       Business consumption
      500       Wage
      510       Profit
      520       Capital depreciation
      530       Tax
      540       Subsidies
      550       Total value added
      560       Total product
    /
    s_fd        Final demand /
      480       Business consumption
      490       Household consumption
      500       Government consumption
      510       Capital accumulation
      520       Stock
      530       Total regional final demand
      540       Total regional demand
      550       Export
      560       Total final demand
      570       Total demand
      680       Import
      800       Total final demand
    /;

*        ----------------------------------------------------------------------
*        Mapping set

set mapagg_i(agg_i,sam_i)  "Mapping set for goods and sectors" /
    1.(010)
    2.(020*040)
    3.(050)
    4.(060*080)
    5.(100,110)
    6.(130*180)
    7.(190,200)
    8.(210)
    9.(220*250)
    10.(260)
    11.(270)
    12.(280,290)
    13.(300,310)
    14.(320)
    15.(090,120,330)
    16.(340,350)
    17.(360,370)
    18.(380)
    19.(390)
    20.(420)
    21.(400,410,430)   
    /;

set mapagg_r(agg_r,sam_r)  "Mapping set for region" /
    hok.1
    toh.2
    kan.3
    chb.4
    kin.5
    chg.6
    sik.7
    kyu.8
    oki.9
    tol.10
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
    map_va(s_va,sam_i) /
      490.460
      500.470    
      510.480 
      520.490   
      530.500  
      540.510  
      550.520   
      560.530   
    /
    map_fd(s_fd,sam_j) /
      480.450       
      490.460  
      500.570     
      510.480   
      520.490 
      530.500
      540.(440,500)   
      550.510  
      560.520  
      570.530  
      680.540   
      800.(520,540)   
    /;

display map_fd, map_va;

parameter
  dataagg(*,*,*,*)  "aggregated SAM (bil yen)";

dataagg(agg_r, agg_i, agg_s, agg_j)
      = sum((sam_r,sam_i,sam_s,sam_j)$
          (mapagg_r(agg_r,sam_r)*mapagg_i(agg_i,sam_i)
              *mapagg_s(agg_s,sam_s)*mapagg_j(agg_j,sam_j)),
          data(sam_r,sam_i,sam_s,sam_j));

dataagg(agg_r, s_va, agg_s, agg_j)
      = sum((sam_r,sam_i,sam_s,sam_j)$
          (mapagg_r(agg_r,sam_r)*map_va(s_va,sam_i)
              *mapagg_s(agg_s,sam_s)*mapagg_j(agg_j,sam_j)),
          data(sam_r,sam_i,sam_s,sam_j));

dataagg(agg_r, agg_i, agg_s, s_fd)
      = sum((sam_r,sam_i,sam_s,sam_j)$
          (mapagg_r(agg_r,sam_r)*mapagg_i(agg_i,sam_i)
              *mapagg_s(agg_s,sam_s)*map_fd(s_fd,sam_j)),
          data(sam_r,sam_i,sam_s,sam_j));

display dataagg;

alias (agg_i,i), (agg_i,j);
alias (agg_r,r), (agg_r,s);

Parameters
  ijs0(r,i,s,j)    Intermediate inputs,
  avs0(r,s_va,s,j)      Added value,
  fds0(r,i,s,s_fd)      Final demands;

ijs0(r,i,s,j) = DataAGG(r,i,s,j);

avs0(r,"490",s,j) = DataAGG(r,"490",s,j);
avs0(r,"500",s,j) = DataAGG(r,"500",s,j);
avs0(r,"510",s,j) = DataAGG(r,"510",s,j);
avs0(r,"520",s,j) = DataAGG(r,"520",s,j);
avs0(r,"530",s,j) = DataAGG(r,"530",s,j);
avs0(r,"540",s,j) = DataAGG(r,"540",s,j);
avs0(r,"550",s,j) = DataAGG(r,"550",s,j);
avs0(r,"560",s,j) = DataAGG(r,"560",s,j);

fds0(r,i,s,"480") = DataAGG(r,i,s,"480");
fds0(r,i,s,"490") = DataAGG(r,i,s,"490");
fds0(r,i,s,"500") = DataAGG(r,i,s,"500");
fds0(r,i,s,"510") = DataAGG(r,i,s,"510");
fds0(r,i,s,"520") = DataAGG(r,i,s,"520");
fds0(r,i,s,"530") = DataAGG(r,i,s,"530");
fds0(r,i,s,"540") = DataAGG(r,i,s,"540");
fds0(r,i,s,"550") = DataAGG(r,i,s,"550");
fds0(r,i,s,"560") = DataAGG(r,i,s,"560");
fds0(r,i,s,"570") = DataAGG(r,i,s,"570");
fds0(r,i,s,"680") = DataAGG(r,i,s,"680");
fds0(r,i,s,"800") = DataAGG(r,i,s,"800");


*       Export new data set:
Execute_Unload '%gdx_data%',i,r,s_va,s_fd,ijs0,avs0,fds0;

execute 'gdxxrw %gdx_data% o=%excel_data% par=ijs0 rng=ijs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=avs0 rng=avs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=fds0 rng=fds0!A1 rdim=2 cdim=2'

$exit

