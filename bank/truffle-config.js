//const HDWalletProvider = require("@truffle/hdwallet-provider");
//const mnemonic = "exact husband cup journey give beauty best fox rapid ripple aisle stairs company coach notice";

// truffle test --network <network-name>

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "5778"       // Any network (default: none)
    }
    /*
    rinkeby: {
      provider: function() { 
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/21fea1b2e4514a24b4fb2b3fd089b9ee");
      },
      host: "localhost",
      from: "0xe1c6CbB32AD0065Ea52eb66699a5932ECB424a69",
      network_id: 4,
      gas: 4000000
    }
    */
  }
};