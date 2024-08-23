require "openai"

pp "Hello! How can I help you today?" 

print "-" * 50
puts 

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

pp client

userquestion = gets.chomp
pp "I can certainly help your request of: #{userquestion}"

message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant that continues to ask questions to resolve the issue."
  },
  {
    "role" => "user",
    "content" => "#{userquestion}"
  }
]

def chat_with_retry(client, message_list)
  retries = 0
  begin
    # Call the API to get the next message from GPT
    api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list
      }
    )
    return api_response
  rescue Faraday::TooManyRequestsError => e
    retries += 1
    if retries <= 5
      delay = retries * 2
      pp "Rate limit exceeded. Retrying in #{delay} seconds..."
      sleep(delay)
      retry
    else
      pp "Too many retries. Please try again later."
      return nil
    end
  end
end

while userquestion != "bye"
# Call the API to get the next message from GPT
  api_response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: message_list
    }
  )

  pp api_response

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
