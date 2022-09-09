# Gestion des erreurs.

Comment profiter des nouvelles évolutions du langage RPG de la V7R5 pour mieux gérer nos erreurs.
- SND-MSG   pour envoyer un message depuis un rpg. (cf SNDMSG de CLP)
- ON-EXCP   pour capturer un message dans un programme (cf MONMSG de CLP)
# Install and Build
1. `git clone https://github.com/novy400/gestionErreur.git` this repository
![picture 1](images/a1f3b51ba9339408544497b640af53b1c51b726058bd30b753f348f3069cf093.png)  

1. Run `make BIN_LIB=YOURBIB` (available from yum) en remplaçant YOURBIB par votre bibliothèque.
![picture 2](images/81c5fce15e0a7928f8ebbde3f439d76d652570d6a91e35aae6270fcf31e8211f.png)  

## Différents cas. 
### On remonte l'escape !
```
    monitor;
        clear lMessage;
        getQuotient(lDividende:lDiviseur:lQuotient);
       lMessage =' le résultat est ' + %char(lQuotient);
    on-excp 'USR0001';
        lMessage = 'Le nombre de mois est obligatoire.';
    on-excp 'USR0002';
        // plus de 12 mois travaillés ==> jackpot :-) 
        lMessage =' plus de 12 mois de travail, sérieux ?';
    on-error;
        snd-msg *escape %msg('ERR0001':'YABUG':%trim(%proc())); 
    endmon;
    snd-msg lMessage;
```
![picture 1](images/70350113d495913ac435b1944c57a93117da4f105a9a6be1d6240d9d09effd41.png)  

### ok avec 14 pour dividende
![picture 2](images/65eb012ea721bfb657dc77236e49861d14613d44580ee16f994c5e47051741cc.png) 
![picture 4](images/e639db0fe7d9bbd262dfc0e35560ebbb106a95a8f1151706f2cbfb7dd0723d5b.png)  

### old calcul appelle new divise
Comment se comporte le programme appelant si pas de monitor ?
![picture 3](images/fda3c464d82be179a68ec49766706709e1cedb3678fab40001c26f05bb18b10d.png)  

## Ressources
