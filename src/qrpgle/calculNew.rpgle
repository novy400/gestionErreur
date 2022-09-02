**FREE
// control options
ctl-opt dftactgrp(*no)
         actgrp(*new);
ctl-opt main(calcul);
// declarations
dcl-c LENMSG 50;
dcl-s gMessage char(LENMSG);
// main procedure
dcl-proc calcul;
    dcl-s lMessage like(gMessage);
    dcl-s lDividende int(5);
    dcl-s lDiviseur like(lDividende);
    dcl-s lQuotient zoned(7:2);
    dcl-pr getQuotient extpgm('DIVISENEW');
        pDividende like(lDividende) const;
        pDiviseur like(lDividende) const;
        pQuotient like(lQuotient);
    end-pr;
    // ça marche
    lDividende = 10;
    lDiviseur = 0;
    monitor;
        clear lMessage;
        getQuotient(lDividende:lDiviseur:lQuotient);
       lMessage =' le résultat est ' + %char(lQuotient);
    on-excp 'USR0001';
        lMessage = 'Le nombre de mois est obligatoire.';
    on-excp 'USR0002';
        // plus de 12 mois travaillés ==> jackpot :-) 
        lMessage =' plus de 12 mois de travail, sérieux ?';
    on-excp 'ERR0001';
        // Bug  !) 
        lMessage ='Horreur !';
    on-error;
        snd-msg *escape %msg('ERR0001':'YABUG':%trim(%proc())); 
    endmon;
    snd-msg lMessage;
end-proc;


