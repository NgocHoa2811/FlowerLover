<%-- 
    Document   : chatbot
    Created on : Jun 22, 2025, 12:16 AM
    Author     : Grok
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    /* CSS cho chatbot */
    .chatbot-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 350px;
        height: 450px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        display: none;
        flex-direction: column;
        z-index: 1000;
    }

    .chatbot-header {
        background-color: #22392C;
        color: #FEF4EB;
        padding: 10px;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .chatbot-header h3 {
        margin: 0;
        font-size: 18px;
    }

    .chatbot-header .close-btn {
        cursor: pointer;
        font-size: 20px;
    }

    .chatbot-body {
        flex-grow: 1;
        padding: 10px;
        overflow-y: auto;
        background-color: #f9f9f9;
    }

    .chat-message {
        margin: 10px 0;
        padding: 8px 12px;
        border-radius: 8px;
        max-width: 80%;
    }

    .user-message {
        background-color: #22392C;
        color: white;
        margin-left: auto;
        text-align: right;
    }

    .bot-message {
        background-color: #e0e0e0;
        color: black;
        margin-right: auto;
    }
    
    .chat-con {
        height: 400px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .chatbot-input {
        display: flex;
        padding: 10px;
        border-top: 1px solid #ddd;
    }

    .chatbot-input input {
        flex-grow: 1;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
        outline: none;
    }

    .chatbot-input button {
        padding: 8px 12px;
        margin-left: 10px;
        background-color: #22392C;
        color: #FEF4EB;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .chatbot-toggle {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: #22392C;
        color: white;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 1000;
    }
</style>

<!-- Chatbot Container -->
<div class="chatbot-toggle" id="chatbotToggle">
    <i class="fas fa-comment"></i>
</div>
<div class="chatbot-container" id="chatbotContainer">
    <div class="chatbot-header">
        <h3>Chat với FlowerLover</h3>
        <span class="close-btn" id="closeChatbot">×</span>
    </div>
    <div class="chat-con">
        <div class="chatbot-body" id="chatbotBody">
            <!-- Hiển thị tin nhắn chào mừng ngay khi mở -->
            <c:if test="${empty sessionScope.chatHistory}">
                <div class="chat-message bot-message">Xin chào! Chúng mình có thể giúp gì cho bạn?</div>
            </c:if>
            <!-- Hiển thị lịch sử trò chuyện -->
            <c:forEach var="message" items="${sessionScope.chatHistory}">
                <c:choose>
                    <c:when test="${message.startsWith('user:')}">
                        <div class="chat-message user-message">${fn:substringAfter(message, 'user:')}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="chat-message bot-message">${fn:substringAfter(message, 'bot:')}</div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
        <div class="chatbot-input">
            <input type="text" id="userMessage" placeholder="Nhập tin nhắn..." required>
            <button onclick="sendMessage()">Gửi</button>
        </div>        
    </div>

</div>

<script>
    $(document).ready(function(){
        // Toggle chatbot
        $('#chatbotToggle').click(function() {
            $('#chatbotContainer').toggle();
            $(this).hide();
            // Cuộn xuống cuối cửa sổ chat khi mở
            var chatbotBody = $('#chatbotBody');
            chatbotBody.scrollTop(chatbotBody[0].scrollHeight);
        });

        $('#closeChatbot').click(function() {
            $('#chatbotContainer').hide();
            $('#chatbotToggle').show();
        });

        // Cuộn xuống cuối cửa sổ chat khi tải trang
        var chatbotBody = $('#chatbotBody');
        chatbotBody.scrollTop(chatbotBody[0].scrollHeight);
    });

    // Hàm thoát ký tự HTML để tránh XSS
    function escapeHtml(text) {
        var map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // Gửi tin nhắn bằng AJAX
    function sendMessage() {
        var userMessage = $('#userMessage').val().trim();
        if (userMessage === '') return;

        // Thêm tin nhắn người dùng vào giao diện ngay lập tức
        $('#chatbotBody').append('<div class="chat-message user-message">' + escapeHtml(userMessage) + '</div>');
        $('#userMessage').val('');

        // Gửi yêu cầu AJAX đến servlet
        $.ajax({
            url: '${pageContext.request.contextPath}/chat',
            type: 'POST',
            data: { userMessage: userMessage },
            dataType: 'json',
            success: function(data) {
                if (data.error) {
                    $('#chatbotBody').append('<div class="chat-message bot-message">' + escapeHtml(data.error) + '</div>');
                } else {
                    // Thêm phản hồi từ bot vào giao diện
                    $('#chatbotBody').append('<div class="chat-message bot-message">' + escapeHtml(data.response) + '</div>');
                }
                // Cuộn xuống cuối
                $('#chatbotBody').scrollTop($('#chatbotBody')[0].scrollHeight);
            },
            error: function() {
                $('#chatbotBody').append('<div class="chat-message bot-message">Lỗi: Không thể kết nối đến chatbot.</div>');
                $('#chatbotBody').scrollTop($('#chatbotBody')[0].scrollHeight);
            }
        });
    }

    // Gửi tin nhắn khi nhấn Enter
    $('#userMessage').keypress(function(e) {
        if (e.which == 13) {
            sendMessage();
            e.preventDefault();
        }
    });
</script>