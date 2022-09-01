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
    //initialisation
    clear pQuotient;
    pQuotient = pDividende / pDiviseur;
    return;
end-proc;
