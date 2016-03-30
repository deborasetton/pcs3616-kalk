/**
 * Erro lançado quando o lexer encontra um caractere inválido.
 */
public class KalkLexerError extends Exception {
    public KalkLexerError(String message) {
        super(message);
    }
}
