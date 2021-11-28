# Trabalho 1 - PFL
### Autores:
* Amanda Silva - [up201800698](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201800698)
* Rafael Camelo - [up201907729](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201907729)


## Fibonacci
 **fibRec**: A mais simples e mais intuitiva das funcoes de fibonacci é feita por recursão. A função `fibRec n` retorna `fibRec (n - 1) + fibRec (n - 2)`.
 
 **fibLista**: A função `fibLista` usa uma estratégia similiar à função de fibonacci recursiva mas guarda os resultados parciais da sequência de fibonacci e usa-os para calcular o elemento seguinte até ao elemento pedido.
 
 **fibListaInfinita**: Para a lista infinita tambem fazemos uma chamada recursiva aonde adicionamos com zipwith a lista e a suas Tail. Desse modo é feita a soma de index n com index (n + 1).

````ruby 
*Main> fibRec 10
55
*Main>  fibLista 10
55
*Main>  fibListaInfinita 10
55
```` 
````ruby 
*Main> fibRec 22
17711
*Main>  fibLista 22
17711
*Main>  fibListaInfinita 22
17711
```` 
## BigNumbers

### SomaBN e SubNB

Primeiro, observamos que uma função que soma dois inteiros pode ser expressa por meio de duas outras funções que lidam apenas com valores absolutos:

* uma função que adiciona os valores absolutos de dois inteiros; e
* uma função que subtrai os valores absolutos de dois inteiros.

É possível porque:
 
>  |a| + |b| = |a| + b
>
>  −|a| + (−|b|) = −(|a| + b) 
>
>  |a| + (−|b|) = |a| − |b|
>
>  −|a| + |b| = |b| − |a|


Desse modo chegamos ao seguintes algoritmos para as funçoes: 

**SomaBN** - Para fazer a adicao  o melhor metodo é o de adicao de colunas ( metodo aprendido no primario) 
Pegamos o dígito menos significativo do primeiro bignum, pegamos o dígito menos significativo do segundo bignum, somamos com o carry, se a adicao for maior que 10 o carry da chamda recursiva tera o valor 1 (resultado/10, se  resultado menor do dez o carry tera valor zero se nao será um). A funcao é chamada recursivamente até chegar ao ultimo digito da lista.  


Testes SomaBN:
````ruby 
output (somaBN [1,2,3] [3,2,1]) == "444"
True

output (somaBN [9,9,9] [9,9,9,9]) == "10998"
True

output (somaBN [9,9,-9] [9,9,9,9]) == "9000"
True

output (somaBN [9,9,9] [9,9,9,-9]) == "-9000"
True

output (somaBN [9,9,-9] [9,9,9,-9]) == "-10998"
True
```` 


**SubBN** - A funcao de subtracao  é muito semelhanta a de adicao. Utilizamos o metodo de colunas. Caso a equacao,  res = a - b - carry  fosse menor que zero carry teria valor um e adicionamos a lista o seguinte valor; 10 * carry + res.

Testes SubBN:
````ruby
output (subBN [1,2,3] [3,2,1]) == "198" 
True

output (subBN [9,9,9] [9,9,9,9]) == "-9000"
True

output (subBN [9,9,-9] [9,9,9,-9]) == "9000"
True

output (subBN [9,9,9] [9,9,9,-9]) == "10998"
True
```` 
### MulBN

No casa da multiplicação, tomamos inspiração da `somaBN` e divimos a multiplicação em dois casos:
 1. No primeiro caso, ambos elementos são positivos ou ambos são negativos, assim o resultado será sempre positivo, logo podemos converter, caso seja necessário, os numeros em positivos, através da função ``toPos`` que usa a função `abs` do haskell.
 2. Num segundo caso, um dos elementos é negativo e o outro positivo, para calcular o produto de dois números com sinais diferentes calculamos o produto dos mesmos com sinal positivo e convertamos o resultado em negativo.


De seguida, tendo a garantia de que os números estão positivos separamos o processo em três partes:

1. Multiplicamos o digito menos significativo do segundo número (**y**)  pelo primeiro número por completo (**xs**). Usamos uma estratégia de guardar um valor **carry** e soma-lo à multiplicação de y pelo primeiro elemento de xs (**x**), de seguida damos append ao inicio do novo *BigNumber* o resto da divisão por 10 do valor calculado anteriormente, isto é `(carry + y * x) mod 10` e chamamos a mesma função recursivamente para o resto de xs atualizando o carry para `(carry + y * x) div 10`
2. Fazemos o ponto 1. para todos os elementos do segundo número (**ys**) multiplicando-os pelo exponencial de 10 à sua posição, pois os *BigNumbers* estão guardados de forma inversa, isto é multiplicamos o elementos das unidades de ys por 1, o elemento das dezenas por 10, o das centenas por 100, o dos milhares por 1000 e assim até ao último elemento de ys.
3. Utilizamos a função `somaBN` para somar todos os *BigNumbers* obtidos em 2. de forma recursiva.

````ruby
*Main> 248 * 357
88536
*Main> output(mulBN (scanner "248") (scanner "357"))
"88536"
*Main> output(mulBN (scanner "-248") (scanner "357"))
"-88536"                                                      *Main> 678 * 123
83394
*Main> output(mulBN (scanner "678") (scanner "-123"))
"-83394"
*Main> output(mulBN (scanner "-678") (scanner "-123"))
"83394"
````
### DivBN
 Para  divisao optamos utilizar o metododo  de Divisão por subtração repetida. Aonde O valor do Denominador é subtraido do Resto e  1 é adionado ao quociente até o Resto ser Menor/Igual ao Denomindor.
 Exemplo: 
 > 38 dividido por 5:
 >  * **1.** 38 - 5 = 33
 >  * **2.** 33 - 5 = 28
 >  * **3.** 28 - 5 = 23
 >  * **4.** 23 - 5 = 18
 >  * **5.** 18 - 5 = 13
 >  * **6.** 13 - 5 = 8
 >  * **7.** 8 - 5 = 3 
 >
 >
 >  **Resultado:** Quociente = 7 Resto = 3 

Testes DivBN:

````ruby
*Main> divBN [5] [1]
([5],[])

*Main> divBN [0,0,3] [5,1]
([0,2],[0])

*Main> divBN [4,1,3] [5,1]
([0,2],[4,1])

*Main> divBN [4,1,3] [5,-1]
([0,-2],[4,1])

*Main> divBN [4,1,-3] [5,-1]
([0,2],[4,1])
````




