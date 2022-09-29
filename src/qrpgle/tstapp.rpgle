**free
///
// Bonjour le Monde !
// Un petit programme exemple pour tester Code For IBMi!
// Description can be multiline
// @tag data
// @tag data
///  
// /copy './tag2.rpgle'
// /copy 'tag2.rpgle'
/copy 'tag2.rpgle'
/copy 'CKOOL.rpgle'
/copy 'copytest.rpgle'

// /copy '/home/NOVY400/include/TAG1.rpgle'
// /copy qrpgleref,tag
dcl-s gMsg char(25);
TAG_getListTag(context:datas:errors)
gMsg = 'Bonjour Carquefou';
TAG_getListTag(context:datas:errors)

dsply gMsg;
return;