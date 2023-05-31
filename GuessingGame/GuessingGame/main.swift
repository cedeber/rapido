import Foundation

print("Guess the number!")

let secretNumber = Int.random(in: 1 ..< 100)
var guess: Int

while true {
	print("Please input your guess.")

	let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

	if let input = Int(input) {
		guess = input
	} else {
		continue
	}

	print("You guessed \(guess)")

	if guess < secretNumber {
		print("Too small!")
	} else if guess > secretNumber {
		print("Too big!")
	} else {
		print("You win!")
		break
	}
}
