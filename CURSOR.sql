CURSOR

--Nada mais é que um objeto e declarar e mandar executar na hora da programação estruturada
--Carrega tudo o que foi lido pelo SELECT
--Só que quando faz um select de 100 linhas, ele não le 100 linhas, só le uma a uma
--Carregar esse select em um objeto - mando carregar para a memória e posso dizer para ler a primeira e cada uma em seguida até o final
--Declaro o objeto cursos
--Pode estourar a memória
--Fetch - le o cursor e carrega o valor do select nessa variável
--Fechar o cursor

EXEMPLO 1

DO $$
DECLARE

	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN
	OPEN cur_pessoas;
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;
	
	CLOSE cur_pessoas;
END $$;

/////////////////////////////////////////////////////

EXEMPLO 2

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN
	OPEN cur_pessoas;
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;	
	
	CLOSE cur_pessoas;
END $$;

/////////////////////////////////////////////////////

EXEMPLO 3

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN
	OPEN cur_pessoas;
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;
	
	OPEN cur_pessoas; --Não consigo abrir um objeto que já está aberto
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	OPEN cur_pessoas;

	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	OPEN cur_pessoas;

	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;	
	
	CLOSE cur_pessoas;
END $$;

/////////////////////////////////////////////////////

EXEMPLO 4  

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN
	OPEN cur_pessoas;
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;
	
	CLOSE cur_pessoas;
	
	OPEN cur_pessoas; 
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	CLOSE cur_pessoas;
	
	OPEN cur_pessoas; 
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;

	CLOSE cur_pessoas;
	
	OPEN cur_pessoas; 
	
	FETCH cur_pessoas INTO l_nome_pes;
	
	RAISE NOTICE 'Pessoa: % ', l_nome_pes;	
	
	CLOSE cur_pessoas;
END $$

/////////////////////////////////////////////////////

EXEMPLO 5 CURSOR + ESTRUTURA DE REPETIÇÃO

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN

	OPEN cur_pessoas;
	
	WHILE NOT l_nome_pes ISNULL LOOP
		FETCH cur_pessoas INTO l_nome_pes;
		
		IF l_nome_pes ISNULL THEN 
			EXIT;
		END IF;
		
		RAISE NOTICE 'Pessoa: % ', l_nome_pes;
		
	END LOOP;

	CLOSE cur_pessoas;

END $$;

/////////////////////////////////////////////////////

EXEMPLO 6 CURSOR + ESTRUTURA DE REPETIÇÃO + VERIFICAÇÃO SE FETCH TEM RETORNO

DO $$
DECLARE 
	l_nome_pes VARCHAR(100) := '';
	cur_pessoas CURSOR FOR SELECT nome FROM pessoas;
BEGIN
	OPEN cur_pessoas;
	
	LOOP
		FETCH cur_pessoas INTO l_nome_pes;
		
		RAISE NOTICE 'Pessoas: % ', l_nome_pes;
		
	END LOOP;
	
	CLOSE cur_pessoas;
	
	--Em que condição tem que sair
	
END $$;

/////////////////////////////////////////////////////

CONVERTER OS DOIS EXERCÍCIOS ÚLTIMOS PARA CURSOR

EXERCÍCIO 4 CONVERTIDO PARA CURSOR
	/*CRIAR UM BLOCO DE PROGRAMAÇÃO ESTRUTURADA PARA RETORNAR O NOME DAS PESSOAS, E A
	SOMATÓRIA DOS VALORES DE VENDA REALIZADOS PARA AQUELA PESSOA.
	INFORMAR VIA MENSAGEM SE O VALOR DE COMPRA DO CLIENTE ESTÁ ACIMA, ABAIXO DA MÉDIA,
	OU IGUAL AO VALOR MÉDIO DE COMPRAS POR CLIENTE.*/

DO $$
DECLARE

	l_codigo INTEGER := 0;
	l_nome_pes VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0;
	cur_pessoas CURSOR FOR SELECT pessoas.i_pessoa, pessoas.nome, --E
								SUM (vendas.valor)  
							FROM vendas INNER JOIN pessoas 
								ON (vendas.i_pessoa = pessoas.i_pessoa)
							GROUP BY pessoas.i_pessoa
							ORDER BY pessoas.i_pessoa;				
BEGIN

	SELECT SUM(valor)/(SELECT COUNT(*) FROM pessoas) --SOMATORIA DOS VALORES DE VENDA DIVIDIDO PELA QUANTIDADE DE PESSOAS
		INTO l_media 
		FROM vendas;
				
	OPEN cur_pessoas;
	
	LOOP
		FETCH cur_pessoas INTO l_codigo, l_nome_pes, l_valor;
		IF NOT FOUND THEN
			EXIT;
		END IF;	
	
		RAISE NOTICE 'Pessoa: % - valor: % ', l_nome_pes, l_valor; --VALOR DE COMPRA DO CLIENTE
			
			
		IF l_valor > l_media THEN
			RAISE NOTICE 'As compras de % estão acima da média de: % ', l_nome_pes, l_media; --MÉDIA DE COMPRA
		ELSIF l_valor < l_media THEN
			RAISE NOTICE 'As compras de % estão abaixo da média de: % ', l_nome_pes, l_media;
		ELSE
			RAISE NOTICE 'As compras de % estão iguais a média de: % ', l_nome_pes, l_media;
		END IF;	
	
	END LOOP;
	
	CLOSE cur_pessoas;
