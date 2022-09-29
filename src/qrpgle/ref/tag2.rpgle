**free
/if defined(TAG_H_DEFINED)
/eof
/endif
/define TAG_H_DEFINED
/copy '/home/NOVY400/include/CKOOL.rpgle'
/copy '/home/NOVY400/include/ADMIN.rpgle'

dcl-ds FMT_TAGS ext extname('TAGS') qualified end-ds;
dcl-s TAG_test char(10);
//------------------------------------------------------------------//
// printf (c)                                                       //
//------------------------------------------------------------------//
///
// Bonjour le Monde !
// Un petit programme exemple pour tester Code For IBMi!
// Description can be multiline
// @tag data
// @tag data
///
dcl-ds TAG_TagDetails template qualified;
    id like(FMT_TAGS.id);
    name like(FMT_TAGS.TNAME);
    description  like(FMT_TAGS.TDESC);
end-ds;
dcl-ds TAG_TagListe template qualified;
dcl-ds datas;
dcl-ds item likeds(TAG_TagDetails) dim(999);
end-ds;
totalCount like(ADMIN_totalCount);
end-ds;
///
// Bonjour le Monde !
// Un petit programme exemple pour tester Code For IBMi!
// Description can be multiline
// @tag data
// @tag data
///
dcl-pr TAG_getListTag ind extproc(*dclcase);
   context likeDS(ADMIN_Context) const;
   datas likeDS(TAG_TagListe);
   errors likeDS(ADMIN_listeError);
end-pr;

