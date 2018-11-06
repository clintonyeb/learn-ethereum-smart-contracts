function watch() {
  coin.Sent().watch({}, '', function (error, result) {
    console.log('here')
    if (!error) {
      console.log("Coin transfer: " + result.args.amount +
        " coins were sent from " + result.args.from +
        " to " + result.args.to + ".");
      console.log("Balances now:\n" +
        "Sender: " + coin.balances.call(result.args.from) +
        "Receiver: " + coin.balances.call(result.args.to));
    }
  });
}