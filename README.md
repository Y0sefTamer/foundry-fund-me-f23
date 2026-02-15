# Foundry Fund Me FundMe 💰

A decentralized crowdfunding smart contract built with Foundry. This project allows users to fund the contract with ETH, and the owner to withdraw the funds. It uses Chainlink Price Feeds to convert ETH to USD.

## 🛠 Technology Stack

- **Solidity** (Smart Contract Language)
- **Foundry** (Development Framework: Forge, Cast, Anvil, Chisel)
- **Chainlink** (Oracles for Price Feeds)

## 📋 Prerequisites

Before running the project, ensure you have the following installed:

1. **Git**: [Download Git](https://git-scm.com/)
2. **Foundry**:
   ```bash
   curl -L [https://foundry.paradigm.xyz](https://foundry.paradigm.xyz) | bash
   foundryup
🚀 Quick Start
Clone the repository:

Bash
git clone [https://github.com/Y0sefTamer/foundry-fund-me-f23](https://github.com/Y0sefTamer/foundry-fund-me-f23)
cd foundry-fund-me-f23
Install dependencies:

Bash
forge install
Build the project:

Bash
forge build
🧪 Testing
We have a comprehensive test suite. You can run tests using the following commands:

Run all tests:

Bash
forge test
Run a specific test:

Bash
forge test --match-test testFunctionName
See test coverage:

Bash
forge coverage
Gas Report:

Bash
forge test --gas-report
📦 Deployment
1. Local Network (Anvil)
This is the fastest way to test your deployment script.

Start a local node in a separate terminal:

Bash
anvil
Deploy the contract:

Bash
forge script script/DeployFundMe.s.sol --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545) --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(Note: The private key above is a default Anvil key. Never use it on a real network!)

2. Testnet (Sepolia)
To deploy to a live testnet, you need to set up your environment variables.

Create a .env file in the root directory:

Bash
touch .env
Add your keys to .env (DO NOT commit this file to GitHub!):


SEPOLIA_RPC_URL=your_alchemy_or_infura_url
PRIVATE_KEY=your_metamask_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
Load the variables and deploy:

Bash
source .env
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
🛠 ZKsync Deployment (Advanced)
If you want to deploy to ZKsync local node:

Bash
# Ensure docker is running
npx zksync-cli dev start

# Deploy
forge create src/FundMe.sol:FundMe --rpc-url [http://127.0.0.1:8011](http://127.0.0.1:8011) --private-key <PRIVATE_KEY> --legacy --zksync
🤝 Contribution
Contributions are welcome! Please feel free to submit a Pull Request.

📄 License
This project is licensed under the MIT License.