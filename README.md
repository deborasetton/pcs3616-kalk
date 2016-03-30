# Analisador sintático para a linguagem Kalk

O laboratório consiste em implementar um analisador sintático para a linguagem Kalk, uma linguagem fictícia de uma calculadora simples, usando o JFlex.

Além de gerar o analisador, você também deve implementar um pequeno programa principal para testá-lo. O objetivo deste programa será simplesmente imprimir, um a um, os tokens identificados pelo _lexer_, conforme mostrado mais abaixo.

O trecho abaixo é um programa válido em Kalk, e fornece uma visão geral da linguagem:

```
/**
 * Um programa-exemplo em Kalk.
 */
 
// Declaração de uma macro
$EXP: (_var1 + _var2);
 
// Atribuição de variáveis
_var1 = 3;
_var2 = 4.7;

result = $EXP / 10_000;
result = result + 1;
```

Como você pode ver, a linguagem é bastante limitada. Os tipos de construções suportados são:
1. Comentários (de bloco e de linha)
2. Identificadores (nomes de variáveis)
3. Números (inteiros, floats e exponenciais)
4. Operações matemáticas
5. Comandos (atribuições e expressões)
6. Macros

Cada uma destas construções está descrita em detalhes nos arquivos de teste correspondentes. Por exemplo, a especificação de um comentário, juntamente com exemplos válidos, pode ser encontrada em `test/0_comments.kalk`.

### Formato de saída

Para um arquivo de entrada válido, o seu programa principal deve imprimir cada token em uma linha com o seguinte formato:

```
TOKEN_NUMBER) [LINE:COL] [TOKEN_TYPE] [TOKEN_VALUE]
```

Em que:
- **TOKEN_NUMBER** é um contador que começa em 1 e é incrementado a cada token impresso. Imprimir com 3 dígitos (`%03d`), conforme exemplo abaixo.
- **LINE** é o número da linha (`yyline`)
- **COL** é o número da linha (`yycolumn`)
- **TOKEN_TYPE** é o tipo do token (ver arquivo `TokenType.java`)
- **TOKEN_VALUE** é a string que representa o token (`yytext()`)

#### Exemplo de execução de sucesso

Arquivo de entrada:
```
// Comentário.
var1 = (a + b) / 2
```

Saída:
```
001) [1:0] [COMMENT_LINE] // Comentário.

002) [2:0] [IDENTIFIER] var1
003) [2:4] [WHITESPACE]
004) [2:5] [SIGN_EQ] =
005) [2:6] [WHITESPACE]
006) [2:7] [PARENS_OPEN] (
007) [2:8] [IDENTIFIER] a
008) [2:9] [WHITESPACE]
009) [2:10] [OPERATOR_SIGN] +
010) [2:11] [WHITESPACE]
011) [2:12] [IDENTIFIER] b
012) [2:13] [PARENS_CLOSE] )
013) [2:14] [WHITESPACE]
014) [2:15] [OPERATOR] /
015) [2:16] [WHITESPACE]
016) [2:17] [NUM_INT] 2
017) [2:18] [LINE_TERMINATOR]
```

### Tratamento de erros

Em caso de erro, o _lexer_ deve lançar uma exceção do tipo `KalkLexerError` com a mensagem:

```
Caractere inválido: 'YYTEXT' (YYLINE:YYCOLUMN)
```

#### Exemplo de execução com erro

Arquivo de entrada:
```
?!!@
```

Saída:
```
Error in file: test/errors.kalk
KalkLexerError: Caractere inválido: '?' (0:0)
        at KalkLexer.yylex(KalkLexer.java:859)
        at Main.main(Main.java:36)
```


### Como testar o seu lexer com um arquivo qualquer de entrada

```
make run_file FILE=caminho/para/um/arquivo.kalk
```

#### Correção

- Corrigir apenas um tipo de construção:
   ```
   grader/grade.rb test/1_identifiers.kalk
   ```
   
- Corrigir todas as construções e casos de erro:
   ```
   grader/grade.rb
   ```

#### Entrega

Entregar um arquivo zip, `kalk.zip` contendo **apenas** os seguintes arquivos:
- kalk.flex
- Main.java
