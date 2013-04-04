class window.Card extends Backbone.Model
  initialize: ->
      name: ""
      suit: ""
      value: ""

class window.Deck extends Backbone.Collection
    model: Card
    shuffle: (newDeck) ->
      @deckIndex = 0
      _.shuffle newDeck

class Hand
  constructor: (dealer) ->
    @aceCount = 0    
    @cards = []
    @total = 0
    @dealer = dealer

  addCard: (card) ->
    val = card.get("value")
    @cards.push card
    if val is 1
      @aceCount++
    @total += val

  showDealer: ->
    @dealer = false

  getCard: (index) ->
    @cards[index]

  getTotal: ->
    if @dealer
      @cards[0].get "value"
    else if (@aceCount > 0) and (@total < 22)
      @aceCount--
      @total += 10
    else
      @total
