# PowerShell script to add two numbers

# Prompt user for first number
$num1 = Read-Host "Enter the first number"

# Prompt user for second number
$num2 = Read-Host "Enter the second number"

# Convert to integers and calculate sum
$sum = [int]$num1 + [int]$num2

# Display the result
Write-Host "The sum of $num1 and $num2 is: $sum"