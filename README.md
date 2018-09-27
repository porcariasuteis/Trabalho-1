# TP1 INFO7015 - Tópicos em Redes de Computadores

 Relatório da tentativa de reprodução do artigo "Jellyfish: Networking Data Centers Randomly".



# Desenvolvimento

##### Que problema a Jellyfish estava tentando resolver? Qual era o estado da arte no momento em que o artigo foi publicado?
Segundo os autores, o principal problema encontrado nas topologias direcionadas a data centers na época do artigo, era a expansão incremental. As topologias para redes de alta capacidade em 2012 não contornavam a expansão incremental de forma simplificada, sendo necessária uma grande troca de elementos da rede e de cabeamento. As propostas mais comuns eram o fat-tree (folded-Clos), estruturas que utilizavam servidores para encaminhamento e redes ópticas. Existiam outras propostas que tratavam o problema de ampliação, porém algumas falhas foram apontadas pelos autores em todas elas. O MDCube permitia o crescimento de forma gradual mas muito rudimentar, o Dcell e o Bcube permitia o crescimento somente para um numero de servidores previamente conhecido. Existiam ainda propostas similares ao Jellyfish para randomizar as novas conexões, porém elas seriam inferiores ao Jellyfish por necessitarem alguma correlação entre os dispositivos de fim.

##### Um breve resumo dos métodos e resultados do artigo original (com foco especial na Figura 9 e na Tabela 1).
Além do problema da expansão incremental a jellyfish tinha como objetivo melhorar o throughput em topologias baseadas em árvore. Os autores explicam que conseguiram estas duas características principais, através de um sistema randômico de conexões para novos ativos ou servidores. A flexibilidade de conexão para novos componentes permitiria agregar ativos independente da quantia de portas, trazendo grande vantagem sobre as tecnologias baseadas em árvore. Para adicionar um novo ativo na rede, aleatoriamente é escolhido um link na rede atual, este link é removido liberando automaticamente duas portas. As duas portas liberadas são conectadas ao novo ativo. Este processo se repete enquanto houverem portas disponíveis no novo ativo (duas ao menos).
<p align="center">  <img src="https://image.ibb.co/bHjMrp/jelly.png" alt="jelly" border="0"></p>
Segundo os autores, o redimensionamento também seria vantajoso financeiramente e não traria grandes dificuldades para alterar o layout do cabeamento. O aumento do throughput seria outro benefício, no artigo os autores especificam 25% a mais de servidores utilizando toda a largura de banda quando comparado com o Fat-Tree com os mesmos equipamentos, uma das razões é que a topologia do Jellyfish permitiria um melhor uso dos algoritmos de roteamento com multi caminhos. Para ilustrar melhor podemos observar a Figura 1 do trabalho aonde notamos que o Jellyfish precisa de menos saltos (caminhos mais curtos) para alcançar toda a amplitude da rede, porém é valido salientar que a possibilidade de existirem múltiplos caminhos será maior de acordo com o tamanho (quantia de ativos, servidores, etc) da rede.

<p align="center"><img src="https://image.ibb.co/j3AkMp/figura1.jpg" alt="dados_originais" border="0"></p> 

Na Figura 9 notamos exatamente como a utilização do algoritmo k-shortest se beneficia da topologia do jellyfish, podendo utilizar mais caminhos distintos em uma mesma quantia de links quando comparado ao ECMP (Equal Cost Multipath Routing). Na Tabela 1 podemos observar vários testes na topologia Fat-Tree e Jellyfish, utilizando controles de congestionamento distintos (TCP 1 e 8 fluxos e MPTCP) e dois algoritmos de roteamento (ECMP e K-Shortest-Path). Na topologia Fat-Tree as diferenças mais notáveis estão na utilização de múltiplos fluxos, os números do TCP e do MPTCP foram similares (92,2% de utilização no TCP e 93,6% no MPTCP). Os valores do jellyfish utilizando o algoritmo k-shortest foram muito parecidos com a topologia Fat-Tree, o mais perceptível é o quanto a topologia jellyfish se beneficia do k-shortest-path quando comparado ao ECMP.

<p align="center">  <img src="https://image.ibb.co/cAeZE9/dados_originais.png" alt="dados_originais" border="0"></p>

##### Detalhe sobre sua abordagem para reproduzir a figura. Se você escolheu uma plataforma ou ferramenta específica, explique por que você fez essa escolha. Destaque as vantagens da sua abordagem, bem como quaisquer inconvenientes. Houve algum desafio que você acertou ou suposições que você precisava fazer?
Para reprodução da figura o simulador utilizado foi o Mininet na versão 2.2.2. disponível em http://mininet.org/download/ e  Python 3.5.2 instalado dos repositórios do Debian Linux. A escolha do Mininet foi baseada na ampla quantidade de exemplos e modelos disponíveis. Os experimentos foram executados em servidores criados na Google Cloud devido ao maior poder de processamento a possibilidade de execução de experimentos longos sem a necessidade de paralisação. Foram utilizadas duas instâncias de máquinas virtuais conforme segue:

