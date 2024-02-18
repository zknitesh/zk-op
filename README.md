# ZK-OP Smart Contract on Scroll

A DAPP that collects poll responses with end to end security and anonymity.

-   Zero Knowledge OP is a DAPP that collects polls from subject while maintaining subject anonymity and automatically, register a likely vote based on the poll questions.

# ZK-OP Front end Code

[ZK-OP Front end code](https://github.com/zknitesh/zk-op-fe).

## Initial setup

1.  Initialize current project with npm
    ```console
    npm init
    ```
2.  Install HardHat Project-Local
    ```console
    npm install --save-dev hardhat
    ```
3.  To use local installation of hardhat, use npx to run it
    ```shell
    npx hardhat init
    ```
4.  Add `.vscode` dir, `.prettierrc`, and `.solhint.json` file to the project

5.  Install Solhint

    ```shell
    npm install --save-dev @nomiclabs/hardhat-solhint
    ```

    -   lint

    ```shell
    npx hardhat check
    ```

    Add the following to hardhat.config.ts

    ```
    import "@nomiclabs/hardhat-solhint";
    ```

6.  Add env file

    -   Install dotenv

    ```shell
    npm install dotenv --save-dev
    ```

    -   Add the following function and call it in hardhat.config.ts file

    ```js
    function dotEnvUtil(): void {
        dotenv.config();
        const envFile: string = `.env.${process.env.ENV}`;
        console.log("env file", envFile);
        dotenv.config({ path: envFile, override: true }); // Load environment variables from env file
    }
    dotEnvUtil();
    ```

7.  Update hardhat.config.ts and install

-   Installation and add to hardhat.config.ts

    ```shell
    npm install -D hardhat-deploy
    npm install --save-dev @nomicfoundation/hardhat-ethers ethers hardhat-deploy hardhat-deploy-ethers
    ```

8. Setup Noir

-   Install Noirup
    The following commands detects the terminal type e.g. zsh or bash and updates env varaibles in zshrc or bashrc

    ```shell
    curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
    ```

-   Download nargo

    ```shell
    noirup
    nargo --version
    ```

    For this project nargo version = 0.23.0

-   Create a nargo project

    ```
    nargo new zkopckt
    ```

-   Any interaction with circuits must be done from `zkopckt` directory

-   Build noir

    ```
    nargo check
    ```

-   Before executing this, update the prover.toml file x and y values to 1 and 2. Prove
    ```
    nargo prove
    ```
-   Verify proof. If successful, silent success on cmd line. If failure, lots of error outputs.

    ```
    nargo verify

    ```

-   For logs and check if circuit witness works. Update the inputs in prover.toml file

    ```
    nargo execute
    ```

    Generate Solidity

    ```
    nargo codegen-verifier
    ```
