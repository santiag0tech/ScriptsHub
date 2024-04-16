import random
import string

def generate_password(length, num_numbers, num_special_characters):
  letters = string.ascii_letters
  numbers = string.digits
  special_characters = string.punctuation

  # Ensure minimum requirements are met
  if num_numbers + num_special_characters > length:
    raise ValueError("Length must be greater than or equal to the sum of minimum numbers and special characters.")

  # Generate initial password with random letters
  password = ''.join(random.choice(letters) for _ in range(length - num_numbers - num_special_characters))

  # Add random numbers
  password += ''.join(random.choice(numbers) for _ in range(num_numbers))

  # Add random special characters
  password += ''.join(random.choice(special_characters) for _ in range(num_special_characters))

  # Shuffle the password to make characters in random order
  password = ''.join(random.sample(password, len(password)))

  return password


if __name__ == "__main__":
  print("Security recommendations for passwords:")
  print("- Recommended minimum length: at least 8 characters.")
  print("- It is recommended to include numbers and special characters.")
  print("- It is recommended to change the password periodically.")
  print()

  length = int(input("Enter the length of the password: "))
  num_numbers = int(input("Enter the minimum number of numbers in the password: "))
  num_special_characters = int(input("Enter the minimum number of special characters in the password: "))

  new_password = generate_password(length, num_numbers, num_special_characters)
  print("-----------------------------------------------")
  print("The newly generated password is: ", new_password)