Máquina n1-standard-4 (4 vCPUs, 15 GB de memória) e 30 GB de disco rodando Debian GNU/Linux 9 Kernel 4.9.0-8

Máquina n1-standard-4 (4 vCPUs, 15 GB de memória) e 30 GB de disco rodando Debian GNU/Linux 9 Kernel 4.9.0-8 com MPTCP compilado no Kernel, seguindo as instruções encontradas em: https://multipath-tcp.org/pmwiki.php/Users/DoItYourself
A escolha da utilização de duas máquinas, uma com TCP e outra com MPTCP foi devido ao fato de os resultados apresentarem inconsitêcias ao desabilitar o MPTCP no kernel de uma única máquina.

As principais dificuldades foram inicialmente relacionadas à falta de prática com o simulador e a linguagem Python. A compilação do Kernel foi trabalhosa, uma vez que o tutorial do projeto não é exatamente passo a passo, assumindo que o usuário tenha experiência prévia.
Os autores no artigo não utilizam simuladores convencionais e o simulador citado pelos autores (cedido pela equipe do MPTCP) não está acessível publicamente.
Existiam trabalhos anteriores tentando reproduzir o experimento citado no artigo, e um destes trabalhos foi utilizado como base na construção tanto da figura quanto da tabela. O trabalho que serviu de referência foi de autoria de Jean-Luc Watson, https://github.com/jlwatson , mas no trabalho original os valores não eram exibidos integralmente por conta de uma falha de comunicação entre o Iperf https://iperf.fr/ e o Mininet, esta mesma falha é reportada em outros testes similares, inclusive por outros alunos que tentaram reproduzir o artigo. Ao entrar em contato com o autor, obtive a seguinte resposta

**...“If I recall correctly, it came down to issues with the simulation, even though the overall setup for the experiment is correct. We were having a great deal of trouble getting Mininet to limit the bandwidth on each link when running the iperf tests, which might be due to the specific version we're using (2.2.2).”**

