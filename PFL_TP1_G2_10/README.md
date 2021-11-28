# Trabalho 1 - PFL
* Amanda Silva - up201800698
* Rafael      - up 


## Fibonacci
 **fibRec:** A mais simples das funcoes de fibonacci é feito tem um output de fibRec ( n - 1) + fibRec ( n - 2).
 
 **fibLista:**
 
 **fibListaInfinita:**  Para a lista infinita tambem fazemos uma chamada recursiva aonde adicionamos com zipwith a lista e a suas Tail. Desse modo é feita a soma de index n com index (n + 1).
 
 * Testes Fib:
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
* Testes fibBN:
````ruby 
*Main> fibRecBN 22
 [1,1,7,7,1]
*Main>  fibListaBN 22
 [1,1,7,7,1]
*Main>  fibListaInfinitaBN 22
 [1,1,7,7,1]
```` 
## BigNumbers

### SomaBN e SubNB

Primeiro, observamos que uma função que soma dois inteiros pode ser expressa por meio de duas outras funções que lidam apenas com valores absolutos:

* uma função que adiciona os valores absolutos de dois inteiros; e
* uma função que subtrai os valores absolutos de dois inteiros.

É possível porque:
 
>                   −|a|+(−|b|)=−(|a|+b) 
>                  a|+(−|b|)=|a|−|b|
>                   −|a|+|b|=|b|−|a|

Desse modo chegamos ao seguintes algoritmos para as funçoes: 

**SomaBN** - Para fazer a adicao  o melhor metodo é o de adicao de colunas ( metodo aprendido no primario) 
Pegamos o dígito menos significativo do primeiro bignum, pegamos o dígito menos significativo do segundo bignum, somamos com o carry, se a adicao for maior que 10 o carry da chamda recursiva tera o valor 1 (resultado/10, se  resultado menor do dez o carry tera valor zero se nao será um). A funcao é chamada recursivamente até chegar ao ultimo digito da lista.  


Testes SomaBN:
````ruby 
output (somaBN[1,2,3] [3,2,1]) == "444"
True

output (somaBN[9,9,9] [9,9,9,9]) == "10998"
True

output (somaBN[9,9,-9] [9,9,9,9]) == "9000"
True

output (somaBN[9,9,9] [9,9,9,-9]) == "-9000"
True
```` 




**SubBN** - A funcao de subtracao  é muito semelhanta a de adicao. Utilizamos o metodo de colunas. Caso a equacao,  res = a - b - carry  fosse menor que zero carry teria valor um e adicionamos a lista o seguinte valor; 10 * carry + res.

Testes SubBN:
````ruby
output (subBN[1,2,3] [3,2,1]) == "198" 
True

output (subBN[9,9,9] [9,9,9,9]) == "-9000"
True

output (subBN[9,9,-9] [9,9,9,-9]) == "9000"
True

output (subBN[9,9,9] [9,9,9,-9]) == "10998"
True
```` 
### MulBN
````ruby
*Main> mulBN [0,0,2] [0,5]
[0,0,0,0,1]
*Main> mulBN [0,0,-2] [0,5]
[0,0,0,0,-1]
*Main> mulBN [0,0,-2] [0,-5]
[0,0,0,0,1]
*Main> mulBN [0,0,2] [0,-5]
[0,0,0,0,-1]
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

                


