<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 채팅</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/styles/default.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/highlight.min.js"></script>
    <style>
        #chatBox {
            width: 600px;
            height: 400px;
            border: 1px solid #ccc;
            overflow-y: scroll;
            padding: 10px;
            margin-bottom: 10px;
        }
        #messageInput {
            width: 500px;
        }
        pre code {
            background-color: #f4f4f4;
            border: 1px solid #ddd;
            border-left: 3px solid #f36d33;
            color: #666;
            page-break-inside: avoid;
            font-family: monospace;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 1.6em;
            max-width: 100%;
            overflow: auto;
            padding: 1em 1.5em;
            display: block;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <h2>AI 채팅</h2>
    <div id="chatBox"></div>
    <input type="text" id="messageInput" placeholder="메시지를 입력하세요...">
    <button id="sendButton">전송</button>

    <script>
    $(document).ready(function() {
        marked.setOptions({
            highlight: function(code, lang) {
                return hljs.highlightAuto(code, [lang]).value;
            }
        });

        $("#sendButton").click(sendMessage);
        $("#messageInput").keypress(function(e) {
            if(e.which == 13) {
                sendMessage();
            }
        });

        function sendMessage() {
            var message = $("#messageInput").val();
            if(message.trim() === "") return;

            // 사용자 메시지 표시
            $("#chatBox").append("<p><strong>사용자:</strong> " + message + "</p>");

            $.ajax({
                url: "http://localhost:9090/ai",
                type: "GET",
                data: { message: message },
                success: function(response) {
                    // AI 응답을 마크다운으로 렌더링하여 표시
                    var renderedResponse = marked.parse(response.completion);
                    $("#chatBox").append("<p><strong>AI:</strong></p>" + renderedResponse);
                    $("#chatBox").scrollTop($("#chatBox")[0].scrollHeight);
                    $('pre code').each(function(i, block) {
                        hljs.highlightBlock(block);
                    });
                },
                error: function(xhr, status, error) {
                    $("#chatBox").append("<p><strong>오류:</strong> " + error + "</p>");
                }
            });

            $("#messageInput").val("").focus();
        }
    });
    </script>
</body>
</html>
