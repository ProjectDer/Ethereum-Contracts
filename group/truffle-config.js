
// const HDWalletProvider = require('truffle-hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();

// truffle test --network <network-name>

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "5777"       // Any network (default: none)
    },
    rinkeby: {
      host: "127.0.0.1",
      port: 8545,
      from: "0xe1c6CbB32AD0065Ea52eb66699a5932ECB424a69",
      network_id: 4,
      timeoutBlocks: 50,
      confirmations: 0,
      gas: 4612388
    }

  // Set default mocha options here, use special reporters etc.
  /*
  mocha: {
     timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      // version: "0.5.1",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
    */
  }
};