Com base na resposta verificou-se a saída dos testes, e muitos dos testes realizados via Iperf não recebiam resposta correta. Em algumas situações os testes eram computados como tráfego de 0KB/s, em outras situações o limite de largura de banda estipulado no código era ultrapassado (transmissão de 500 Mb/s em um canal de 100 Mb/s) , gerando valores médios alterados para mais ou menos.
Após pesquisar sobre a suposta incompatibilidade do Iperf/Iperf3 com o mininet, outros relatos semelhenates foram encontados, como na lista de discussão de [Stanford](https://mailman.stanford.edu/mailman/swish?query=iperf+mininet&submit=Search+mininet-discuss%21&metaname=swishdefault&sort=unixdate&listname=mininet-discuss&dr_o=12&dr_s_mon=4&dr_s_day=13&dr_s_year=2014&dr_e_mon=4&dr_e_day=13&dr_e_year=2014 "Stanford"). 
As sugestões para amenizar o problema de falta de comunicação ou throughput excedendo os limites do canal eram ignorar os fluxos sem comunicação ou com comunicação excedente.
Para o teste da Fat-Tree foi utilizado como base um trabalho de Pranav Yerabati Venkata, levemente modificado para atender a nossa proposta. O repositório original pode ser encontrado em https://github.com/pranav93y
Os problemas encontrados com a topologia Fat-Tree e o simulador Mininet estão relacionados à utilização dos multicaminhos, o simulador monta corretamente a topologia, mas muitas vezes o teste de largura de banda com o Iperf não funciona corretamente. Problemas similares foram encontrados em listas de discussão e muitos apontavam um funcionamento incorreto do STP (Panning Tree Protocol) implementado no mininet como causa do problema, porém não podemos afirmar categoricamente ser este o problema. Os testes realizados com a topologia Fat-Tree eram mais rápidos, porém mais inconsistentes que na Jellyfish, mas o resultados quando o teste corria perfeitamente eram similares ao artigo.

Durante o desenvolvimento do trabalho, várias fontes foram consultadas, incluindo o vídeo [Fishbowl Seminar: Jellyfish: Networking Data Centers Randomly](https://youtu.be/yEjcZC34qNo "Fishbowl Seminar: Jellyfish: Networking Data Centers Randomly") de um dos autores P. Brighten Godfrey, aonde algumas considerações são expostas de forma distinta ao trabalho original. Godfrey afirma que a topologia o protocolo ECMP não deve ser considerado quando utilizamos a topologia Jellyfish, e que o TCP e o MPTCP funcionam de forma muito próxima para a Jellyfish, sendo o mais importante o algoritmo de roteamento. Muito embora seja possível observar tendências confirmem estas considerações, elas não estão explícitas no artigo. Outro ponto não explicado integralmente se refere a utilização de quantidades de servidores diferentes na comparação da Jellyfish e da Fat-tree.

##### Qual o resultado que você conseguiu? Correspondeu ao papel original?
Os resultados obtidos foram fiéis ao original em vários pontos, porém foram discrepantes em outros. O gráfico na Figura 9 é muito próximo do original, uma vez que utiliza métodos matemáticos para calcular a diversidade de caminhos de acordo com a quantidade de links. Para construção da Figura 9, podemos utilizar a mesma topologia do trabalho original, com 686 servidores conforme os testes realizados no artigo. 

<p align="center">  <img src="https://image.ibb.co/jxzO7U/figure9repro.png" alt="dados_originais" border="0"></p>

Na tabela os resultados foram mais divergentes pela limitação do ambiente de testes. No teste realizado foram utilizados 20 servidores e 32 switches com 6 portas cada, outras configurações foram testadas, porém a que melhor conseguiu realizar os testes até o fim foi esta. Em algumas ocasiões a simulação terminava sem resultados, mas não foi possível determinar se o problema era no código ou na máquina virtualizada, sendo necessário reiniciar a instância virtualizada e retomar os testes. A limitação da topologia testada torna difícil uma comparação mais aproximada com o trabalho original, porém as tendências são similares, sendo a mais notável a melhora de desempenho quando utilizamos o jellyfish com mais fluxos e com o MPTCP. Os testes com um fluxo funcionam razoavelmente bem, porém quando utilizamos o MPTCP e oito fluxos os resultados são insatisfatórios, provavelmente porque a quantia de servidores, switches e portas não cria uma diversidade muito grande de caminhos.



Os resultados abaixo representam a saída do programa sendo executado uma vez para o TCP e uma para o MPTCP.

**TCP**
<p align="left">  <img src="https://image.ibb.co/cCMBbp/print_tcp.png" alt="dados_originais" border="0"></p>

**MPTCP**
<p align="left">  <img src="https://image.ibb.co/hSgKwp/print_mptcp.png" alt="dados_originais" border="0"></p>


**Médias de 3 execuções válidas**

| 20 Servers  | ECMP  | 8-shortest paths  |
| ------------ | ------------ | ------------ |
| TCP 1 Flow |  66.8%  |  66.9%  |
| TCP 8 Flow  | 94.8%  | 94.5% |

| 20 Servers  | ECMP  | 8-shortest paths  |
| ------------ | ------------ | ------------ |
| MTCP 1 Flow |  64.3%  |  64.4%  |
| MTCP 8 Flow  | 69.2%   | 67.8% |

# Como utilizar o código

##### 1- Crie duas instâncias virtuais no serviço Google Cloud (Você pode utilizar sua própria máquina caso tenha as mesmas características descritas) com a seguinte configuração:
- Região us-central (Iowa)
- 4 vCPUs e 15 GB de memória
- Ao menos 30 GB de disco para permitir a compilação do MPTCP
- Debian GNU/Linux 9 (Strech)
- Tráfego HTTP e HTTPS permitidos

##### 2- Instalar o git:
```
sudo apt install git
```
##### 3- Clonar o repositório do mininet:
```
git clone git://github.com/mininet/mininet.git
```
##### 4- Executar:
```
cd mininet
git checkout 2.2.2
util/install.sh -a
```
##### 5- Instalar bibliotecas e programas complementares
```
sudo apt install iperf3
sudo apt install python-pip
sudo pip install networkx
sudo pip install matplotlib
```
##### 6- Em uma das instâncias virtuais compilar o MPTCP:
```
git clone git://github.com/multipath-tcp/mptcp.git
sudo mv -R mptcp/  /usr/src/
cd /usr/src
sudo apt-install build-essential libncurses5-dev bc libssl-dev make libelf-dev
make mrproper
make menuconfig (selecionar pacotes do MPTCP)
make_kpkg
make modules
make modules_install
make install
```
<p align="left">  <img src="https://image.ibb.co/gX7Jrp/mptcp_compilado.png" alt="dados_originais" border="0"></p>

**7- Conectar a instância com TCP (Via painel de controle do google cloud ou cliente SSH de sua preferência)**

Clonar o git do projeto:
```
git clone https://github.com/fernandonakayama/TP1.git
cd TP1/
sudo python tcp.py
```
A figura9 estará disponível na raiz do diretório, com o nome ***figure9.eps***

Os resultados de TCP com 1 e 8 fluxos com ECMP e K-shortest-Paths para topologia Jellyfish serão exibidos ao término da execução.

Os resultados da topologia Fat-Tree são obtidos executando o script fattree.sh
```
sudo sh ./fattree.sh
```
O resultado será exibido após a execução do script.
<p align="left">  <img src="https://image.ibb.co/ioX1cU/fat_1.png" alt="dados_originais" border="0"></p>

**8- Conectar a instância com MPTCP (Via painel de controle do google cloud ou cliente SSH de sua preferência)**

Clonar o git do projeto:
```
git clone https://github.com/fernandonakayama/TP1.git
cd TP1/
sudo python mptcp.py
```
Os resultados de MPTCP com 1 e 8 fluxos com ECMP e K-shortest-Paths para topologia Jellyfish serão exibidos ao término da execução.

Os resultados da topologia Fat-Tree são obtidos executando o script fattree.sh
```
sudo sh ./fattree.sh
```
O resultado será exibido após a execução do script.
