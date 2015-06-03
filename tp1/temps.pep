; ******************************************************************** 
;       Programme: TP1.TXT     version PEP813 sous Windows
;
;       titre: Le temps écoulé
;
;       Le programme désiré devra fonctionner sous Windows avec la version PEP 813.
;       Suite à une demande à l'utilisateur (lui expliquant le mode de fonctionnement),
;       vous devrez calculer le temps écoulé entre 2 heures.
;
;       auteur:   Alain Pitre
;       courriel: pitre.alain@courrier.uqam.ca
;       date:     Ete 2015
;       cours:    INF2170
; ********************************************************************

main:    LDA     -1,i        ; initialisation des variables
         STA     total1,d
         STA     total2,d
         LDA     0,i
         STA     col,d

         STRO    demande,d

exec:    LDA     0,i         ; reinitialistion des variables
         STA     active,d
         STA     heures,d
         STA     minutes,d
         STA     nbCarac,d
         LDX     col,d       ; recupérer la colonne courante 
         BR      lire

lire:    ADDX    1,i
         CPX     20,i
         BRGE    sortir
         
         CHARI   entree,d    ; ajouter une lettre
         LDBYTEA entree,d

         CPA     10,i        
         BREQ    sortir      ; sortir si touche ENTER

         CPA     '.',i       ; analyse l'entrée
         BREQ    lireMin

         CPA     ' ',i       
         BREQ    suivant

         CPA    '0',i
         BRLT    invalid

         CPA    '9',i
         BRGT    invalid

         SUBA    '0',i
         STA     tmpAcc,d 

         LDA     1,i
         STA     active,d

         LDA     heures,d    
         ASLA
         ASLA
         ADDA    heures,d
         ASLA
         ADDA    tmpAcc,d
         CPA     23,i
         BRGT    invalid
         STA     heures,d

         BR      lire  

lireMin: ADDX    1,i

         LDA     active,d
         CPA     1,i
         BRNE    invalid  

         CHARI   entree,d
         LDBYTEA entree,d
         
         CPA    '0',i
         BRLT    invalid
         CPA    '9',i
         BRGT    invalid

         SUBA    '0',i
         STA     tmpAcc,d 

         LDA     nbCarac,d
         CPA     0,i
         BREQ    minDix
         
         LDA     tmpAcc,d
         ADDA    minutes,d
         CPA     59,i
         BRGT    invalid
         STA     minutes,d
         BR      lire 
  

minDix:  LDA     tmpAcc,d
         ASLA
         ASLA
         ADDA    tmpAcc,d
         ASLA
         STA     minutes,d

         LDA     nbCarac,d   ; increment caractère minute
         ADDA    1,i
         STA     nbCarac,d

         BR      lireMin


sortir:  LDA     active,d 
         CPA     1,i
         BRNE    calcul 
         BR      case

suivant: LDA     active,d 
         CPA     1,i
         BRNE    lire
         BR      case

invalid: STRO    msgInv,d 
         BR      main
         
case:    LDX     1,i       ; cas si total1 = -1
         LDA     total1,d
         CPA     0,i
         BRLT    multi

         LDX     2,i       ; cas si total2 = -1
         LDA     total2,d
         CPA     0,i
         BRLT    multi

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
         BREQ    exec

ajout2:  STA     total2,d
         BREQ    exec         

calcul:  LDA     total1,d
         CPA     -1,i
         BREQ    invalid
         LDA     total2,d
         CPA     -1,i
         BREQ    invalid
         LDX     -1,i
         CPA     total1,d
         BRLT    resultA
         BRNE    resultB
         BR      resultC

resultA: ADDA    1440,i
         SUBA    total1,d
         BR      divise

resultB: SUBA    total1,d
         BR      divise

resultC: BR      divise   

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
         BRLT    minDble 
         DECO    minutes,d
         BR      main

minDble: DECO    0,i
         DECO    minutes,d
         BR      main

fin:     STRO    msgFin,d
         STOP 

; Déclaration des variables
  
msgInv:  .ASCII  "\nEntrée invalide"
         .BYTE   0 

msgFin:  .ASCII  "\nFin normal du programme"
         .BYTE   0

msgRes:  .ASCII  "\nTemps écoulé: "
         .BYTE   0 
         
demande: .ASCII  "\nEntré les heures désirés: "
         .BYTE   0 

nbCarac: .Block  2 ; #2h
active:  .BLOCK  2 ; #2h
col:     .BLOCK  2 ; #2h
entree:  .BLOCK  1 ; #1h
tmpAcc:  .BLOCK  2 ; #2h       
total1: .BLOCK  2 ; #2h 
total2: .BLOCK  2 ; #2h
heures:  .BLOCK  2 ; #2h
minutes: .BLOCK  2 ; #2h

         .END