:	Created by Shiro Takeda.
:
: call run_one_scenario arg
:
: arg - experiment name

echo	*       New data name is %1 >.\%1_temp.gms
echo
echo	$setglobal new_data %1 >>.\%1_temp.gms
echo	$include .\data_agg_12x9.gms >>.\%1_temp.gms
echo

call gams .\%1_temp.gms ll=0 lo=3 pw=130 ps=9999

del .\%1_temp.gms

