class window.BlackjackView extends Backbone.View

  events:
    "click .hit-button": "hit"
    "click .stand-button": "stand"
    "click .reset-button": "reset"

  initialize: ->
    @balance = 100
    newDeck = []
    for card in [0..51]
      switch Math.floor card / 13
        when 0 then suit = "Spades"
        when 1 then suit = "Hearts"
        when 2 then suit = "Diamonds"
        else suit = "Clubs"
      switch card % 13
        when 0
          name = "Ace"
          value = 1
        when 10
          name = "Jack"
          value = 10
        when 11
          name = "Queen"
          value = 10
        when 12
          name = "King"
          value = 10
        else name = value = card % 13 + 1
      newDeck[card] = new Card name: name, suit: suit, value: value
    @deck = new Deck newDeck
    @shuffledDeck = @deck.shuffle newDeck
    @reset()

  reset: ->
    $("span").remove ".card"
    @player = new Hand
    @dealer = new Hand {dealer:true}
    @player.addCard @shuffledDeck[@deck.deckIndex++]
    console.log(@deck.deckIndex)
    @dealer.addCard @shuffledDeck[@deck.deckIndex++]
    console.log(@deck.deckIndex)
    @player.addCard @shuffledDeck[@deck.deckIndex++]
    console.log(@deck.deckIndex)
    @dealer.addCard @shuffledDeck[@deck.deckIndex++]
    console.log(@deck.deckIndex)


    @render true, @dealer.getCard 0
    @render false, @player.getCard 0
    @render false, @player.getCard 1

  hit: ->
    addindex = 2
    @player.addCard @shuffledDeck[@deck.deckIndex++]
    @render false, @player.getCard addindex++
    if @player.getTotal() is 21
      alert "You win, Boom!"
      @balance += 5
      @reset()
    if @player.getTotal() > 21
      alert "You lose, Sucker!"
      @balance -= 5
      @reset()

  stand: ->
    dealerIndex = 2
    @dealer.showDealer()
    @render true, @dealer.getCard 1
    while @dealer.getTotal() < 17
      @dealer.addCard @shuffledDeck[@deck.deckIndex++]
      @render true, @dealer.getCard dealerIndex++
    if (@dealer.getTotal() > 21) or (@player.getTotal() > @dealer.getTotal())
      alert "You Win!"
      @balance += 5
    else if @dealer.getTotal() > @player.getTotal()
      alert "You LOSE!"
      @balance -= 5
    else if @dealer.getTotal() is @player.getTotal()
      alert "Push... lameoooo!"
    @reset()

  render: (isDealer, card) ->
    if isDealer
      $('.dealer-cards').append "<span class='card'>#{card.get 'name'}<br> of <br>#{card.get 'suit'}</span>"
    else $('.player-cards').append "<span class='card'>#{card.get 'name'} <br> of <br>#{card.get 'suit'}</span>"
    $('.dealer-score').text @dealer.getTotal();
    $('.player-score').text @player.getTotal();
    suit = card.get "suit"
    $(".card").css color: "red" if card.get("suit") is "Hearts" or card.get("suit") is "Diamonds"
    $(".balance").html @balance
