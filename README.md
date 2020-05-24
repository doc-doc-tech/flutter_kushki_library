# flutter_kushki_library

This plugin has been created with the purpose
 of implementing the [native kushki libraries](https://docs.kushkipagos.com/kushki-libraries).

## Getting Started

### Methods
#### Initializer, this should be called before any other process
    {initKushki(String publicMerchantId, KushkiCurrency currency = KushkiCurrency.USD, KushkiEnv env = KushkiEnv.TESTING)}
##### returns KushkiResponse {code SUCCESS | ERROR, message String}

#### Tokenize a subscription token card
    {requestSubscriptionToken(KushkiCard card)}
##### returns KushkiResponse {code SUCCESS | ERROR, token String, message String} 
