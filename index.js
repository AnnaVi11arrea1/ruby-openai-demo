function sendMessage() {
  const userInput = document.getElementById('user-input');
  const messageText = userInput.value;

  if (messageText.trim() === '') return;

  // Add user's message to the chat box
  addMessageToChat('user', messageText);

  // Send the message to the Sinatra server
  fetch('/chat', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
      },
      body: JSON.stringify({ message: messageText }),
  })
  .then(response => response.json())
  .then(data => {
      // Add the API's response to the chat box
      addMessageToChat('assistant', data.content);
  })
  .catch(error => console.error('Error:', error));

  // Clear the input field
  userInput.value = '';
}

function addMessageToChat(sender, message) {
  const chatBox = document.getElementById('chat-box');
  const messageDiv = document.createElement('div');
  messageDiv.classList.add('chat-message');

  if (sender === 'user') {
      messageDiv.classList.add('user-message');
  } else if (sender === 'assistant') {
      messageDiv.classList.add('assistant-message');
  }

  messageDiv.textContent = message;
  chatBox.appendChild(messageDiv);

  // Scroll to the bottom of the chat box
  chatBox.scrollTop = chatBox.scrollHeight;
}
