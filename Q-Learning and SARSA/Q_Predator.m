(* ::Package:: *)

muis = 30;


(* ::Text:: *)
(*Instellen van de parameters*)


alpha=0.5;
gamma=0.9;
epsilon=0.1;
kost=-0.005;


(* ::Text:: *)
(*Opbouwen van het doolhof waarin de kat de muist moet zoeken*)


m = 6;
n = 8;
grid = ConstantArray[0,m*n];
muur = {10,12,14,18,20,22,26,36,37,38,39};


(* ::Text:: *)
(*Enkele nuttige functies*)


Muurtest[x_]:=Dimensions@Select[muur,#== x&]== {1}
Selecteerburen[l_] := Select[Table[k,{k,1,m*n}],((#==l-1&& Mod[l-1,n] !=   0)||(#== l+1&& Mod[l,n] != 0)||#== l-n||#== l+n )&]
Selecteernietmuren[x_] := Select[x,!Muurtest[#]&]
FastRF[a_List, b_List] := Module[{c, o, x}, c = Join[b, a]; o = Ordering[c]; x = 1 - 2 UnitStep[-1 - Length[b] + o]; x = FoldList[Max[#, 0] + #2 &, x]; x[[o]] = x; Pick[c, x, -1]]


(* ::Text:: *)
(*Opstellen van de Q matrix*)


Q=Partition[ConstantArray[0,(m*n)^2],(m*n)];
Q[[All,muur]]=-1;


If[Muurtest[muis],Export[StringJoin[{"Qkat",ToString[muis],".txt"}],Q];Quit[];]


(* ::Text:: *)
(*Trainen van de kat. De muis wordt mee gegeven via het shellscript, de kat wordt random in het rooster gezet.*)


alleBuren=Map[Selecteernietmuren[Selecteerburen[#]]&,Table[k,{k,1,m*n}]]; katten=FastRF[Table[k,{k,1,m*n}],Join[{muis},muur]];
Monitor[Do[s=RandomSample[katten,1];If[t<5000,e=RandomReal[1],e=epsilon];s=s[[1]];
While[s!=muis,
buren=alleBuren[[s]];
If[RandomReal[1]<e,a=RandomSample[buren,1],a=buren[[Ordering[Map[Q[[s,#]]&,buren],-1]]]];
a=a[[1]];
If[a==muis,r=1,r=kost];
Q[[s,a]]=N[Q[[s,a]]*(1-alpha)+alpha*(r+gamma*Max[Q[[a,All]]])];
s=a;];,{t,10000}];,t]


epsilon = 0.01;


kat = 8;


grid[[muur]] = -2;grid[[muis]] = 1; figs={}; grid[[kat]]=0;alleBuren=Map[Selecteernietmuren[Selecteerburen[#]]&,Table[k,{k,1,m*n}]];
Monitor[Do[s=kat;While[s!=muis,buren=alleBuren[[s]];If[RandomReal[1]<epsilon,a=RandomSample[buren,1],a=buren[[Ordering[Map[Q[[s,#]]&,buren],-1]]]];a=a[[1]];If[a==muis,r=1,r=kost]; Q[[s,a]]=N[Q[[s,a]]*(1-alpha)+alpha*(r+gamma*Max[Q[[a,All]]])];s=a;grid[[s]]=2;figs=Append[figs,grid];grid[[s]]=0;grid[[muis]] = 1;],{t,1}],t]


(* ::Text:: *)
(*Visualisatie*)


Animate[ArrayPlot[Partition[figs[[t]],n],ColorRules->{-2->Pink,0->Yellow,2-> Red,1 -> Blue}],{t,1,First@Dimensions@figs,1}]


Export[StringJoin[{"Qkat",ToString[muis],".txt"}],Q]


Quit[];
