// Fix cứng dữ liệu
const messages = [
    {
        name: 'Phuong Thao',
        time: 'Hoạt động 12 phút trước',
        avatar: 'https://i.pinimg.com/736x/0a/08/46/0a08463cf274188470ca815a10da24ea.jpg'
    },
    {
        name: 'Txinh',
        time: 'Hoạt động 1 giờ trước',
        avatar: 'https://i.pinimg.com/736x/f1/5c/4a/f15c4a03b27d83f40f8d9c117234caa0.jpg'
    },
    {
        name: 'Ngoc Hoa',
        time: 'Hoạt động 1 giờ trước',
        avatar: 'https://i.pinimg.com/736x/67/34/98/67349813dc170d108389c2eac673d7f1.jpg'
    },
    {
        name: 'Hwaamin',
        time: 'Hoạt động 1 giờ trước',
        avatar: 'https://i.pinimg.com/736x/1b/4a/57/1b4a57db266a68fcd149de99f1def52f.jpg'
    },
];

// Tải dữ liệu fix cứng khi trang tải
window.onload = function() {
    const chatMessages = document.getElementById('chatMessages');
    if (chatMessages) {
        messages.forEach(message => {
            const messageItem = document.createElement('div');
            messageItem.className = 'message-item received';
            messageItem.setAttribute('onclick', `selectMessage(this, { name: '${message.name}', time: '${message.time}', avatar: '${message.avatar}' })`);
            messageItem.innerHTML = `
                <img src="${message.avatar}" alt="Avatar of ${message.name}" class="avatar">
                <div class="message-content">
                    <div class="message-header">
                        <div class="user-name">${message.name}</div>
                    </div>
                    <div class="activity-time">${message.time}</div>
                </div>
            `;
            chatMessages.appendChild(messageItem);
        });
    } else {
        console.error('Element chatMessages not found. Check HTML structure and IDs.');
    }
};

function selectMessage(element, data) {
    // Xóa class active từ tất cả message-item
    const messageItems = document.querySelectorAll('.message-item');
    if (messageItems) {
        messageItems.forEach(item => item.classList.remove('active'));
        element.classList.add('active');
    } else {
        console.error('No message items found. Ensure messages are loaded.');
    }

    // Cập nhật nội dung trong cột Người dùng
    const userHeader = document.getElementById('userHeader');
    const chatArea = document.getElementById('chatArea');
    const messageInput = document.getElementById('messageInput');
    if (userHeader && chatArea && messageInput) {
        userHeader.innerHTML = `
            <div class="user-info">
                <img src="${data.avatar}" alt="Avatar of ${data.name}" class="user-avatar-large">
                <div class="user-content">
                    <div class="user-name">${data.name}</div>
                    <div class="user-time">${data.time}</div>
                </div>
            </div>
        `;
        chatArea.innerHTML = `
            <div class="message-container">
                <div class="received-message">Xin chào mình là ${data.name}. Mình muốn mua hoa, hãy hỗ trợ mình</div>
                <div class="sent-message">Xin chào, cảm ơn bạn đã liên hệ với chúng tôi. Chúng tôi đã nhận được tin nhắn của bạn và sẽ sớm trả lời.</div>
            </div>
        `;
    } else {
        console.error('Elements userHeader, chatArea, or messageInput not found. Verify HTML IDs.');
    }

    // Cập nhật nội dung trong cột Hồ sơ người dùng
    const profileDetails = document.getElementById('profileDetails');
    if (profileDetails) {
        profileDetails.innerHTML = `
            <div class="profile-info">
                <div class="avatar-container">
                    <img src="${data.avatar}" alt="Avatar of ${data.name}" class="profile-avatar-centered">
                </div>
                <div class="profile-content">
                    <div class="profile-name">${data.name}</div>
                    <div class="profile-time">${data.time}</div>
                </div>
                <button class="profile-lock">🔒 Dữ liệu đã được mã hóa</button>
            </div>
            <div class="profile-options">
                <div class="option-item"><span class="material-symbols-outlined">person</span></div>
                <div class="option-item"><span class="material-symbols-outlined">info</span></div>
                <div class="option-item"><span class="material-symbols-outlined">image</span></div>
                <div class="option-item"><span class="material-symbols-outlined">lock</span></div>
            </div>
        `;
    } else {
        console.error('Element profileDetails not found.');
    }
}

// Hàm gửi tin nhắn
function sendMessage() {
    const messageText = document.getElementById('messageText');
    const chatArea = document.getElementById('chatArea');
    if (messageText && chatArea && messageText.value.trim() !== '') {
        const messageItem = document.createElement('div');
        messageItem.className = 'sent-message';
        messageItem.textContent = messageText.value;
        chatArea.querySelector('.message-container').appendChild(messageItem);
        messageText.value = ''; // Xóa input sau khi gửi
    } else {
        console.error('Message input or chat area not found, or input is empty.');
    }
}