package com.flowershop.util;


import io.github.cdimascio.dotenv.Dotenv;
import java.io.IOException;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.MediaType;
import org.json.JSONArray;
import org.json.JSONObject;

public class ChatbotOpenAI {
    private static final String API_URL = "https://api.openai.com/v1/chat/completions";
    private static final Dotenv dotenv = Dotenv.load(); 
    private static final String API_KEY = dotenv.get("OPENAI_API_KEY");

    public static void main(String[] args) {
        String userMessage = "Xin chào, bạn khỏe không?";
        String response = getChatResponse(userMessage);
        System.out.println("Phản hồi từ chatbot: " + response);
    }

    public static String getChatResponse(String userMessage) {
        OkHttpClient client = new OkHttpClient();

        JSONObject json = new JSONObject();
        json.put("model", "gpt-3.5-turbo");
        JSONArray messages = new JSONArray();
        messages.put(new JSONObject().put("role", "system").put("content", "Bạn là một trợ lý AI thân thiện."));
        messages.put(new JSONObject().put("role", "user").put("content", userMessage));
        json.put("messages", messages);
        json.put("max_tokens", 100);

        RequestBody body = RequestBody.create(MediaType.parse("application/json"), json.toString());
        Request request = new Request.Builder()
                .url(API_URL)
                .header("Authorization", "Bearer " + API_KEY)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Lỗi API: " + response.code() + " - " + response.message());
            }
            String responseBody = response.body().string();
            JSONObject responseJson = new JSONObject(responseBody);
            return responseJson.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");
        } catch (IOException e) {
            e.printStackTrace();
            return "Lỗi khi gọi API: " + e.getMessage();
        }
    }
}