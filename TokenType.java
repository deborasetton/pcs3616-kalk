/**
 * Tipos de token.
 */
public enum TokenType {

    /* Comentários */
    COMMENT_BLOCK,
    COMMENT_LINE,

    /* Números */
    NUM_INT,
    NUM_FLOAT,
    NUM_EXP,

    /* Identificador */
    IDENTIFIER,

    /* "Pontuação" */
    PARENS_OPEN,
    PARENS_CLOSE,
    STATEMENT_END,
    SIGN_EQ,

    /* Operador */
    OPERATOR_SIGN,
    OPERATOR,

    /* Espaços */
    LINE_TERMINATOR,
    WHITESPACE,

    /* Macros */
    MACRO_IDENTIFIER,
    MACRO_START,
    MACRO_LITERAL
}
