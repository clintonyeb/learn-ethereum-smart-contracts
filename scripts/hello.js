module.exports = function(callback) {
  Greeter.deployed().then(greeter => {
    return greeter.greet()
  }).then(res => {
    console.log("Response::: " + res);
    console.log("Transaction successful!")
    callback();
  });
}
