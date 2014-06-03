%lex
%%
\s+          /*ignores whitespace*/
/*greek symbols*/
"alpha"          return 'alpha';
"beta"           return 'beta';
/*binary operators*/
[\+\-\/\*]+      return 'oper';
/*binary relation*/
/*logical symbols*/
/*brackets*/
/*misc*/
/*math functions*/
/*arrows*/
/*fancy formatting math commands/functions*/
[a-zA-Z0-9]+"^"[a-zA-Z0-9]+   return 'sup';
[0-9]            return 'num';
[a-z]            /*return 'word'; ignore words for now, might need to handle them later*/
<<EOF>>          return 'eof';

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
 | sup
    {
     if(!yy.lexer.supHandler) yy.lexer.supHandler = function(sup){
     	sup = sup.split("^");
     	var front = sup[0];
     	var back = sup[1];
     	if (front.match(/[0-9]+/)){
     		front = "<mn>"+ front + "</mn>";
     	} else {
     		front = "<mi>"+ front + "</mi>";
     	}
     	if (back.match(/[0-9]+/)){
     		back = "<mn>"+ back + "</mn>";
     	} else {
     		back = "<mi>"+ back + "</mi>";
     	}
     	var result = "<msup>" + front + back + "</msup>";
     	return result;
     };
     $$ = yy.lexer.supHandler(yytext);
    }
 | word/*handler for words may or may not be needed*/
    {
     $$ = "<mtext>" + $1 + "</mtext>";
    }
 ;