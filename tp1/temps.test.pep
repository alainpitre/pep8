depart:  LDA     -1,i
         STA     total1,d
         STA     total2,d
         LDA     0,i
         STRO    demande,d 

boucle:  CHARI   chaine,d 
         LDBYTEA chaine,d
         CPA     ' ',i
         BREQ    boucle
         CPA     '.',i
         BREQ    boucle
         CPA     10,i
         BREQ    fin 

         LDX     0,i
         BR      lirehr  

lirehr:  ADDX    1,i
         CPA     ' ',i
         BREQ    suivant
         CPA     10,i
         BREQ    suivant
         CPA     '.',i
         BREQ    suivant
         CPX     3,i
         BREQ    invalid
         CPA     '0',i
         BRLT    invalid
         CPA     '9',i
         BRGT    invalid
         SUBA    '0',i   
         STA     tmpacc,d 
         CPX     2,i
         BREQ    hrdeci 
         CPA     0,i
         BREQ    zero
         STA     heures,d
         CHARI   chaine,d
         LDBYTEA chaine,d
         BR      lirehr

zero:    CHARI   chaine,d
         LDBYTEA chaine,d
         CPA     '.',i
         BREQ    suivant    
         CPA     ' ',i
         BREQ    switch   
         BR      invalid 

hrdeci:  LDA     heures,d
         ASLA
         ASLA
         ADDA    heures,d
         ASLA
         ADDA    tmpacc,d 
         STA     heures,d
         BR      zero

suivant: LDA     heures,d
         CPA     23,i
         BRGT    invalid
         ; LDX     0,i
         BR      switch 

liremin: CHARI   chaine,d
         LDBYTEA chaine,d
         ADDX    1,i
         CPA     '0',i
         BRLT    invalid
         CPA     '9',i
         BRGT    invalid
         SUBA    '0',i   
         ADDA    minutes,d
         STA     tmpacc,d
         CPX     2,i
         BREQ    finmin
         CPX     1,i
         BREQ    mindeci
        
mindeci: ASLA
         ASLA
         ADDA    tmpacc,d 
         ASLA
         STA     minutes,d
         BR      liremin

finmin:  STA     minutes,d
         CHARI   chaine,d
         LDBYTEA chaine,d
         CPA     10,i
         BREQ    switch
         CPA     ' ',i
         BRNE    invalid
         LDA     minutes,d
         CPA     59,i
         BRGT    invalid
         BR      fin 

invalid: STRO    msgInv,d 
         BR      fin

switch:  LDX     1,i       ; cas si total1 = -1
         LDA     total1,d
         CPA     -1,i
         BREQ    multi

         LDX     2,i       ; cas si total2 = -1
         LDA     total2,d
         CPA     -1,i
         BREQ    multi

multi:   LDA     heures,d    ; initialiser format(heures)
         ASLA                ; * 2
         ASLA                ; * 4
         ADDA    heures,d    ; * 5 
         ASLA                ; * 10
         STA     heures,d    ; heures = nombre * 10
         ADDA    heures,d    ; * 20
         ADDA    heures,d    ; * 30
         ASLA                ; * 60
         ADDA    minutes,d   ; heures(en min) + minutes
         
         CPX     1,i 
         BREQ    ajout1 

         CPX     2,i
         BREQ    ajout2

ajout1:  STA     total1,d
         BREQ    boucle 

ajout2:  STA     total2,d
         BREQ    calcul         

calcul:  LDA     total1,d
         CPA     -1,i
         BREQ    invalid
         LDA     total2,d
         CPA     -1,i
         BREQ    invalid
         CPA     total1,d
         BRLT    resultA
         BRNE    resultB
         BR      resultC

resultA: ADDA    1440,i
         SUBA    total1,d
         BR      convert

resultB: SUBA    total1,d
         BR      convert

resultC: LDA     1440,i   
         BR      convert

convert: LDA     -1,i
divise:  ADDX    1,i  
         SUBA    60,i
         BRGE    divise
         ADDA    60,i 
         STA     minutes,d
         STX     heures,d
         BR      affiche

affiche: STRO    msgRes,d
         DECO    heures,d 
         CHARO   "h",i
         LDA     minutes,d
         CPA     10,i
         BRLT    simple
         BR      double 

simple:  DECO    0,i
double:  DECO    minutes,d

vider:   LDBYTEA chaine,d
         CPA     10,i
         BREQ    depart
         CHARI   chaine,d
         BR      vider

fin:     STRO    msgfin,d 
         STOP

; Déclaration des variables
  
msgInv:  .ASCII  "\nEntrée invalide"
         .BYTE   0 
msgfin:  .ASCII  "\nFin normal du programme"
         .BYTE   0
msgRes:  .ASCII  "\nTemps écoulé: "
         .BYTE   0      
demande: .ASCII  "\nEntré les heures désirés: "
         .BYTE   0 

chaine:  .BLOCK  1          ; #1h
tmpacc:  .BLOCK  2          ; #2h
heures:  .BLOCK  2          ; #2h
minutes: .BLOCK  2          ; #2h
total1:  .BLOCK  2          ; #2d
total2:  .BLOCK  2          ; #2d


         .END 