END $$

---

EXERCÍCIO 5 CONVERTIDO PARA CURSOR
	/*CRIAR UM BLOCO DE PROGRAMAÇÃO ESTRUTURADA PARA RETORNAR NOME DOS
	PRODUTOS, E, A MÉDIA DOS VALORES DE VENDA REALIZADOS PARA AQUELE PRODUTO.
	INFORMAR VIA MENSAGEM SE O VALOR MÉDIO DE COMPRA DAQUELE PRODUTO ESTÁ
	ACIMA, ABAIXO, OU IGUAL AO VALOR MÉDIO DE COMPRAS POR PRODUTO.*/

DO $$
DECLARE

	l_codigo INTEGER := 0;
	l_nome_prod VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0; 
	cur_produtos CURSOR FOR SELECT produtos.i_produto, produtos.nome, 
									AVG (itens_vendas.valor_venda * quantidade)
							FROM itens_vendas INNER JOIN produtos
								ON (itens_vendas.i_produto = produtos.i_produto)
							GROUP BY produtos.i_produto;
BEGIN

	SELECT SUM(valor_venda * quantidade)/(SELECT COUNT(*) FROM produtos) 
		INTO l_media 
		FROM itens_vendas;
		
	OPEN cur_produtos;
			
	 LOOP
		FETCH cur_produtos INTO l_codigo, l_nome_prod, l_valor;				
				
		IF NOT FOUND THEN	
			EXIT;
		END IF;
		
		RAISE NOTICE 'Pessoa: % - valor: % ', l_nome_prod, l_valor;		
			
		IF l_valor > l_media THEN
			RAISE NOTICE 'As compras de: % estão acima da média: % ', l_nome_prod, l_media;
		ELSIF l_valor < l_media THEN
			RAISE NOTICE 'As compra de compras de: % estão abaixo da média: % ', l_nome_prod, l_media;
		ELSE
			RAISE NOTICE 'As compras de: % estão iguais a média: % ', l_nome_prod, l_media;
		END IF;
		
	END LOOP;
	
	CLOSE cur_produtos;
END $$;

/////////////////////////////////////////////////////

CRIAR UM BLOCO DE PROGRAMAÇÃO ESTRUTURA PARA:
- CRIAR UM CAMPO DE DESCONTO NA TABELA VENDA;
-VERIFICAR SE O SOMATÓRIO POR VENDA DE (VALOR_VENDA DA TABELA ITENS_VENDAS
MULTIPLICADO PELO CAMPO QUANTIDADE) É IGUAL AO CAMPO VALOR DA TABELA DE VENDAS
PARA O RESPECTIVO CÓDIGO DE VENDA;
- CASO O VALOR DA TABELA DE VENDA SEJA MENOR QUE A VERIFICAÇÃO DOS ITENS,
SETAR A DIFERENÇA COMO DESCONTO, CASO CONTRÁRIO O DESCONTO SERÁ ZERO. E O CAMPO
VALOR DA TABELA DE VENDA DEVE PASSAR A SER IGUAL AO CÁLCULO DE SEUS ITENS;

alter table vendas add desconto numeric(12,2);

commit;

DO $$
DECLARE
	i_venda INTEGER := 0;
	l_valor_venda NUMERIC(12,2) := 0;
	l_valor_itens NUMERIC(12,2) := 0;
	l_valor_desc NUMERIC(12,2) := 0;
	
	cur_vendas CURSOR FOR SELECT i_venda, valor FROM vendas; --Variável, chamada do cursor e select
	--Cursor baseado na venda -se não bater com aquela venda eu decido o que faço
	--Manda carregar o select dentro dessa variável
	
BEGIN

	OPEN cur_vendas; --Mandei carregar na memória

	LOOP
		--O Fetch manda trazer a primeira e depois a próxima linha 
		FETCH cur_vendas INTO l_venda, l_valor_venda; 					
		IF NOT FOUND THEN	
			EXIT;
		END IF;
		
		SELECT SUM(valor_venda * quantidade) 
			INTO l_valor_itens
			FROM itens_vendas
		   WHERE itens_vendas.i_venda =  l_venda;

		
		IF l_valor_venda < l_valor_itens THEN
			l_valor_desc := l_valor_itens - l_valor_venda; 	
		ELSE 
			l_valor_desc := 0;
		END IF;
		
		UPDATE vendas
			SET valor = l_valor_itens,
				desconto = l_valor_desc
		  WHERE i_venda = l_venda;
	
	END LOOP;
	
	CLOSE cur_vendas;
	
	COMMIT; 
	
END $$;
