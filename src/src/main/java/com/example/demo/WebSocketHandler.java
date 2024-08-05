package com.example.demo;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class WebSocketHandler extends TextWebSocketHandler {

    private static final ConcurrentHashMap<String, WebSocketSession> CLIENTS = new ConcurrentHashMap<String, WebSocketSession>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("WebSocket 연결!!");
    	CLIENTS.put(session.getId(), session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
    	System.out.println("WebSocket 종료!!");
    	CLIENTS.remove(session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String id = session.getId();  //메시지를 보낸 아이디
        System.out.println("WebSocket 받음" + message);
        CLIENTS.entrySet().forEach( arg->{
            if(!arg.getKey().equals(id)) {  //같은 아이디가 아니면 메시지를 전달합니다.
                try {
                	System.out.println("WebSocket 전송 => " + message);
                    arg.getValue().sendMessage(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}