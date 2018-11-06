function formatBalance(value) {
  var curr = "ether";
  return web3.fromWei(value, curr) + " " + curr;
}

function balance(model, acc) {
  var bal = model.balances(acc);
  console.log(bal)
  var curr = "ether";
  return web3.fromWei(bal, curr) + " " + curr;
}