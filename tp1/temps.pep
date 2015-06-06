; ********************************************************************
;       Programme: temps.txt     version PEP813 sous Windows
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
         STRO    msgentre,d  
depart:  LDA     -1,i        
         STA     total1,d    
         STA     total2,d    
         LDA     0,i         
         STA     cols,d      
         STRO    msgdebut,d  
boucle:  LDA     cols,d      ; incremente colonnes
         ADDA    1,i         
         STA     cols,d      
         CPA     21,i        
         BREQ    sortir      
         CHARI   caract,d    
analyse: LDBYTEA caract,d    
         CPA     ' ',i       
         BREQ    boucle      
         CPA     '.',i       
         BREQ    invalid     
         CPA     10,i        
         BREQ    sortir      
         LDX     0,i         
         STX     heures,d    
         STX     minutes,d   
         BR      lire        
lirehr:  LDA     cols,d      ; incremente colonnes
         ADDA    1,i         
         STA     cols,d      
         CHARI   caract,d    
         LDBYTEA caract,d    
lire:    ADDX    1,i         
         CPA     '0',i       
         BRLT    paschif     
         CPA     '9',i       
         BRGT    paschif     
         SUBA    '0',i       
         STA     tmpacc,d    
         CPX     2,i         
         BREQ    dixhr       
         CPA     0,i         
         BREQ    avance      
         STA     heures,d    
         BR      lirehr      
avance:  LDA     cols,d      ; incremente colonnes
         ADDA    1,i         
         STA     cols,d      
         CHARI   caract,d    
         LDBYTEA caract,d    
paschif: LDX     0,i         ; reinitialiser à zéro pour lire minutes
         CPA     '.',i       
         BREQ    liremin     
         CPA     ' ',i       
         BREQ    hr_min      
         CPA     10,i        
         BREQ    hr_min      
         BR      invalid     
dixhr:   LDA     heures,d    
         ASLA                
         ASLA                
         ADDA    heures,d    
         ASLA                
         ADDA    tmpacc,d    
         STA     heures,d    
         LDA     heures,d    
         CPA     23,i        
         BRGT    invalid     
         LDX     0,i         
         BR      avance      
liremin: LDA     cols,d      ; incremente colonnes
         ADDA    1,i         
         STA     cols,d      
         CHARI   caract,d    
         LDBYTEA caract,d    
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
         BREQ    dixmin      
dixmin:  ASLA                
         ASLA                
         ADDA    tmpacc,d    
         ASLA                
         STA     minutes,d   
         BR      liremin     
finmin:  STA     minutes,d   
         CPA     59,i        
         BRGT    invalid     
         LDA     cols,d      ; incremente colonnes
         ADDA    1,i         
         STA     cols,d      
         CHARI   caract,d    
         LDBYTEA caract,d    
         CPA     10,i        
         BREQ    hr_min      
         CPA     ' ',i       
         BREQ    hr_min      
         BR      invalid     
hr_min:  LDX     "a",i       ; si total1 est null
         LDA     total1,d    
         CPA     -1,i        
         BREQ    multi       
         LDX     "b",i       ; si total2 est null
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
         CPX     "a",i       
         BREQ    ajout1      
         CPX     "b",i       
         BREQ    ajout2      
ajout1:  STA     total1,d    
         LDA     0,i         
         BREQ    analyse     
ajout2:  STA     total2,d    ; calcule la difference entre
         CPA     total1,d    ; total1 et total2 (heures en minutes)
         BRGE    soustra     
         ADDA    1440,i      
soustra: SUBA    total1,d    
         LDX     -1,i        
divise:  ADDX    1,i         ; transforme minutes en heures
         SUBA    60,i        
         BRGE    divise      
         ADDA    60,i        ; ajoute minutes restante
         STA     minutes,d   
         STX     heures,d    
         LDX     0,i         ; rester pour le flag erreur plus bas
vider:   LDBYTEA caract,d    
         CPA     10,i        
         BREQ    refaire     
         CPA     ' ',i       
         BREQ    saute       
         LDX     1,i         
saute:   CHARI   caract,d    
         BR      vider       
refaire: CPX     1,i         
         BREQ    erreur      
         LDA     cols,d      
         CPA     21,i        
         BRGT    erreur      
         STRO    msgresul,d  
         DECO    heures,d    
         CHARO   "h",i       
         LDA     minutes,d   
         CPA     10,i        
         BRGE    double      
         DECO    0,i         
double:  DECO    minutes,d   
         BR      depart      
erreur:  STRO    msginval,d  
         BR      depart      
invalid: LDA     0,i         
         LDX     1,i         
         BR      vider       
sortir:  LDA     total1,d    
         CPA     -1,i        
         BREQ    fin         
         LDA     total2,d    
         CPA     -1,i        
         BRNE    fin         
         BR      invalid     
fin:     STRO    msgfin,d    
         STOP                
; Déclaration des variables
msgentre:.ASCII  "Bienvenu au programme: Le Temps Écoulé\n"
         .ASCII  "----------------------------------------"
         .ASCII  "\nFORMAT: H HH H.MM ou HH.MM"
         .ASCII  "\nQUITTER: appuyez sur la touche entrée"
         .ASCII  "\nEX: 3 8  3.05  12.20"
         .BYTE   0           
msgdebut:.ASCII  "\n\nEntrez les heures désirées: "
         .BYTE   0           
msgresul:.ASCII  "\nTemps écoulé: "
         .BYTE   0           
msginval:.ASCII  "\nEntrée invalide"
         .BYTE   0           
msgfin:  .ASCII  "\nVous avez quitté avec succès.\n"
         .BYTE   0           
caract:  .BLOCK  1           ; #1h
cols:    .BLOCK  2           ; #2d
tmpacc:  .BLOCK  2           ; #2h
heures:  .BLOCK  2           ; #2d
minutes: .BLOCK  2           ; #2d
total1:  .BLOCK  2           ; #2d
total2:  .BLOCK  2           ; #2d
         .END                  