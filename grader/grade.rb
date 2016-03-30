#!/usr/bin/env ruby

NOISY_TYPES = [
  'COMMENT_BLOCK',
  'WHITESPACE',
  'COMMENT_LINE',
  'LINE_TERMINATOR'
]

['byebug', 'paint'].each do |lib|
  begin
    require(lib)
  rescue LoadError => e
    puts "Gem '#{lib}' não encontrada. Execute 'gem install #{lib}' e tente novamente."
    exit(1) 
  end
end

def grade_construction(test_file)
  construction_name = test_file.match(/\d_([^.]+)/)[1].capitalize

  basename = File.basename(test_file).match(/[^.]+/)[0]
  full_output_file = "grader/out/#{basename}.stdout"

  puts "Corrigindo: #{construction_name}"
  %x{  make run_file FILE=#{test_file} | tee #{full_output_file}  }

  if !test_file.match(/comments/)
    actual_file = remove_comments_and_whitespace(full_output_file)
  else
    actual_file = full_output_file
  end

  result = compare_files("grader/ref/#{basename}.ref", actual_file)

  if result
    puts Paint["[CORRETO] #{construction_name}", :green]
    return 1
  else
    puts Paint["[INCORRETO] #{construction_name}", :red]
    return 0
  end
end


def grade_constructions
  constructions_count = 0
  constructions_sum = 0

  Dir["test/*_*.kalk"].each do |filename|
    constructions_sum += grade_construction(filename)
    constructions_count += 1
    puts "\n"
  end

  constructions_grade = (constructions_sum.to_f / constructions_count) * 10

  if constructions_grade > 5
    puts Paint["Nota dos casos de sucesso (0-10): #{constructions_grade.round(2)}", :green]
  else
    puts Paint["Nota dos casos de sucesso (0-10): #{constructions_grade.round(2)}", :red]
  end
  
  constructions_grade
end

def grade_errors
  puts "Corrigindo: Tratamento de erros"
  
  output_file = "grader/out/errors.stdout"
  %x{  make run_file FILE=test/errors.kalk >#{output_file} 2>&1  }
  
  output = File.read(output_file)
  
  expected = "KalkLexerError: Caractere inválido: '?' (0:0)"
  
  if output[expected]
    puts Paint["[CORRETO] Tratamento de erros", :green]
    return 10
  else
    puts Paint["Mensagem de erro esperada não encontrada:", :blue]
    puts Paint[expected.inspect, :blue]
    puts Paint["[INCORRETO] Tratamento de erros", :red]
    return 0
  end
end

def remove_comments_and_whitespace(filename)
  lines = File.read(filename).split("\n")

  lines = lines.find_all do |line|
    !line.match(/\[COMMENT_BLOCK\]/) &&
    !line.match(/\[WHITESPACE\]/) &&
    !line.match(/\[COMMENT_LINE\]/) &&
    !line.match(/\[LINE_TERMINATOR\]/) &&
    line.match(/\A\d/)
  end

  basename = File.basename(filename).match(/[^.]+/)[0]
  stripped_output_file = "grader/out/#{basename}.stripped"

  File.open(stripped_output_file, "w") { |f| f.puts(lines.join("\n")) }
  stripped_output_file
end

def compare_files(expected, actual)
  puts Paint["Arquivo gerado: #{actual}", :blue]
  puts Paint["Arquivo esperado: #{expected}", :blue]

  actual_lines = File.read(actual).split("\n")
  expected_lines = File.read(expected).split("\n")

  is_equal = true

  expected_lines.zip(actual_lines).each do |pair|
    if pair.first != pair.last
      puts Paint["Esperado: #{pair.first.inspect}", :blue]
      puts Paint["Recebido: #{pair.last.inspect}", :blue]
      is_equal = false
      break
    end
  end

  is_equal
end

%x{ make build/KalkLexer.class && rm -rf grader/out && mkdir grader/out }

if $?.to_i != 0
  
  msg = []
  msg << "Erro ao compilar o projeto. Correção finalizada."
  msg << "Certifique-se de que `make build/KalkLexer.class` funciona e tente novamente."
  
  puts Paint[msg.join("\n"), :red]
  exit(1)
end 

if ARGV[0]
  grade_construction(ARGV[0])
else
  ex1 = grade_constructions
  puts "\n"
  ex2 = grade_errors
  
  final = ex1*0.9 + ex2*0.1
  
  puts "\n"
  puts "-------------------------------------------------------"
  if final > 5
    puts Paint["Nota final (0-10): #{final.round(2)}", :green]
  else
    puts Paint["Nota final (0-10): #{final.round(2)}", :red]
  end
end
