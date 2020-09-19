var kushki
var kushkiResponse

function alertMessage(txt){
    alert(txt)
}

function initKushki(merchantId, inTestEnvironment){
    kushki = new Kushki({
        merchantId: merchantId,
        inTestEnvironment: inTestEnvironment
    })
}

var callback = function(response) {
  if(!response.code){
    console.log(response)
    kushkiResponse = response
  } else {
    console.error('Error: ',response.error, 'Code: ', response.code, 'Message: ',response.message);
  }
}

function requestSubscriptionToken(currency, name, number, cvc, expiryMonth, expiryMonth){
    kushki.requestToken({
      amount: '0',
      currency: currency,
      card: {
            name: name,
            number: number,
            cvc: cvc,
            expiryMonth: expiryMonth,
            expiryYear: expiryMonth
        },
    }, callback);
}
