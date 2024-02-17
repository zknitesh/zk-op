import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-solhint";
import dotenv from "dotenv";

function dotEnvUtil(): void {
    dotenv.config();
    const envFile: string = `.env.${process.env.ENV}`;
    console.log("env file", envFile);
    dotenv.config({ path: envFile, override: true }); // Load environment variables from env file
}
dotEnvUtil();

const config: HardhatUserConfig = {
    solidity: "0.8.24",
};

export default config;
