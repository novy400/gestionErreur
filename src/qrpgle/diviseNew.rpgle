**FREE
// control options
ctl-opt dftactgrp(*no)
         actgrp(*new);
ctl-opt main(divise);
// declarations
// main procedure
dcl-proc divise;
    dcl-pi *N;
        pDividende int(5) const;
        pDiviseur int(5) const;
        pQuotient  zoned(7:2);
    end-pi;
    dcl-s lZone char(10);
    //initialisation
    clear pQuotient;
    // contrôle
    clear lZone;
    select;
    when pDividende = *zeros;
       lZone = 'Dividende'; 
       snd-msg *escape %msg('USR0001':'YABUG':%trim(lZone))  
            %TARGET(*CALLER:1); 
    when pDiviseur > 12;
       lZone = 'Diviseur'; 
       snd-msg *escape %msg('USR0002':'YABUG':%trim(lZone)) 
            %TARGET(*CALLER:1); 
    endsl;
    //traitement
    monitor;
        pQuotient = pDividende / pDiviseur;
    on-error;
        snd-msg *escape %msg('ERR0001':'YABUG':%trim(%proc()))
            %TARGET(*CALLER:1); 
    endmon;
    return;
end-proc;
