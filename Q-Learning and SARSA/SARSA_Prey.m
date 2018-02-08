(* ::Package:: *)

(* ::Text:: *)
(*Instellen van de parameters*)


alpha=0.5;
gamma=0.9;
epsilon=0.1;
kost=-0.005;
kaas=8;
katkost = -1.8;
maxit = 20; (*wordt enkel gebruikt indien kat op positie 15*)


(*kat = 16;*)


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


If[Muurtest[kat]||kat==49,Export[StringJoin[{"QmuisSa",ToString[kat],".txt"}],Q];Quit[];]


(* ::Text:: *)
(*Trainen van de muis. De kat wordt mee gegeven via het shel script, de kat wordt random in het rooster gezet.*)


alleBuren=Map[Selecteernietmuren[Selecteerburen[#]]&,Table[k,{k,1,m*n}]];muizen=FastRF[Table[k,{k,1,m*n}],Join[{kat},muur]];
Monitor[Do[l=0;s=RandomSample[muizen,1];s=s[[1]];e=epsilon;buren=alleBuren[[s]];
If[RandomReal[1]<e,a=RandomSample[buren,1],
a=buren[[Ordering[Map[Q[[s,#]]&,buren],-1]]]];
a=a[[1]];
While[s!=kaas && s!= kat && (l<19||kat!=15),buren2=alleBuren[[a]];
If[RandomReal[1]<e,a2=RandomSample[buren2,1],
a2=buren2[[Ordering[Map[Q[[a,#]]&,buren2],-1]]]];a2=a2[[1]];If[a==kaas,r=1,If[a==kat,r=katkost,r=kost]];
Q[[s,a]]=N[Q[[s,a]]*(1-alpha)+alpha*(r+gamma*Q[[a,a2]])];s=a;a=a2;l=l+1;];,{t,10000}];,t]


(*epsilon = 0.01;*)


(*muis = 23;*)


(* grid[[muur]] = -2;figs={}; grid[[muis]]=0;alleBuren=Map[Selecteernietmuren[Selecteerburen[#]]&,Table[k,{k,1,m*n}]];
Monitor[Do[s=muis;l=0;buren=alleBuren[[s]];If[RandomReal[1]<epsilon,a=RandomSample[buren,1],a=buren[[Ordering[Map[Q[[s,#]]&,buren],-1]]]];a=a[[1]];While[s\[NotEqual]kaas && s\[NotEqual] kat && (l<19||kat\[NotEqual]15),buren2=alleBuren[[a]];
If[RandomReal[1]<epsilon,a2=RandomSample[buren2,1],a2=buren2[[Ordering[Map[Q[[a,#]]&,buren2],-1]]]];a2=a2[[1]];If[a\[Equal]kaas,r=1,If[a\[Equal]kat,r=-1,r=kost]]; Q[[s,a]]=N[Q[[s,a]]*(1-alpha)+alpha*(r+gamma*Q[[a,a2]])];s=a;grid[[s]]=2;figs=Append[figs,grid];grid[[s]]=0;grid[[kaas]] = 1;grid[[kat]]=-1;a = a2;l=l+1;],{t,1}],t]*)


(*Animate[ArrayPlot[Partition[figs[[t]],n],ColorRules->{-2->Pink,0->Yellow,2-> Blue,-1 -> Red,1 -> Green}],{t,1,First@Dimensions@figs,1}]*)


Export[StringJoin[{"QmuisSa",ToString[kat],".txt"}],Q]


Quit[];
