# ScanProcessingFPGA


## How to use GHDL

### Installation :
```bash
sudo apt-get install ghdl
```

### Analyse :

```bash
ghdl -a all-your-files
```

### Elaborate :


```bash
ghdl -e top-entity
```

### Run :

```bash
ghdl -r top-entity --wave=PathToResults\Name_wave.ghw

```

Then you can use gtkwave to visualize your tests

### Automatically run test bench

```
./run_testbench.sh run <test-bench-entity>
```
