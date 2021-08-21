package com.example.backend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class FirebaseController {

    @Autowired
    FirebaseMessaging firebaseMessaging;

    @PostMapping("/send")
    public ResponseEntity<Object> sendPushNotification(@RequestBody Map<String,String> request) throws FirebaseMessagingException, JsonProcessingException {

//        System.out.println(new ObjectMapper().writeValueAsString(request));

        Notification notification = Notification
                .builder()
                .setTitle(request.get("title"))
                .setBody(request.get("body"))
                .build();

        Message message = Message
                .builder()
                .setToken(request.get("device_token"))
                .setNotification(notification)
                .build();

       String send = firebaseMessaging.send(message);
        System.out.println(send);
        return ResponseEntity.ok("Success");
    }

}
