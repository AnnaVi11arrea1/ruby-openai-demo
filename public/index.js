document.addEventListener('DOMContentLoaded', () => {
    function sendMessage() {
        const userInput = document.getElementById('user-input');
        const messageText = userInput.value;

        if (messageText.trim() === '') return;

        // Add user's message to the chat box
        addMessageToChat('user', messageText);

        // Send the message to the Sinatra server
        fetch(`/chat?message=${encodeURIComponent(messageText)}`, {
            method: 'GET',
            
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Add the API's response to the chat box
            addMessageToChat('system', data.content);
        })
        .catch(error => {
            console.error('Error:', error);
            addMessageToChat('system', 'An error occurred while processing your message.');
        });

        // Clear the input field
        userInput.value = '';
        }

    function addMessageToChat(user, message) {
        const chatBox = document.getElementById('chat-box');
        const messageElement = document.createElement('div');
        messageElement.className = user;
        messageElement.textContent = message;
        chatBox.appendChild(messageElement);

        // Scroll to the bottom of the chat box
        chatBox.scrollTop = chatBox.scrollHeight;
    }
    // Attach the sendMessage function to the button click event
    const sendMsg = document.getElementById("send");
    sendMsg.addEventListener("click", sendMessage);
});
