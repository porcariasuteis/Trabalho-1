# TP1 INFO7015 - Tópicos em Redes de Computadores

 Relatório da tentativa de reprodução do artigo "Jellyfish: Networking Data Centers Randomly".



# Desenvolvimento

##### Que problema a Jellyfish estava tentando resolver? Qual era o estado da arte no momento em que o artigo foi publicado?
Segundo os autores, o principal problema encontrado nas topologias direcionadas a data centers na época do artigo, era a expansão incremental. As topologias para redes de alta capacidade em 2012 não contornavam a expansão incremental de forma simplificada, sendo necessária uma grande troca de elementos da rede e de cabeamento. As propostas mais comuns eram o fat-tree (folded-Clos), estruturas que utilizavam servidores para encaminhamento e redes ópticas. Existiam outras propostas que tratavam o problema de ampliação, porém algumas falhas foram apontadas pelos autores em todas elas. O MDCube permitia o crescimento de forma gradual mas muito rudimentar, o Dcell e o Bcube permitia o crescimento somente para um numero de servidores previamente conhecido. Existiam ainda propostas similares ao Jellyfish para randomizar as novas conexões, porém elas seriam inferiores ao Jellyfish por necessitarem alguma correlação entre os dispositivos de fim.

##### Um breve resumo dos métodos e resultados do artigo original (com foco especial na Figura 9 e na Tabela 1).
Além do problema da expansão incremental a jellyfish tinha como objetivo melhorar o throughput em topologias baseadas em árvore. Os autores explicam que conseguiram estas duas características principais, através de um sistema randômico de conexões para novos ativos ou servidores. A flexibilidade de conexão para novos componentes permitiria agregar ativos independente da quantia de portas, trazendo grande vantagem sobre as tecnologias baseadas em árvore. Para adicionar um novo ativo na rede, aleatoriamente é escolhido um link na rede atual, este link é removido liberando automaticamente duas portas. As duas portas liberadas são conectadas ao novo ativo. Este processo se repete enquanto houverem portas disponíveis no novo ativo (duas ao menos).
<p align="center">  <img src="https://image.ibb.co/bHjMrp/jelly.png" alt="jelly" border="0"></p>
Segundo os autores, o redimensionamento também seria vantajoso financeiramente e não traria grandes dificuldades para alterar o layout do cabeamento. O aumento do throughput seria outro benefício, no artigo os autores especificam 25% a mais de servidores utilizando toda a largura de banda quando comparado com o Fat-Tree com os mesmos equipamentos, uma das razões é que a topologia do Jellyfish permitiria um melhor uso dos algoritmos de roteamento com multi caminhos. Para ilustrar melhor podemos observar a Figura 1 do trabalho aonde notamos que o Jellyfish precisa de menos saltos (caminhos mais curtos) para alcançar toda a amplitude da rede, porém é valido salientar que a possibilidade de existirem múltiplos caminhos será maior de acordo com o tamanho (quantia de ativos, servidores, etc) da rede.

Na Figura 9 notamos exatamente como a utilização do algoritmo k-shortest se beneficia da topologia do jellyfish, podendo utilizar mais caminhos distintos em uma mesma quantia de links quando comparado ao ECMP (Equal Cost Multipath Routing). Na Tabela 1 podemos observar vários testes na topologia Fat-Tree e Jellyfish, utilizando controles de congestionamento distintos (TCP 1 e 8 fluxos e MPTCP) e dois algoritmos de roteamento (ECMP e K-Shortest-Path). Na topologia Fat-Tree as diferenças mais notáveis estão na utilização de múltiplos fluxos, os números do TCP e do MPTCP foram similares (92,2% de utilização no TCP e 93,6% no MPTCP). Os valores do jellyfish utilizando o algoritmo k-shortest foram muito parecidos com a topologia Fat-Tree, o mais perceptível é o quanto a topologia jellyfish se beneficia do k-shortest-path quando comparado ao ECMP.
<p align="center">  <img src="https://image.ibb.co/jfL5HU/dados_originais.png" alt="dados_originais" border="0"></p>

##### Detalhe sobre sua abordagem para reproduzir a figura. Se você escolheu uma plataforma ou ferramenta específica, explique por que você fez essa escolha. Destaque as vantagens da sua abordagem, bem como quaisquer inconvenientes. Houve algum desafio que você acertou ou suposições que você precisava fazer?
Para reprodução da figura o simulador utilizado foi o Mininet na versão 2.2.2. disponível em http://mininet.org/download/ e  Python 3.5.2 instalado dos repositórios do Debian Linux. A escolha do Mininet foi baseada na ampla quantidade de exemplos e modelos disponíveis. Os experimentos foram executados em servidores criados na Google Cloud devido ao maior poder de processamento a possibilidade de execução de experimentos longos sem a necessidade de paralisação. Foram utilizadas duas instâncias de máquinas virtuais conforme segue:

Máquina n1-standard-4 (4 vCPUs, 15 GB de memória) e 30 GB de disco rodando Debian GNU/Linux 9 Kernel 4.9.0-8

