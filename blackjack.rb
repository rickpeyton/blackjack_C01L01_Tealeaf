# Blackjack Assignment
# Tealeaf Academy C01L01
require 'pry'

def initialize_deck
  number_of_decks = 2
  deck = {}
  decks = []
  suits = %w(Hearts Diamonds Clubs Spades)
  cards =
    { 'Ace' => 11, 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5,
      'Six' => 6, 'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10,
      'Jack' => 10, 'Queen' => 10, 'King' => 10 }
  suits.each do |suit|
    cards.each do |card, value|
      deck["#{card} of #{suit}"] = value
    end
  end
  number_of_decks.times do
    deck.each { |card, value| decks << { card => value } }
  end
  decks.shuffle
end

def deal_face_up(cards, player = 'Dealer')
  puts "#{player} is dealt #{cards.last.keys[0]}"
end

def hand_total(cards)
  total = 0
  aces_count = 0
  cards.each do |card|
    total += card.values[0]
    aces_count += 1 if card.values[0] == 11
  end
  total = check_aces(total, aces_count)
end

def check_aces(total, aces_count)
  if (aces_count > 0) && (total > 21)
    begin
      total -= 10
      aces_count -= 1
    end until (total <= 21) || (aces_count == 0)
    total
  else
    total
  end
end

puts 'What is your name?'
player = gets.chomp
# Ask for Chips to Start with
begin
  puts 'How many chips would you like to buy? (10 minimum)'
  chips = gets.chomp.to_f
end until chips >= 10
starting_chips = chips

begin
  system 'clear'
  game_deck = initialize_deck

  begin
    puts "Place your wager, #{player} (10 - #{chips.to_i})"
    wager = gets.chomp.to_i
  end until (wager >= 10) && (wager <= chips.to_i)
  chips -= wager

  player_hand = []
  player_hand << game_deck.pop
  deal_face_up(player_hand, player)

  dealer_hand = []
  dealer_hand << game_deck.pop
  puts 'Dealer is dealt a face down card'
  player_hand << game_deck.pop
  deal_face_up(player_hand, player)

  dealer_hand << game_deck.pop
  deal_face_up(dealer_hand)

  if (dealer_hand[1].values[0] == 11) && (chips > (wager / 2))
    puts 'The Dealer is showing an Ace'
    puts "Would you like to purchase insurance for #{wager / 2} chips? (y/n)"
    insurance = gets.chomp.downcase
    chips -= (wager / 2) if insurance == 'y'
  end

  begin # Player Plays Hand
    player_total = hand_total(player_hand)
    puts "Your current card total is #{player_total}"
    case
    when player_total == 21
      puts 'Blackjack!'
      hit_or_stay = 's'
    when player_total < 21
      puts 'Would you like to hit or stay? (h/s)'
      hit_or_stay = gets.chomp.downcase
      if hit_or_stay == 'h'
        player_hand << game_deck.pop
        deal_face_up(player_hand, player)
      end
    when player_total > 21
      puts 'Bust!'
      hit_or_stay = 's'
    end
  end while hit_or_stay == 'h'

  puts 'Dealer flips first card'
  puts dealer_hand[0].keys[0]
  begin # Dealer Plays Hand
    dealer_total = hand_total(dealer_hand)
    puts "Dealer current card total is #{dealer_total}"
    case
    when dealer_total == 21
      puts 'Blackjack!'
    when dealer_total < 17
      dealer_hand << game_deck.pop
      deal_face_up(dealer_hand)
    when dealer_total > 21
      puts 'Bust!'
    when (dealer_total >= 17) && (dealer_total <= 21)
      puts "Dealer stays at #{dealer_total}"
    end
  end while dealer_total < 17

  case
  when (dealer_total == 21) && (dealer_hand.length == 2) && (insurance == 'y')
    puts 'At least you had insurance.'
    puts "#{player} receives his bet back"
    chips += wager
  when (player_total == dealer_total) && (player_total <= 21)
    puts "Draw. #{player} receives his bet back."
    chips += wager
  when player_total > 21
    puts "Sorry, #{player}. You lost your bet."
  when (player_total < dealer_total) && (dealer_total > 21)
    puts 'You win!'
    chips += (wager * 2)
  when player_total < dealer_total
    puts "Sorry, #{player}. The dealer won. You lost your bet."
  when (player_total == 21) && (player_hand.length == 2)
    puts 'Blackjack bonus!'
    puts "#{player} wins #{wager * 1.5} chips!"
    chips += (wager * 1.5 + wager)
  when player_total > dealer_total
    puts 'You win!'
    chips += (wager * 2)
  end

  if chips >= 10
    puts 'Do you want to play another hand? (y/n)'
    play_again = gets.chomp.downcase
  else
    play_again = 'n'
  end
end until (play_again == 'n') || (chips < 10)

if starting_chips < chips
  puts "#{player} walks away up #{(chips - starting_chips).to_i} chips."
elsif starting_chips > chips
  puts "#{player} walks away down #{(starting_chips - chips).to_i} chips."
else
  puts "#{player} walks away with nothing gained, nothing lost."
end
