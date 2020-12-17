# FreePDK45
This is the FreePDK45 V1.4 Process Development Kit for the 45 nm technology

## A Tutorial for MIPS with FreePDK45

- Clone this repo.
```bash
git clone https://github.com/baichen318/FreePDK45.git && cd FreePDK45
```

- Set the environment variables

```bash
cd FreePDK45
export PDK_DIR=$PWD
cd ../mips
```

- Push MIPS to the synthesis stage with DC

```bash
make
```

- Check the result

Please view results in reports/

- Clean the workstation (optional)

```bash
make clean
```
