# Blackjack Assignment
# Tealeaf Academy C01L01
require 'pry'

Build 2 decks of cards

Ask for player's name

Start game loop
  shuffle 2 decks of cards into a game deck

  # Bet
  Ask player to place bet

  # Deal
  Deal the player's first card face down
  Then deal dealer card face down
  Deal second card facing up to player
  deal second card facing up to dealer

  # Insurance
  if dealer face card is an ace
    Offer insurance to player
    (insurance is half the original bet)
  end

  # Player plays hand

  Begin Player Loop
    Ask player to stand or hit
    if hit
      deal a new face up card
    end

    if the player busts
      collect their bet
    end
  End Player Loop

  # Dealer Plays Hand
  Flip dealer's first card

  if dealer has blackjack
    and player does not have insurance
    and player does not have blackjack
      dealer takes bet
  else player also has blackjack
    they get their bet back
  else
    player keeps bet
  end
  
  Dealer plays their hand last
  dealer should count ace as 11 until bust then count as 1
  if the dealer busts then any non-bust player wins

  once dealer stands
  if player > dealer
    pay player
    if they have blackjack on their first
      hand pay a 3:2 bonus
    end
  else if dealer > player
    collect bet
  else if tie
    give back bet
  end
End Game Loop
