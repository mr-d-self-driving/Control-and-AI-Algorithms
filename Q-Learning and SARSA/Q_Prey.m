(* ::Package:: *)

(* ::Text:: *)
(*Instellen van de parameters*)


alpha=0.5;
gamma=0.9;
epsilon=0.1;
kost=-0.005;
kaas=8;


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


(* ::Text:: *)
(*Trainen van de muis. De kat wordt mee gegeven via het shel script, de kat wordt random in het rooster gezet.*)


alleBuren=Map[Selecteernietmuren[Selecteerburen[#]]&,Table[k,{k,1,m*n}]]; muizen=FastRF[Table[k,{k,1,m*n}],Join[{kat,kaas},muur]];
Monitor[Do[s=RandomSample[muizen,1];If[t<5000,e=RandomReal[1],e=epsilon];s=s[[1]];
While[s!=kaas && s!= kat,
buren=alleBuren[[s]];
If[RandomReal[1]<e,a=RandomSample[buren,1],a=buren[[Ordering[Map[Q[[s,#]]&,buren],-1]]]];
a=a[[1]];
If[a==kaas,r=1,If[a==kat,r=-1,r=kost]];
Q[[s,a]]=N[Q[[s,a]]*(1-alpha)+alpha*(r+gamma*Max[Q[[a,All]]])];
s=a;];,{t,10000}];,t]


Export[StringJoin[{"Qmuis",ToString[kat],".txt"}],Q]


Quit[];
