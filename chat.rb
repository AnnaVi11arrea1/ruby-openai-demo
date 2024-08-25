require "openai"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant that continues to ask questions to resolve the issue."
  },
  {
    "role" => "user",
    "content" => "The user asks about what upcoming concerts are happening in their area"
  }
]

pp "Hello! How can I help you today?" 

print "-" * 50
puts 

userquestion = gets.chomp
pp "I can certainly help your request of: #{userquestion}"

while userquestion != "bye"
# Call the API to get the next message from GPT
  api_response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: message_list
    }
  )
  
  information = api_response
  choices = information.fetch("choices")
  message = choices.at(0)
  reply = message.fetch("message").fetch("content")

  pp reply




  print "-" * 50
  puts 

  # Get user input
  userquestion = gets.chomp
  pp "I can certainly help you #{userquestion}" unless userquestion == "bye"

  #update with new input
  message_list << 
    {
      "role" => "user",
      "content" => "#{userquestion}"
    } unless userquestion == "bye" 
end

pp "Have a great day!"
