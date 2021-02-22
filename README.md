# FreePDK45
This is the FreePDK45 V1.4 Process Development Kit for the 45 nm technology

## A VLSI flow for BOOM with FreePDK45

- Clone this repo.
```bash
$ git clone https://github.com/baichen318/FreePDK45.git && cd FreePDK45
```

- Set the environment variables

```bash
$ cd FreePDK45
$ export PDK_DIR=$PWD
$ cd ../boom
```

- Push BOOM to the synthesis stage with DC

```bash
$ make
```

- Check the results

Please view results in reports/

- Clean the workstation (optional)

```bash
$ make clean
```

## TODO
- Add SRAM maros
