
include makefile_config


# The shell we use
SHELL=/QOpenSys/usr/bin/qsh


# Makefile for migrate project
include makefile_components


%.lib:
	-system -q "CRTLIB $*"
	@touch $@

%.pgm:
	$(eval modules := $(patsubst %,$(WRK_LIB)/%,$(basename $(filter %.rpgle %.sqlrpgle,$(notdir $^)))))
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	liblist -af $(LIBLIST);\
	system "CRTPGM PGM($(BIN_LIB)/$*) MODULE($(modules))"
	@touch $@
	system "DLTOBJ OBJ($(WRK_LIB)/*ALL) OBJTYPE(*MODULE)"

%.inc: include/%.rpgle
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	cp  '$<'  $(INC_LIB)
	@touch $@

%.rpgle: src/%.rpgle
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QRPGLESRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	liblist -af $(LIBLIST);\
	system "CRTRPGMOD MODULE($(WRK_LIB)/$*) SRCSTMF('$<') DBGVIEW($(DBGVIEW)) TGTCCSID($(CCSID))"
	@touch $@

%.sqlrpgle: src/%.sqlrpgle
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QRPGLESRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	liblist -af $(LIBLIST);\
	system "CRTSQLRPGI OBJ($(WRK_LIB)/$*) SRCSTMF('$<') COMMIT(*NONE) OBJTYPE(*MODULE) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID($(CCSID))') DBGVIEW($(DBGVIEWSQL))"
	@touch $@

%.clle: src/%.clle
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QCLSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	liblist -af $(LIBLIST);\
	#system "CRTBNDCL PGM($(BIN_LIB)/$*) SRCFILE($(SRC_LIB)/QCLSRC) SRCMBR(*PGM)"
	system "CRTBNDCL PGM($(BIN_LIB)/$*) SRCSTMF('$<') SRCMBR(*PGM)"
	@touch $@

%.cmd: src/%.cmd
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QCMDSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	system "CRTCMD CMD($(BIN_LIB)/$*) PGM($(BIN_LIB)/$*) SRCFILE($(SRC_LIB)/QCMDSRC)"
	# system "CRTCMD CMD($(BIN_LIB)/$*) PGM($(BIN_LIB)/$*) SRCSTMF('$<')"
	system "CHGCMD CMD($(BIN_LIB)/$*) PGM(*LIBL/$*)"
	@touch $@

%.srvpgm: src/%.bnd
	$(eval modules := $(patsubst %,$(WRK_LIB)/%,$(basename $(filter %.rpgle %.sqlrpgle,$(notdir $^)))))
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QSRVSRC.file/$*.mbr') MBROPT(*replace) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	#system "CRTSRVPGM SRVPGM($(BIN_LIB)/$*) MODULE($(patsubst %,$(WRK_LIB)/%,$(basename $^))) OPTION(*DUPPROC) SRCFILE($(SRC_LIB)/QSRVSRC)"
	liblist -af $(LIBLIST);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/$*) MODULE($(modules)) OPTION(*DUPPROC) SRCSTMF('$<')"

	@touch $@
	system "DLTOBJ OBJ($(WRK_LIB)/*ALL) OBJTYPE(*MODULE)"


%.dspf: src/%.dspf
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QDDSSRC.file/$*.mbr') MBROPT(*replace) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	liblist -af $(LIBLIST);\
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(SRC_LIB)/QDDSSRC) SRCMBR($*) REPLACE(*YES)"
	@touch $@

%.pf:
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('./src/$*.pf') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QDDSSRC.file/$*.mbr') MBROPT(*replace) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"
	system "CHGPF FILE($(DB_LIB)/$*) SRCFILE($(SRC_LIB)/QDDSSRC)"
	system "CHGPDMDFT USER($(CURRENT_USER)) OBJLIB(*SRCLIB) RPLOBJ(*YES) CRTBCH(*YES) RUNBCH(*YES) JOBD($(JOBD_ADMIN))"       
	SYSTEM "FNDSTRPDM STRING($*) FILE($(SRC_LIB)/QRPGLESRC) MBR(*ALL) OPTION(*CMPL) PRTMBRLIST(*YES)"             

	@touch $@

%.sql: sql/%.sql
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(SRC_LIB).lib/QSQLSRC.file/$*.mbr') MBROPT(*replace) STMFCCSID(*STMF) DBFCCSID(*FILE) STMFCODPAG(1208)"	
	liblist -c $(LIBLIST);\
	system "RUNSQLSTM SRCSTMF('$<') COMMIT(*NONE) NAMING(*SYS)"
	@touch $@

%.bnddir: 
	system "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1208)" 
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "ADDBNDDIRE BNDDIR($(BND_LIB)/$*) OBJ($(patsubst %.entry,(*LIBL/% *SRVPGM *IMMED),$^))"
	@touch $@

%.entry:
    # Basically do nothing..
	@touch $@

clean:
	rm -f *.pgm *.rpgle *.sqlrpgle *.cmd *.srvpgm *.dspf *.bnddir *.entry *.inc *.cmp
	-system "CLRLIB $(BIN_LIB)"
	-system "CLRLIB $(WRK_LIB)"
	-system "CLRLIB $(TST_LIB)"

%.tst: 
	liblist -af $(LIBLIST);\
	system "CRTRPGMOD MODULE($(TST_LIB)/$*) SRCSTMF('./test/$*.tst.rpgle') TGTCCSID(*JOB) DBGVIEW($(DBGVIEW)) REPLACE(*YES)"
	liblist -af $(LIBLIST);\
	system "CRTSRVPGM SRVPGM($(TST_LIB)/$*) BNDSRVPGM(RUTESTCASE) EXPORT(*ALL) OPTION(*DUPPROC) MODULE($(TST_LIB)/$*) BNDDIR(*LIBL/ARCHIAPI)"
	liblist -af $(LIBLIST);\
	system "RUCALLTST TSTPGM($(TST_LIB)/$*)"

	

	
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
