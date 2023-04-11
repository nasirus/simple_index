// script.js
const messageInput = document.getElementById('message-input');
const sendButton = document.getElementById('send-button');
const chatMessages = document.getElementById('chat-messages');

// Initialize chat history
const chatHistory = [];

sendButton.addEventListener('click', sendMessage);
messageInput.addEventListener('keypress', handleKeyPress);

function handleKeyPress(event) {
  if (event.key === 'Enter') {
    sendMessage();
    event.preventDefault(); // Prevent the default action (form submission or line break)
  }
}

async function sendMessage() {
  const messageText = messageInput.value.trim();

  if (messageText) {
    const messageElement = document.createElement('div');
    messageElement.textContent = messageText;
    messageElement.classList.add('prompt');
    chatMessages.appendChild(messageElement);
    messageInput.value = '';
    chatMessages.scrollTop = chatMessages.scrollHeight;

    try {
      const response = await fetch('/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          chat_history: chatHistory.map(({ question, answer }) => [question, answer]),
          question: messageText,
        }),
      });

      const result = await response.json();
      const answerElement = document.createElement('div');
      answerElement.innerHTML = result.result.answer.replace(/\n/g, '<br>'); // Replace newline characters with <br>
      answerElement.classList.add('answer');
      chatMessages.appendChild(answerElement);
      chatMessages.scrollTop = chatMessages.scrollHeight;

      // Update chat history with the new message and answer
      chatHistory.push({ question: messageText, answer: result.result.answer });
    } catch (error) {
      console.error('Error sending message:', error);
    }
  }
}

messageInput.focus();
