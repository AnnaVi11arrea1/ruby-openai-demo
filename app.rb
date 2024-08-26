require "openai"
require "json"
require "sinatra"



get("/chat")do
 
  client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

  message_list = [
    {
      "role" => "system",
      "content" => "You are a helpful assistant that finds food and craft vendors their next event to sell at, and you talk like Samuel L Jackson. You also provide clickable links the the event websites and related clickable links to the applications as a list. You ask if they have a location or event style preference. You offer a list of 5 events initially. You provide a clickable see more button and provide a new list of more possible choices that are also clickable to the user."
    },
    {
      "role" => "user",
      "content" => "The user asks about events, festivals, art fairs, conventions and farmers markets in a certain area that are currently accepting vendor applications"
    }
  ]

  userquestion = params[:message]
  pp "Hello! How can I help you today? Enter 'bye' to end."

  print "-" * 50
  puts 


  pp "I can certainly help your request of: #{userquestion}"

  message_list << { "role" => "user", "content" => userquestion }

  while userquestion != "bye"
  # Call the API to get the next message from GPT
    @api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list
      }
    )
    
    response = api_response["choices"].first["message"]["content"]
    { response: response }.to_json  

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
  erb(:chat, {:layout => :layout })
  
end
