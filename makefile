LIBLIST= $(BIN_LIB)
CCSID=297

# The shell we use
SHELL=/QOpenSys/usr/bin/qsh

all: crtlib helloWorld.pgm calcul.pgm calculNew.pgm calculWnew.pgm divise.pgm diviseNew.pgm

# rules
crtlib: $(BIN_LIB).lib
helloWorld.pgm : helloWorld.rpgle
calcul.pgm : calcul.rpgle
calculNew.pgm : calculNew.rpgle
calculWnew.pgm : calculWnew.rpgle
divise.pgm : divise.rpgle
diviseNew.pgm : diviseNew.rpgle
init: yabug.msgf

%.lib:
	-system -q "CRTLIB $*"
	@touch $@

%.msgf:
	-system -q "CRTMSGF MSGF($(BIN_LIB)/$*)"
	-system -q "ADDMSGD MSGID(ERR0001) MSGF($(BIN_LIB)/$*) MSG('Bug dans le programme')"         
	-system -q "ADDMSGD MSGID(USR0001) MSGF($(BIN_LIB)/$*) MSG('Zone obligatoire !')"         
	-system -q "ADDMSGD MSGID(USR0002) MSGF($(BIN_LIB)/$*) MSG('Zone invalide !')"         

%.pgm:
	$(eval modules := $(patsubst %,$(BIN_LIB)/%,$(basename $(filter %.rpgle %.sqlrpgle,$(notdir $^)))))
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	liblist -af $(LIBLIST);\
	system "CRTPGM PGM($(BIN_LIB)/$*) MODULE($(modules))"
	@touch $@



%.rpgle: src/qrpgle/%.rpgle
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	liblist -af $(LIBLIST);\
	system "CRTRPGMOD MODULE($(BIN_LIB)/$*) SRCSTMF('$<') DBGVIEW($(DBGVIEW)) TGTCCSID($(CCSID))"
	@touch $@


%.entry:
    # Basically do nothing..
	@touch $@


clean:
	rm -f *.pgm *.rpgle *.sqlrpgle *.cmd *.srvpgm *.dspf *.bnddir *.entry *.inc *.cmp

	
release:
	@echo " -- Creating release. --"
	@echo " -- Creating save file. --"
	system "CRTSAVF FILE($(BIN_LIB)/RELEASE)"
	system "SAVLIB LIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/RELEASE) OMITOBJ((RELEASE *FILE))"
	-rm -r release
	-mkdir release
	system "CPYTOSTMF FROMMBR('/QSYS.lib/$(BIN_LIB).lib/RELEASE.FILE') TOSTMF('./release/release.savf') STMFOPT(*REPLACE) STMFCCSID(1252) CVTDTA(*NONE)"
	@echo " -- Cleaning up... --"
	system "DLTOBJ OBJ($(BIN_LIB)/RELEASE) OBJTYPE(*FILE)"
	@echo " -- Release created! --"
	@echo ""
	@echo "To install the release, run:"
	@echo "  > CRTLIB $(BIN_LIB)"
	@echo "  > CPYFRMSTMF FROMSTMF('./release/release.savf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/RELEASE.FILE') MBROPT(*REPLACE) CVTDTA(*NONE)"
	@echo "  > RSTLIB SAVLIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/RELEASE)"
	@echo ""
