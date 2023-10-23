**FREE
///
// CALCULE
// Réalise une division!
// @tag data
// @tag data
///  
// control options
/if defined(*CRTBNDRPG)
 ctl-opt dftactgrp(*no)
         actgrp(*new);
/endif
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
    ///
    // donne le quoitient.
    // avec le dividende et le diviseur retourne le quotient.
    // Description can be multiline
    // @tag data
    // @tag data
    ///  
    dcl-pr getQuotient extpgm('DIVISE');
        pDividende like(lDividende) const;
        pDiviseur like(lDividende) const;
        pQuotient like(lQuotient);
    end-pr;
    // ça marche
    lDividende = 10;
    lDiviseur = 0;
    getQuotient(lDividende:lDiviseur:lQuotient);
    clear lMessage;
    lMessage =' le résultat est ' + %char(lQuotient);
    dsply (lMessage);
end-proc;


