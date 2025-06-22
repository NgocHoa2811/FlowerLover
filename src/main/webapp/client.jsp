<%-- 
    Document   : client
    Created on : Jun 22, 2025, 8:15:06 AM
    Author     : hp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("user");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700" rel="stylesheet" />
        <link rel="stylesheet" href="<%= contextPath %>/css/dash-client.css" />
        <link rel="icon" href="<%= contextPath %>/favicon.ico" type="image/x-icon" /> <!-- Thêm favicon -->
        <title>Chăm sóc khách hàng</title>
    </head>
<body>
    <section class="container-client">
        <div class="sidebar" style="justify-content: space-between;">
            <div>
                <button onclick="window.location.href='<%= contextPath %>/dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
                <button onclick="window.location.href='<%= contextPath %>/dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
                <button onclick="window.location.href='<%= contextPath %>/client.jsp'"><span class="material-symbols-outlined">person</span></button>            
            </div>
            <div class="user-actions">
                <a href="#" class="user-icon"><img id="userImage" src="<%= contextPath %>/images/avatar.jpg" alt="User Icon" class="user-image"></a>
                <span class="material-symbols-outlined" onclick="showProfileModal()" title="Chỉnh sửa hồ sơ">account_circle</span>
                <span class="material-symbols-outlined" onclick="window.location.href='<%= contextPath %>/LogoutServlet'" title="Đăng xuất">logout</span>
            </div>
        </div>
        
        <!-- Nội dung chính -->
        <div class="main-content">
            <!-- Dòng tiêu đề -->
            <div class="header">
                Chăm sóc khách hàng
            </div>

            <!-- Ba cột nội dung -->
            <div class="content">
                <div class="column chat-column">
                    <div class="chat-header">
                        <h3>Đoạn chat</h3>
                        <div class="chat-icons">
                            <span class="material-symbols-outlined">more_vert</span>
                            <span class="material-symbols-outlined">edit</span>
                        </div>
                    </div>
                    <div class="chat-messages" id="chatMessages">
                        <!-- Thẻ tin nhắn sẽ được tạo bằng JavaScript -->
                    </div>
                </div>
                <div class="column users-column">
                    <div class="user-header" id="userHeader">
                        <!-- Phần đầu tiên: Avatar, tên, thời gian -->
                    </div>
                    <div class="chat-area" id="chatArea">
                        <!-- Phần thứ hai: Chứa tin nhắn -->
                    </div>
                    <div class="message-input" id="messageInput">
                        <input type="text" id="messageText" placeholder="Nhập tin nhắn...">
                        <span class="material-symbols-outlined icon">sentiment_satisfied</span>
                        <span class="material-symbols-outlined icon">attach_file</span>
                        <button onclick="sendMessage()">Gửi</button>
                    </div>
                </div>
                <div class="column profile-column">
                    <div class="profile-details" id="profileDetails">
                        <!-- Nội dung sẽ được cập nhật khi nhấp vào message -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Include modal hồ sơ -->
        <jsp:include page="profileModal.jsp">
            <jsp:param name="contextPath" value="<%= contextPath %>" />
            <jsp:param name="userEmail" value="<%= userEmail %>" />
        </jsp:include>
    </section>

    <!-- Tham chiếu file JavaScript -->
    <script src="<%= contextPath %>/js/client.js"></script>
    <script>
        // Định nghĩa contextPath và userEmail làm biến toàn cục
        window.contextPath = '<%= contextPath %>';
        window.userEmail = '<%= userEmail %>';

        function showProfileModal() {
            const iframe = document.createElement('iframe');
            iframe.src = window.contextPath + '/profileModal.jsp';
            iframe.style.position = 'fixed';
            iframe.style.top = '0';
            iframe.style.left = '0';
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.border = 'none';
            iframe.style.zIndex = '1000';
            document.body.appendChild(iframe);

            // Gọi hàm showProfileModal từ iframe
            iframe.onload = function() {
                iframe.contentWindow.showProfileModal();
            };

            // Đóng iframe khi nhấp ra ngoài
            iframe.onclick = function(event) {
                if (event.target === iframe) {
                    document.body.removeChild(iframe);
                }
            };
        }

        // Hàm fetchUserImage để cập nhật avatar trong sidebar
        function fetchUserImage(email) {
            fetch(window.contextPath + '/GetUserServlet?email=' + encodeURIComponent(email), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch: ' + response.status);
                return response.json();
            })
            .then(data => {
                const userImage = document.getElementById('userImage');
                if (data.profileImage && !data.profileImage.startsWith("data:image")) {
                    userImage.src = 'data:image/jpeg;base64,' + data.profileImage;
                } else {
                    userImage.src = window.contextPath + '/images/avatar.jpg';
                }
            })
            .catch(error => {
                console.error('Error fetching user image:', error);
                document.getElementById('userImage').src = window.contextPath + '/images/avatar.jpg';
            });
        }

        // Lắng nghe thông điệp từ iframe để reload avatar
        window.addEventListener('message', function(event) {
            if (event.data === 'profileUpdated') {
                fetchUserImage(window.userEmail);
            }
        });

        // Gọi hàm fetchUserImage khi trang được tải
        window.addEventListener('load', () => {
            if (window.userEmail) {
                fetchUserImage(window.userEmail);
            }
        });
    </script>
</body>
</html>