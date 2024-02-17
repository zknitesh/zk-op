# ZK-OP Smart Contract on Scroll

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