Máquina n1-standard-4 (4 vCPUs, 15 GB de memória) e 30 GB de disco rodando Debian GNU/Linux 9 Kernel 4.9.0-8 com MPTCP compilado no Kernel, seguindo as instruções encontradas em: https://multipath-tcp.org/pmwiki.php/Users/DoItYourself
A escolha da utilização de duas máquinas, uma com TCP e outra com MPTCP é justificada porque os resultados ao desabilitar o MPTCP no kernel estavam inconsistentes.

As principais dificuldades foram inicialmente relacionadas à falta de prática com o simulador e a linguagem Python. A compilação do Kernel foi trabalhosa, uma vez que o tutorial do projeto não é exatamente passo a passo, assumindo que o usuário tenha experiência prévia.
Existiam trabalhos anteriores tentando reproduzir o experimento citado no artigo, e um destes trabalhos foi utilizado como base na construção tanto da figura quanto da tabela. O trabalho que serviu de referência foi de autoria de Jean-Luc Watson, https://github.com/jlwatson , mas no trabalho original os valores não eram exibidos integralmente por conta de uma falha de comunicação entre o Iperf https://iperf.fr/ e o Mininet, esta mesma falha é reportada em outros testes similares, inclusive por outros alunos que tentaram reproduzir o artigo. Ao entrar em contato com o autor, obtive a seguinte resposta

**...“If I recall correctly, it came down to issues with the simulation, even though the overall setup for the experiment is correct. We were having a great deal of trouble getting Mininet to limit the bandwidth on each link when running the iperf tests, which might be due to the specific version we're using (2.2.2).”**

Com base na resposta verificou-se a saída dos testes, e muitos dos testes realizados via Iperf não recebiam resposta correta. Em algumas situações os testes eram computados como tráfego de 0KB/s, em outras situações o limite de largura de banda estipulado no código era ultrapassado (transmissão de 500 Mb/s em um canal de 100 Mb/s) , gerando valores médios alterados para mais ou menos.

Durante o desenvolvimento do trabalho, várias fontes foram consultadas, incluindo o vídeo [Fishbowl Seminar: Jellyfish: Networking Data Centers Randomly](https://youtu.be/yEjcZC34qNo "Fishbowl Seminar: Jellyfish: Networking Data Centers Randomly") de um dos autores P. Brighten Godfrey, aonde algumas considerações são expostas de forma distinta ao trabalho original. Godfrey afirma que a topologia o protocolo ECMP não deve ser considerado quando utilizamos a topologia Jellyfish, e que o TCP e o MPTCP funcionam de forma muito próxima para a Jellyfish, sendo o mais importante o algoritmo de roteamento. Muito embora seja possível observar tendências confirmem estas considerações, elas não estão explícitas no artigo. Outro ponto não explicado integralmente se refere a utilização de quantidades de servidores diferentes na comparação da Jellyfish e da Fat-tree.

##### Qual o resultado que você conseguiu? Correspondeu ao papel original?
Os resultados obtidos foram fiéis ao original em vários pontos, porém foram discrepantes em outros. O gráfico na Figura 9 é muito próximo do original, uma vez que utiliza métodos matemáticos para calcular a diversidade de caminhos de acordo com a quantidade de links. Para construção da Figura 9, podemos utilizar a mesma topologia do trabalho original, com 686 servidores conforme os testes realizados no artigo. 

**Reprodução da Figura 9**
<p align="center">  <img src="https://image.ibb.co/bXymP9/figure9repro.png" alt="dados_originais" border="0"></p>

Na tabela os resultados foram mais divergentes pela limitação do ambiente de testes. No teste realizado foram utilizados 20 servidores e 32 switches com 6 portas cada, outras configurações foram testadas, porém a que melhor conseguiu realizar os testes até o fim foi esta. Em algumas ocasiões a simulação terminava sem resultados, mas não foi possível determinar se o problema era no código ou na máquina virtualizada, sendo necessário reiniciar a instância virtualizada e retomar os testes. A limitação da topologia testada torna difícil uma comparação mais aproximada com o trabalho original, porém as tendências são similares, sendo a mais notável a melhora de desempenho quando utilizamos o jellyfish com mais fluxos e com o MPTCP. Os testes com um fluxo funcionam razoavelmente bem, porém quando utilizamos o MPTCP e oito fluxos os resultados são insatisfatórios, provavelmente porque a quantia de servidores, switches e portas não cria uma diversidade muito grande de caminhos. Os resultados abaixo representam a saída do programa sendo executado uma vez para o TCP e uma para o MPTCP.

**TCP**
<p align="left">  <img src="https://image.ibb.co/d3F0HU/print_tcp.png" alt="dados_originais" border="0"></p>

**Médias de 3 execuções válidas**

| 20 Servers  | ECMP  | 8-shortest paths  |
| ------------ | ------------ | ------------ |
| TCP 1 Flow |  66.8%  |  66.9%  |
| TCP 8 Flow  | 94.8%  | 94.5% |

| 20 Servers  | ECMP  | 8-shortest paths  |
| ------------ | ------------ | ------------ |
| MTCP 1 Flow |  64.3%  |  64.4%  |
| MTCP 8 Flow  | 79.2%   | 64.8% |

