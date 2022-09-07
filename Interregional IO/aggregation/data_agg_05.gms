$title  Aggregation of IO Table
$ontext

53部門x9地域の連関表を統合するプログラム．


$offtext

$if not setglobal new_data $setglobal new_data h2rio05c

$setglobal gdx_data .\results\%new_data%_agg.gdx
$setglobal excel_data .\results\%new_data%_agg.xlsx

*       ----------------------------------------------------------------------
*       Set definitions:
display "com: Set definitions:";

* The aggregated SAM consists of the following elements:

set sam_i      original row of SAM data
     /10*640/;

set sam_j      original column of SAM data
     /10*750/;

set sam_r      region of SAM data
     /1*10/;

alias (sam_r,sam_s);
display sam_i, sam_j, sam_r;

set
    row_(sam_i)         Row (endogenous sector)
    / 10*560 /
    va(sam_i)           Row (Value added)
    / 570*640 /
    col_(sam_j)         Column (endogenous sector)
    / 10*540 /
    fd(sam_j)           Column (Final demand)
    / 550*750 /
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
      570       Business consumption
      580       Wage
      590       Profit
      600       Capital depreciation
      610       Tax
      620       Subsidies
      630       Total value added
      640       Total product
    /
    s_fd        Final demand /
      550       Business consumption
      560       Household consumption
      570       Government consumption
      580       Public capital accumulation
      590       Private capital accumulation
      600       Factory stock
      610       Distributor stock
      620       Total regional final demand
      630       Total regional demand
      660       Export
      680       Total final demand
      690       Total demand
      700       Import
      730       Import and transer-in
      750       Total final demand
    /;

*        ----------------------------------------------------------------------
*        Mapping set

set mapagg_i(agg_i,sam_i)  "Mapping set for goods and sectors" /
    1.(10)
    2.(20,30)
    3.(40)
    4.(50,60)
    5.(80,90)
    6.(100*130)
    7.(140,150)
    8.(160)
    9.(170,180)
    10.(190)
    11.(200,210)
    12.(220*270)
    13.(280*310)
    14.(320)
    15.(70,330,340)
    16.(350)
    17.(360*380)
    18.(390)
    19.(400*420)
    20.(430*450)
    21.(460*520)  
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
      570.570       
      580.580      
      590.590       
      600.600       
      610.610      
      620.620     
      630.630      
      640.640      
    /
    map_fd(s_fd,sam_j) /
      550.550       
      560.560       
      570.570   
      580.580   
      590.590
      600.600   
      610.610      
      620.620     
      630.630       
      660.660      
      680.680       
      690.690      
      700.700   
      730.730      
      750.750      
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

avs0(r,"570",s,j) = DataAGG(r,"570",s,j);
avs0(r,"580",s,j) = DataAGG(r,"580",s,j);
avs0(r,"590",s,j) = DataAGG(r,"590",s,j);
avs0(r,"600",s,j) = DataAGG(r,"600",s,j);
avs0(r,"610",s,j) = DataAGG(r,"610",s,j);
avs0(r,"620",s,j) = DataAGG(r,"620",s,j);
avs0(r,"630",s,j) = DataAGG(r,"630",s,j);
avs0(r,"640",s,j) = DataAGG(r,"640",s,j);

fds0(r,i,s,"550") = DataAGG(r,i,s,"550");
fds0(r,i,s,"560") = DataAGG(r,i,s,"560");
fds0(r,i,s,"570") = DataAGG(r,i,s,"570");
fds0(r,i,s,"580") = DataAGG(r,i,s,"580");
fds0(r,i,s,"590") = DataAGG(r,i,s,"590");
fds0(r,i,s,"600") = DataAGG(r,i,s,"600");
fds0(r,i,s,"610") = DataAGG(r,i,s,"610");
fds0(r,i,s,"620") = DataAGG(r,i,s,"620");
fds0(r,i,s,"630") = DataAGG(r,i,s,"630");
fds0(r,i,s,"660") = DataAGG(r,i,s,"660");
fds0(r,i,s,"680") = DataAGG(r,i,s,"680");
fds0(r,i,s,"690") = DataAGG(r,i,s,"690");
fds0(r,i,s,"700") = DataAGG(r,i,s,"700");
fds0(r,i,s,"730") = DataAGG(r,i,s,"730");
fds0(r,i,s,"750") = DataAGG(r,i,s,"750");


*       Export new data set:
Execute_Unload '%gdx_data%',i,r,s_va,s_fd,ijs0,avs0,fds0;

execute 'gdxxrw %gdx_data% o=%excel_data% par=ijs0 rng=ijs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=avs0 rng=avs0!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_data% o=%excel_data% par=fds0 rng=fds0!A1 rdim=2 cdim=2'

$exit

