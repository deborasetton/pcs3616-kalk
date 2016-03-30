import java.io.*;

public class Main {

    /**
     * Programa principal exemplificando o uso do analisador léxico gerado pelo
     * JFlex.
     */
    static public void main(String args[]) {

        FileReader fileReader = null;

        /* Verificação dos parâmetros de entrada */
        if (args.length == 0) {
            System.err.println("[erro] Especifique um arquivo.");
            System.exit(1);
        } else if (args.length > 1) {
            System.err.println("[erro] Especifique apenas um arquivo.");
            System.exit(1);
        } else {
            try {
                fileReader = new FileReader(args[0]);
            } catch (FileNotFoundException e) {
                File dummy = new File(".");
                System.err.println("[erro] Arquivo não encontrado: " + args[0] + ". Diretório de busca: " + dummy.getAbsolutePath());
                System.exit(1);
            }
        }

        // Criar um novo lexer com o FileReader do arquivo de entrada.
        KalkLexer lexer = new KalkLexer(fileReader);

        // Executar o lexer até que não existam mais tokens na entrada.
    }
}

