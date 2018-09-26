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

##### Como utilizar o código
##### 1- Crie duas instâncias virtuais no serviço Google Cloud (Você pode utilizar sua própria máquina caso tenha as mesmas características descritas) com a seguinte configuração:
- Região us-central (Iowa)
- 4 vCPUs e 15 GB de memória
- Ao menos 30 GB de disco para permitir a compilação do MPTCP
- Debian GNU/Linux 9 (Strech)
- Tráfego HTTP e HTTPS permitidos

##### 2- Instalar o git com ( sudo apt install git)
##### 3- Clonar o repositório do mininet (git clone git://github.com/mininet/mininet.git)
##### 4- Executar:
```
cd mininet
git checkout 2.2.2
util/install.sh -a
```
##### 5- Instalar bibliotecas complementares
```
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
