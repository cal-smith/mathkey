%lex
%%
\s+          /*ignores whitespace*/
/*greek symbols*/
"alpha"      return 'alpha';
"beta"       return 'beta';
[0-9]        return 'num';
/*binary operators*/
[\+\-\/\*]+  return 'oper';
/*binary relation*/
/*logical symbols*/
/*brackets*/
/*misc*/
/*math functions*/
/*arrows*/
/*fancy formatting math commands/functions*/
[a-z]        /*return 'word'; ignore words for now, might need to handle them later*/
<<EOF>>      return 'eof';

/lex

%start ascii
%%

ascii
 : contents eof
    { 
     return $1; 
    }
 ;

contents
 : content
    {
     $$ =  $1;
    }
 | contents content
    {
     $$ = $1 + $2;
    }
 ;

content
 : num
    {
     $$ = "<mn>" + $1 + "</mn>";
    }
 | oper
    {
     $$ = "<mo>" + $1 + "</mo>";
    }
 | alpha
    {
     $$ = "<mi>\u03B1</mi>";
    }
 | beta
    {
     $$ = "<mi>\u03B2</mi>";
    }
 | word/*handler for words may or may not be needed*/
    {
     $$ = "<mtext>" + $1 + "</mtext>";
    }
 ;