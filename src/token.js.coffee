Conekta.token = {}

Conekta.token.create = (token_form, success_callback, failure_callback)->
  if typeof success_callback != 'function'
    success_callback = Conekta._helpers.log

  if typeof failure_callback != 'function'
    failure_callback = Conekta._helpers.log

  token = Conekta._helpers.parseForm(token_form)
  if token.card
    token.card.device_fingerprint = Conekta._helpers.getSessionId()
  else
    failure_callback(
      'object':'error'
      'type':'invalid_request_error'
      'message':"The form or hash has no attributes 'card'.  If you are using a form, please ensure that you have have an input or text area with the data-conekta attribute 'card[number]'.  For an example form see: https://github.com/conekta/conekta.js/blob/master/examples/credit_card.html"
    )

  if token.card and token.card.address and !(token.card.address.street1 or token.card.address.street2 or token.card.address.street3 or token.card.address.city or token.card.address.state or token.card.address.country or token.card.address.zip)
    delete(token.card.address)

  if typeof token == 'object'
    #charge.capture = false
    Conekta._helpers.xDomainPost(
      jsonp_url:'tokens/create'#'https://api.conekta.io'
      url:'tokens'#'https://api.conekta.io'
      data:token
      success:success_callback
      error:failure_callback
    )
  else
    failure_callback(
      'object':'error'
      'type':'invalid_request_error'
      'message':"Supplied parameter 'token' is not a javascript object or a form"
    )
